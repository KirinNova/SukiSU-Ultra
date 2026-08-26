#!/bin/sh
set -eu

# 获取内核根目录路径
KERNEL_ROOT=$(pwd)

display_usage() {
    echo "Usage: $0 [--cleanup]"
    echo "  --cleanup:          Cleans up previous modifications made by the script."
    echo "  -h, --help:         Displays this usage information."
    echo "  (no args):          Sets up SukiSU-Ultra builtin environment from KirinNova's repository."
}

initialize_variables() {
    # 适配非GKI传统内核的 drivers 目录路径
    if test -d "$KERNEL_ROOT/drivers"; then
        DRIVER_DIR="$KERNEL_ROOT/drivers"
    else
        echo '[ERROR] "drivers/" directory not found in current path.'
        echo '[HINT] Please run this script from your kernel source root directory.'
        exit 127
    fi

    DRIVER_MAKEFILE=$DRIVER_DIR/Makefile
    DRIVER_KCONFIG=$DRIVER_DIR/Kconfig
}

# 清理脚本引入的更改和软链接
perform_cleanup() {
    echo "[+] Cleaning up SukiSU-Ultra builtin..."
    [ -L "$DRIVER_DIR/kernelsu" ] && rm "$DRIVER_DIR/kernelsu" && echo "[-] Symlink removed."
    if grep -q "kernelsu" "$DRIVER_MAKEFILE"; then
        sed -i '/kernelsu/d' "$DRIVER_MAKEFILE" && echo "[-] Makefile reverted."
    fi
    if grep -q "drivers/kernelsu/Kconfig" "$DRIVER_KCONFIG"; then
        sed -i '/drivers\/kernelsu\/Kconfig/d' "$DRIVER_KCONFIG" && echo "[-] Kconfig reverted."
    fi
    if [ -d "$KERNEL_ROOT/KernelSU" ]; then
        rm -rf "$KERNEL_ROOT/KernelSU" && echo "[-] KernelSU directory deleted."
    fi
    echo "[+] Cleanup completed."
}

# 克隆并配置 SukiSU-Ultra builtin 分支
setup_kernelsu() {
    echo "[+] Setting up SukiSU-Ultra (builtin branch)..."
    
    # 如果本地还没有 KernelSU 文件夹，则克隆指定的仓库和 builtin 分支
    if [ ! -d "$KERNEL_ROOT/KernelSU" ]; then
        git clone -b builtin https://github.com/KirinNova/SukiSU-Ultra.git KernelSU && echo "[+] Repository cloned successfully."
    else
        echo "[+] KernelSU directory already exists, pulling latest changes..."
        cd "$KERNEL_ROOT/KernelSU"
        git pull origin builtin && echo "[+] Repository updated."
        cd "$KERNEL_ROOT"
    fi

    # 创建驱动软链接
    cd "$DRIVER_DIR"
    if [ ! -e "kernelsu" ]; then
        ln -sf "$(realpath --relative-to="$DRIVER_DIR" "$KERNEL_ROOT/KernelSU/kernel")" "kernelsu" && echo "[+] Symlink created in drivers/."
    else
        echo "[+] Symlink already exists."
    fi

    # 自动向 drivers/Makefile 写入编译条目（如果尚不存在）
    cd "$KERNEL_ROOT"
    if ! grep -q "kernelsu" "$DRIVER_MAKEFILE"; then
        printf "\nobj-\$(CONFIG_KSU) += kernelsu/\n" >> "$DRIVER_MAKEFILE"
        echo "[+] Added kernelsu to drivers/Makefile."
    else
        echo "[+] Makefile entry already exists."
    fi

    # 自动向 drivers/Kconfig 写入菜单配置（使用更安全的末尾匹配插入）
    if ! grep -q "drivers/kernelsu/Kconfig" "$DRIVER_KCONFIG"; then
        # 仅在最后一个 endmenu 之前插入，避免多处匹配
        sed -i '$!N; /^\(.*\)\nendmenu$/!P; D' "$DRIVER_KCONFIG" 2>/dev/null || true
        # 如果觉得上面sed太复杂，也可以直接追加到文件末尾（Kconfig 支持在末尾直接 source）
        printf '\nsource "drivers/kernelsu/Kconfig"\n' >> "$DRIVER_KCONFIG"
        echo "[+] Added kernelsu to drivers/Kconfig."
    else
        echo "[+] Kconfig entry already exists."
    fi

    echo '[+] SukiSU-Ultra builtin integration is done!'
}

# 命令行参数分发逻辑
if [ "$#" -eq 0 ]; then
    initialize_variables
    setup_kernelsu
elif [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    display_usage
elif [ "$1" = "--cleanup" ]; then
    initialize_variables
    perform_cleanup
else
    display_usage
    exit 1
fi
