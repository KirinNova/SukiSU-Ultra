SukiSU Ultra

sukisu logo

A kernel-based root solution for Android devices, forked from tiann/KernelSU, and added some interesting changes.

Latest release Channel License: GPL v2 GitHub License
Features

    Kernel-based su and root access management
    App Profile: Lock up the root power in a cage
    Support non-GKI and GKI 1.0
    KPM Support
    Tweaks to the manager theme and the built-in susfs management tool.

Compatibility Status

    KernelSU (before v1.0.0) officially supports Android GKI 2.0 devices (kernel 5.10+).

    Older kernels (4.4+) are also compatible, but the kernel will have to be built manually.

    With more backports, KernelSU can supports 3.x kernel (3.4-3.18).

    Currently, only arm64-v8a, armeabi-v7a (bare) and X86_64(some) are supported.

Installation

See guide/installation.md
Integration

See guide/how-to-integrate.md
Translation

If you need to submit a translation for the manager, please go to Crowdin.
KPM Support

    Based on KernelPatch, we removed features redundant with KSU and retained only KPM support.
    Work in Progress: Expanding APatch compatibility by integrating additional functions to ensure compatibility across different implementations.

Open-source repository: https://github.com/ShirkNeko/SukiSU_KernelPatch_patch

KPM template: https://github.com/udochina/KPM-Build-Anywhere

Note

    Requires CONFIG_KPM=y
    Non-GKI devices requires CONFIG_KALLSYMS=y and CONFIG_KALLSYMS_ALL=y
    For kernels below 4.19, backporting from set_memory.h from 4.19 is required.

Troubleshooting

    Device stuck upon manager app uninstallation? Uninstall com.sony.playmemories.mobile

Sponsor

    ShirkNeko (maintainer of SukiSU)
    weishu (author of KernelSU)

ShirkNeko's sponsorship list

    Ktouls Thanks so much for bringing me support.
    zaoqi123 Thanks for the milk tea.
    wswzgdg Many thanks for supporting this project.
    yspbwx2010 Many thanks.
    DARKWWEE 100 USDT
    Saksham Singla Provide and maintain the website
    OukaroMF Donation of website domain name

License

    The file in the “kernel” directory is under GPL-2.0-only license.
    The images of the files ic_launcher(?!.*alt.*).* with anime character sticker are copyrighted by 怡子曰曰, the Brand Intellectual Property in the images is owned by 明风 OuO, and the vectorization is done by @MiRinChan. Before using these files, in addition to complying with Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International, you also need to comply with the authorization of the two authors to use these artistic contents.
    Except for the files or directories mentioned above, all other parts are under GPL-3.0 or later license.

Credit

    KernelSU: upstream
    MKSU: Magic Mount
    RKSU: support non-GKI
    susfs: An addon root hiding kernel patches and userspace module for KernelSU.
    KernelPatch: KernelPatch is a key part of the APatch implementation of the kernel module

KernelSU's credit

