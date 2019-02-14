# oiledmachine-overlay

This portage overlay contains various ebuilds for the Gentoo Linux distribution.  It focuses on optimized ebuilds, some game development, software used in computer science courses, C#, and other legacy software and hardware.

In this overlay, I provide 32-bit ebuilds for libraries and programs of some programs while the Gentoo overlay contains native ebuilds.  Reason why I choose to use the 32-bit versions over the 64-bit versions because of the 32-bit versions have a lower virtual memory and lower memory footprint overall.  I try to offer the stable modified ebuilds to minimize memory leaks.

IMPORTANT:  Many of these packages have special licenses and EULAs attached to them.  I recommend that you edit your /etc/portage/make.conf so it looks like this ACCEPT_LICENSE="-*" and manually accept each of the licenses.  Licenses can be found in the licenses folder of this overlay and the free copyleft licenses can be found on the official gentoo overlay in their license folder too.

IMPORTANT:  Many of these packages especially non-free software also require you to manually obtain the installer or files to install and may require you to register on their website.  The required files are listed in the ebuild.

Here is an example of what I mean.

IMPORTANT:  For Firefox, Chromium, surf, you need to copy the contents of profiles/package.use.force from the overlay to your /etc/portage/profile/package.use.force to ensure that you can mutually exclusively choose between either 64- or 32-bit compiled builds for multilib environments.  The package.use.force from the overlay will not work as expected because of a quirk or a bug in emerge.  The 32-bit builds are perceived to be better under heavy memory loads compared to the native 64-bit compiles of these packages.  If you run a 64-bit multilib environment, choose the 32-bit build instead.

The dev-dotnet folder contains fixes for both dotnet overlay and shnurise overlay ebuilds.  They many of the ebuilds in that folder in this overlay are dependencies for the latest stable MonoDevelop and for MonoGame.

The name of the repo comes from "well-oiled machine."  A (Gentoo) computer should not feel like molasses under high memory pressure or heavy IO utilization.  It should run smoothly.

| package | decription |
| --- | --- |
| www-client/firefox | This ebuild helps build 32-bit only Firefox on a multilib machine.  See important above for details to properly set flags.  It also contains the recent large emoji fix and emoji selection bug fix for 52.x.  It requires Rust and Cargo from this repo to build the 32-bit rustlib and for 32-bit Firefox 57.x to link to them. |
| www-client/chromium | This ebuild helps build 32-bit only Firefox on a multilib machine.  See important above for details to properly set flags |
| www-plugins/chrome-binary-plugins | This ebuild helps build 32-bit only builds on a multilib machine.  See important above for details to properly set flags.  This ebuild is abandoned. |
| net-libs/webkit-gtk | This ebuild helps build 32-bit only builds on a multilib machine.  See important above for details to properly set flags. |
| www-client/surf | **WARNING!!! If you emerge this, it may delete your saved config located in /etc/portage/savedconfig/www-client/{surf-2.0,surf-0.6-r2}.  Backup it up.** surf is a WebkitGTK based browser.  This package contains added built-in ad-blocking support even in SSL.  Fixes were added to support for Facebook.  Support was added for GTK3 smooth scrolling.  Additional added support for external apps for desktop environment MIME to program association, external Flash video for some sites [helper scripts may require updating], and link highlighting.  <br /><br />The 0.6-r2 in this overlay has new window fixes.  It also doesn't create a new instances of itself.  It uses WebKit2 to handle that.  When it creates windows, it uses only one surf instance and new windows act like tabs.  The one by czarkoff and kaihendry and the original surf both create new windows and new WebKitWebProcesses per each new window.  So, my version has a lower memory footprint.  <br /><br />Read the licenses/SURF-community before emerging it.  <br /><br />To update the surf adblocker you need to go to /etc/surf/scripts/adblock and run the update.sh script. <br /><br /> In the 2.0 ebuild, I removed the patches to GTK3 but it most likely doesn't use the custom GTK3 patches in 0.6-r2.  |
|sci-misc/boinc-server | This is essentially a BOINC server maker with my personal helper scripts.  The Science overlay and Gentoo overlay do not have this.  Use emerge --config boinc-server to create your own BOINC Server project with the boinc-server-maker.  It will do everything for you except installing the application.  You must provide the executibles and template files.  See sci-misc/boinc-server-project-coinking and sci-misc/boinc-server-project-eligius for examples on how to integrate your application.  You should be able to edit those helper scripts (e.g. fresh-update, update_app) to fit your project.  Copy and use update-binaries script in your project every time you upgrade your server |
| sci-misc/boinc-server-project-coinking | This is a Coinking mining pool BOINC server project example.  Coinking is defuct.  This was used as a test case to see if the helper scripts work. |
| sci-misc/boinc-server-project-eligius | This is an Eligius mining pool BOINC server project example.  This ebuild demonstrates how to build a setiathome-server project using helper scripts.  You can copy this ebuild and modify it for your BOINC server project.  |
| virtual/setiathome | This is a virtual meta package to handle emerging setiathome and astropulse ebuilds.  You should just add this to the world file and let emerge pull the proper packages.  Do not emerge individual setiathome/astropulse and dependencies. |
| sci-misc/setiathome-gpu | This package builds a Seti@home version 8 client for the GPU.  Added 3D BOINC screensaver support on GPUs which is not part of the official sources.  Support for recommended GPU settings.  Using `ati_hd5xxx` and `ati_hdx7xx` for example targets ATI HD 57xx edition.  For example, the binaries provided from upstream only utilize 1 thread per GPU by default.  These GPU ebuilds use the recommended 2-4 threads per GPU depending on the particular video card quality or GPU specified in the README.  This needs testing since upstream keeps messing with the OpenCL near the OpenGL code to reintroduce the OpenGL screensaver.  Read the ebuild in how to properly enable your video card.  You need to add the USE flag for your arch and your work unit plan class (`x32` [which is x86], `x64` [which is x86_64], `ppc`, `ppc64`, `arm` with either `armv6-neon-nopie`, `armv6-neon`, `armv6-vfp-nopie`, `armv6-vfp`, `armv7-neon`, `armv7-neon-nopie`, `armv7-vfpv3`, `armv7-vfpv3d16`, `armv7-vfpv3d16-nopie`, `armv7-vfpv4`, `armv7-vfpv4-nopie`); then you add your manufactuer (`video_cards_fglrx`, `video_cards_nvidia`, `video_cards_intel`); then you add your video card class type (see gpu_setup function); then add the SDK (`cuda`, `opencl`).  OpenCL has only been tested.  Some parts of the GPU program need the CPU.  You can only use only one SIMD feature (`avx2`, `avx-btver2`, `avx-bdver3`, `avx-bdver2`, `avx-bdver1`, `avx`, `sse42`, `sse41`, `ssse3`, `sse3`, `sse2`, `sse`, `mmx`, `3dnow`, `altivec`, or none) ordered from best to worst.   The plan classes are defined server-side but the ebuild tries to do the easy work for you.  You may need to add your plan class to the ebuild.  You can find a list of plan classes at https://setiathome.berkeley.edu/apps.php . <br /><br />  You must set X and Y to an integer number for SETIATHOME_GPU_INSTANCES="X" SETIATHOME_CPU_INSTANCES="Y" in your make.conf to control the number of GPU or CPU threads.  Set Y to the number of cores in your CPU, but the ATI/Intel/Nvidia OpenCL Astropulse documentation in the "Best usage tips" section recommends one less CPU instance to get enough GPU usage.  Set X to recommended values for your video card by the BOINC developers in the below documentation but less than 64.  Also consider reserving other cores for other BOINC projects. See sci-misc/astropulse-gpu for links below for more information about running multiple instances/threads.  |
| sci-misc/setiathome-cpu | This package builds a Seti@home version 8 client for the CPUs.  Support for automated ebuild level GCC/LLVM PGO for all.  You need to choose your arch (`ppc`, `ppc64`, `x32` [which is x86], `x64` [which is x86_64], `arm`); then choose only one SIMD (`avx2`, `avx-btver2`, `avx-bdver3`, `avx-bdver2`, `avx-bdver1`, `avx`, `sse42`, `sse41`, `ssse3`, `sse3`, `sse2`, `sse`, `mmx`, `3dnow`, `altivec`, or none) ordered from best to worst.  <br /><br />PGO requires 3 phases: compile the program to add instrumentation to it, simulate the program with the instrumented program, then recompile the program based on the data gathered by the instrumented build.  It could result in 30% performance increase.  You can use the USE flag `pgo` or use my systemwide-pgo ebuild.  The USE flag `pgo` does unrealistic simulation using test workunits and unreal environment but is automated and short and does only one run.  The portage-bashrc/systemwide-pgo method uses real workunits and real world environment and maybe a week of simulation which is preferred.  You need Clang 3.7 or above or GCC to use both PGO methods.  PGO only works on CPU based ebuilds. |
| sci-misc/astropulse-cpu | This package builds a Astropulse version 7 client for CPUs.  Support for automated ebuild level GCC/LLVM PGO for all.  Support for automated ebuild level GCC/LLVM PGO for all.  You need to choose your arch (`ppc`, `ppc64`, `x32` [which is x86], `x64` [which is x86_64], `arm` with `armv6-neon-nopie`, `armv6-neon`, `armv6-vfp-nopie`, `armv6-vfp`, `armv7-neon`, `armv7-neon-nopie`, `armv7-vfpv3`, `armv7-vfpv3d16`, `armv7-vfpv3d16-nopie`, `armv7-vfpv4`, `armv7-vfpv4-nopie`); then choose only one SIMD (`avx2`, `avx-btver2`, `avx-bdver3`, `avx-bdver2`, `avx-bdver1`, `avx`, `sse42`, `sse41`, `ssse3`, `sse3`, `sse2`, `sse`, `mmx`, `3dnow`, `altivec`, or none) ordered from best to worst. |
| sci-misc/astropulse-gpu | This package builds a Astropulse version 7 client for GPUs.  You need to add the USE flag for your arch (`x32` [which is x86], `x64` [which is x86_64], `ppc`, `ppc64`, `arm`); then you add your manufactuer (`video_cards_fglrx`, `video_cards_nvidia`, `video_cards_intel`); then you add your video card class type (see gpu_setup function or setiathome-gpu section); then add the SDK (`cuda`, `opencl`).  OpenCL has only been tested.  Some parts of the GPU program need the CPU.  You can only use only one SIMD feature (`avx2`, `avx-btver2`, `avx-bdver3`, `avx-bdver2`, `avx-bdver1`, `avx`, `sse42`, `sse41`, `ssse3`, `sse3`, `sse2`, `sse`, `mmx`, `3dnow`, `altivec`, or none).  <br /><br /> You must set X and Y to an integer number for SETIATHOME_GPU_INSTANCES="X" SETIATHOME_CPU_INSTANCES="Y" in your make.conf to control the number of GPU or CPU threads.  Set Y to the number of cores in your CPU, but the ATI/Intel/Nvidia OpenCL Astropulse documentation in the "Best usage tips" section recommends one less CPU instance to get enough GPU usage.  Set X to recommended values for your video card by the BOINC developers in the below documentation but less than 64. Also consider reserving other cores for other BOINC projects. <br /><br />  See following documenation about running instances on both GPU and CPU: <br /> https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AKv8/client/ReadMe_MultiBeam_OpenCL.txt<br /> https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_Brook.txt<br /> https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_CPU.txt<br /> https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_CPU_AMD.txt<br /> https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_OpenCL_ATi.txt<br /> https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_OpenCL_Intel.txt<br /> https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_OpenCL_NV.txt<br /> https://setisvn.ssl.berkeley.edu/trac/browser/branches/sah_v7_opt/AP_BLANKIT/client/ReadMe_AstroPulse_OpenCL_NV_CC1.txt<br /> |
| sci-misc/setiathome-art | This package contains Seti@home art assets to prevent merging conflicts. |
| sci-misc/astropulse-art | This package contains Astropulse art assets to prevent merging conflicts. |
| sci-misc/setiathome-cfg | This package updates anonymous platform configuration files for setiathome-{cpu,gpu},astropulse-{cpu,gpu}.  You must run this every time you upgrade setiathome-{cpu,gpu} and/or astropulse-{cpu,gpu}. |
| net-misc/boinc-bfgminer-gpu | This is a modified BFGMiner with BOINC support for GPUs.  It requires the BOINC wrapper sample app.  See sci-misc/boinc-server-project-eligius ebuild on in how to use it.  The reason why I have BOINC support so we can have the BOINC client manage project switching or CPU/GPU resources based on user activity (e.g. mouse move).  It still may be buggy. |
| net-misc/boinc-bfgminer-cpu | This is a modified BFGMiner with BOINC support for CPUs.  It requires the BOINC wrapper sample app.  It contains ebuild level support for Profile Guided Optimizations (PGO).  It still may be buggy. |
| net-misc/rainbowstream | This is a Twitter command line client. |
| net-misc/googler | This is a Google command line client. |
| dev-python/twitter | This is a Twitter command line client and library with fixed search and patched ANSI output. |
| dev-util/depot_tools | This package contains development tools for Google projects.  It's useful for checking out v8, the JavaScript engine behind Chromium. |
| media-sound/lastfm | This is for Last.fm API for Python.  I don't know why this is here. |
| media-sound/lastfmsubmitd | This was patched with Last.fm API v2.0. |
| media-sound/mplayer-lastfm-scrobbler | This is a scrobbler for MPlayer. |
| dev-python/arrow | This library is for time creation and manipulation for Python. |
| dev-python/pocket | This is the Pocket API for Python. |
| dev-python/py-libmpdclient2 | This is a MPD client library for Python. |
| dev-python/pyfiglet | This is a Python library for ASCII art used by rainbowstream used to draw ASCII art in command line. |
| media-video/mplayer | This package contains broken [as to be fixed] Last.fm support for MPlayer.  It requires mplayer-lastfm-scrobbler package in this overlay. |
| app-emulation/genymotion | This package is Genymotion with third party hacks support.  It installs Genymotion from the installer package from genymotion.com and has extra dependency checks. |
| net-misc/bitlbee | This package fixed support for Skype through libpurple.  I haven't uploaded this upstream. |
| app-eselect/eselect-opencl | This package provides eselect switch support between SDK libraries and driver OpenCL implementation.  For example, you will need to add icd profiles in /etc/OpenCL/profiles that match the format /etc/OpenCL/profiles/${VENDOR}/${VENDOR}ocl{32,64}.icd.  The eselect module will map one of those OpenCL profiles to /etc/OpenCL/vendors/ocl{32,64}.icd so you can switch between the SDK or driver.  Your OpenCL app will recognize the OpenCL library version. |
| sys-process/psdoom-ng | This is a process killer based on Chocolate Doom 2.2.1 with man file and simple wrapper. |
| net-analyzer/wireshark | This ebuild integrats MTP (Media Transfer Protocol) packet filter.  It also warns of MTPz authentication handshake points in the Expert info.  You may need to modify in the source code level the interface number, vendor ID, device ID for your USB to match your particular device since I didn't write the GUI interface for that yet. |
| portage-bashrc/systemwide-pgo | This package installs Profile Guided Optimization management scripts for portage.  Everyone keeps building a per package PGO ebuild with a USE flag, but this package provides more better integration and ease of the process by forcing Portage do the work.  It still needs more testing and is considered in development.  It has @pgo-update set support.  It requires GCC or LLVM/Clang >=3.7 support since <3.7 breaks library profiling and has an annoying set environmental variable feature before profiling.  We use --profile-generate instead on LLVM/Clang.  Users need to be added to the wheel group to simulate the program.  You should disable all PGO USE flags and allow the scripts use it properly.  The package uses a whitelist and phase file to manage it.  Instructions are given at the end of the ebuild. |
| games-engines/monogame | This is probably the only portage overlay that has it.  If you use the add-in for MonoGame 3.5.1, it could only work for MonoDevelop 5.x series.  MonoGame 3.6 add-in should work for MonoDevelop 6.x series.  This one requires that mono, monodevelop, nvidia-texture-tools from this overlay.  I disabled NUnit on those and split it off into its own ebuild.  The latest LLVM is required for CppSharp.   You also need to set LIBGL_DRIVERS_PATH environmental variable in your MonoDevelop or wrapper script to /usr/lib/dri before running the app. <br /><br /> The package still needs testing.  I striped out lidgren and made an ebuild for it and use lidgren-network-gen3.  The OpenTK and Tao Framework were binary only and I used a compiled version from my ebuilds for the GamePad library.  SDL 1 is required for the GamepadConfig since Tao Framework uses SDL1.  The SDL2 is also required for the OpenTK library.  <br /><br />  If you create a new solution in MonoGame, you should answer no to override the Tao.Sdl.dll.config and OpenTK.dll.config File Conflicts Dialog Box.  The one provided has absolute paths to the required libraries and Linux support.  <br /><br />  If you get a red x dot in MonoDevelop complaining about an assembly (nvorbis for example) for MonoGame, the game will compile and run still.  <br /><br />  The ebuild uses dev-dotnet/managed-pvrtc without USE flag.  Please read the dev-dotnet/managed-pvrtc below before distributing or using  it.  <br /><br />  Again, I need people who have used this library to test this ebuild and the tools (mgcb, pipeline).  <br /><br />  Also, this is a Linux only ebuild which means it will only build games for Linux.  You cannot use it to port to other platforms (Android, Apple TV, iOS) because Xamarin Studio is not in Linux which required to port to mobile. |
| dev-dotnet/atitextureconverter | You don't need the actual proprietary library to compile MonoGame.  The wrapper alone will do fine in order to use MonoGame.  You need to manually install the proprietary library if you have the hardware.  Instructions are provided in the library to obtain and place it. |
| dev-dotnet/pvrtexlibnet | You should stay away from this one but it may be required for compiling MonoGame which I didn't take the time to turn off.  Basically pvrtexlibnet is another C# wrapper around the propretary PVRTexLib library blob from Imagination Technlogies.  You need to download the library there.  The binary library blob uses the PVRTC compression (https://en.wikipedia.org/wiki/PVRTC) which is patented.  The license in those libraries are restricted.  There is a bindist flag for this one.  Using the bindist will not install the propretary library and proprietary documentation just the wrapper.  Delete the PVRTexLib from that this ebuild uses and use the one from Imagination Technlogies. |
| dev-cpp/cppsharp | This one requires LLVM from this overlay to install additional headers.  It was going to be used for NVTT.net but it turns out nvidia-texture-tools has the C# language binding.  I don't currently use it for any ebuilds I use, but it is offered here.  It still needs testing.  It requires LLVM package from this overlay.  You need LLVM >=3.9.0 to build it from this overlay. |
| media-gfx/nvidia-texture-tools | This one builds the C# language binding and nvtt native library required for MonoGame.  You need to install this one from the repository for MonoGame to compile correctly.  This ebuild generates Nvidia.TextureTools.dll per each vc{10,8,9,12,monogame} because upstream don't delete one of them so a consumer may depend on the old one.  You need to enable the `monogame` USE flag to generate the proper older Nvidia.TextureTools.dll. |
| media-video/epcam | Epcam is a driver for support for webcams based on EP800/SE402/SE401 chip.  It uses sources from https://github.com/orsonteodoro/gspca_ep800.  This driver differs from the main kernel driver in that it supports the newer reference firmware.  It still needs testing for runtime breakage. |
| dev-lang/alice | This is the ebuild for educational object oriented programming language used for beginner programmers and students.  It is useful for learning the fundamentals of game programming.  People with dwm window manager or parentless window managers need to use wmname to properly render windows for this java program.  The ebuild that I offer is Alice 3.  http://www.alice.org/index.php for more details.  Emerging alice:2 will install Alice 2 and emerging alice:3 will install Alice 3.   You can install both at the same time.  Both have wrapper scripts (alice2, alice3) that make it easier to run them from dmenu.  Alice 3 doesn't feel hardware accelerated compared to Alice 2. |
| dev-lang/qb64 | This is a freeware QBasic clone.  It has similar look and feel as QBasic. |
| dev-lang/gambas | Gambas is based on the BASIC programming language dialect.  It is basically a Visual Basic clone.  Version 3.8.4 is in this overlay.  Use the `ide` USE flag to build the IDE.  You can make games with it and has support for OpenGL. |
| dev-lang/turboturtle | This package uses a wrapper /usr/bin/turboturtle to dump the code to current working directory.  Read more about turtle graphics at http://www.fascinationsoftware.com/FS/html/TurboTurtle.html . |
| game-engines/godot | Godot is an open source alternative to the Unity Game Engine.  This one is the 2.0 beta.  It also installs the demos in /usr/share/godot.  I recommend the platformer demo to test the sound and hardware accelerated OpenGL. |
| dev-embedded/modelsim | This is an ebuild to help install it on Gentoo Linux.  You still need to download the installer manually and place it into /usr/bin/distfiles.  It will preform an unattended install with a desktop menu item and wrapper script /usr/bin/modelsim.  Use desktop-menu-fix to properly run it on Xfce4 menu or other window managers.  See  https://en.wikipedia.org/wiki/ModelSim for details about this software.  It will help install ase and ae editions. |
| game-engines/enigma | Enigma is a Game Development environment that is similar to GameMaker.  More information can be found in https://enigma-dev.org/docs/Wiki/ENIGMA .  Basically LateralGM is the Level Editor like GameMaker's and ENIGMA is a toolchain and collection of projects.  ENIGMA will compile scripting portion of EDL which is the counterpart to GML with C++.  LateralGM is written in Java and ENIGMA is written in C++.  ENIGMA is a plugin that plugs into LateralGM.  EDL is mostly backwards compatibile with GMK scripting language.  It is GPL-3 licensed. <br /><br /> Currently compiling by command line is broken.  You must use LateralGM to build your ENIGMA game.  I am currently trying to fix this. |
| games-misc/lgmplugin | This is the ENIGMA plugin wrapper.  It is a middle man between LateralGM and the ENIGMA compiler.  The lgmplugin can be used by GUI (through LateralGM) or CLI (command line) but currently the CLI is broken.  It was written in Java.  I am investigating why it is broken. |
| games-misc/lateralgm | LateralGM for the ENIGMA development environment.  It was written in Java.  This is basically the level editor. |
| games-misc/libmaker | This is the Library editor for ENIGMA and GameMaker.  It was written in Java.  More information can be found at https://enigma-dev.org/docs/Wiki/Library_Maker. |
| games-engines/urho3d | Urho3D is another game engine.  Android support is incomplete.  Raspberry PI is untested.  It is a split ebuild meaning that it many of the internal dependencies are now ebuilds like the Gentoo way.  Most of the demos work as expected.  There may be quirks.  If you see any that bother you, then use the internal dependency instead.  Enable box2d for 2d-physics.  Enable bullet for 3d-physics.  Enable recast for 3D pathfinding. |
| games-engines/urho3d-web | This is the Emscripten compiled ebuild.  It still requires Urho3D for the include headers. |
| dev-lua/tolua++ | tolua++ is a Lua-C++ bindings generator more improved than tolua.  I recommend the `urho3d` USE flag to enable some bugfixes.  This one is used by Urho3D. |
| dev-lua/tolua | tolua is another Lua-C++ bindings generator.  It is not used by Urho3D. |
| media-sound/w3crapcli-lastfm | These are shell scripts to allow for Last.fm support for mpv.  This one was modified a bit for Last.fm 2.0 API.  You need your own an developer API key from last fm to use it.  It has last played support as well.  The one on w3crapcli Github repository uses an external bloated dependency. |
| dev-embedded/xilinx-ise-webpack | This ebuild helps install ISE Webpack on Gentoo systems.  It is fetch restricted so you need to register to download it and you need read the license in the license folder of this overlay and add the license keyword to the ACCEPT_LICENSE environmental variable in your make.conf.  Xilinx ISE is an IDE used to program FPGAs in VHDL for example.  You also need around 24.128G of free space and several hours of install time because it has to transfer the file from /usr/portage/distfiles to the /var/tmp/portage/${CATEGORY}/${PF}/tmp folder to mark it executible, unpacks the package into /var/tmp/portage/${CATEGORY}/${PF}/image, then checks the libraries for TEXTRELS and execstack checks for hundreds of objects, then dumps it finally to the system.  emerge throws a lot of QA security warnings for this package.  The build will also install wrapper scripts ise64 or ise32 for dmenu.  It will install a desktop menu item as well for Xfce4 and other popular desktops. |
| dev-embedded/diligent-adept2-runtime | This ebuild helps install it on Gentoo systems.  The original installer did not recognize the 4.x kernels and did not install udev rules in the recommended place in /lib/udev/rules.d.  The Gentoo Wiki doesn't have an explicit proper fix for 4.x kernels if you don't think. |
| dev-embedded/diligent-plugin-xilinx | This ebuild helps install it on Gentoo systems.  It requires dev-embedded/xilinx-ise-webpack and dev-embedded/diligent-adept2-runtime.  The ebuilds will automatically check for dependencies. |
| dev-embedded/avr-studio | This ebuild that helps install avr-studio using wine which is unsupported.  You need to run /usr/share/avr-studio/install.sh because it uses winetricks.  The sources of winetricks I don't really trust so you can only use the script on a limited user.  Only the 4.19 is offered since it can only do unattended install and it is rated gold on winedb.  To get the pretty icon use the `ico` USE flag.  I didn't really test it fully but the GCC plugin needs to be configured to use the GCC.  I am considering creating a new overlay just for wine apps recipies. |
| www-client/phantomjs | It should fix the rendering on some sites like Facebook.  It contains a fixed QTWebKit emoji crash bug. |
| www-client/casperjs | It looks like it works with PhantomJS 2.1.1. |
| media-fonts/noto-color-emoji | This currently supports Emoji 5.0. This one you can use to compile noto color emoji.  The benefit is that you can get updated emojis.  You may need to do a `eselect fontconfig enable 01-notosans.conf` and `eselect fontconfig disable 70-no-bitmaps.conf` followed by a `fc-cache -fv`.  All the required dependencies have been sorted and will require x11-libs/cairo from this repo.  This one is better because this one supports all apps.  It is unlike EmojiOne font which only has colored emojis for Firefox and rest of the other apps that use the EmojiOne font are just rendered as black and white.  It's kind of disappointing that this has not been added in the official repository.  If you want u263a white smiling emoji to be colored emoji presented in Firefox and Chromium, you need to `eselect fontconfig enable 61-notosans.conf` followed by a `fc-cache -fv` to update.  Do the same for 44-notosans.conf for command line fix.  This one also contains black smiling face emoji to replace the text presentation unlike the -bin.|
| media-fonts/noto-color-emoji-bin | This one has been precompiled and from the Google website.  You may need to do a `eselect fontconfig enable 01-notosans.conf` and `eselect fontconfig disable 70-no-bitmaps.conf` followed by a `fc-cache -fv`.  If you want u263a white smiling emoji to be colored emoji presented in Firefox and Chromium, you need to `eselect fontconfig enable 61-notosans.conf` followed by a `fc-cache -fv` to update.  Do the same for 44-notosans.conf for command line fix. |
| x11-libs/cairo | This one has colored emojis enabled. |
| x11-wm/dwm | This ebuild fixes the emoji titlebar crash and has integrated Fibonacci layout patch applied. |
| media-gfx/caesiumclt | This is a command line image compressor for PNG and JPEG files. |
| media/mozjpeg | This is a dependency for CaesiumCLT. |
| www-misc/facy | This is a command line Facebook client.  Update with missing Facebook API calls.  Used CasperJS and PhantomJS to fill in the missing API calls.  This ebuild add enhancemences such as command line video support, YouTube support, and use of color emojis, better handling of shared Spotify playlists. |
| dev-dotnet/mono-packaging-tools | This ebuild from this overlay has the working mpt-sln.  Upstream is bugged [but now is fixed].  It is used to delete the fsharp projects from the MonoDevelop ebuild. |
| sys-devel/llvm | This exposes some codegen code for CppSharp with the `codegen` USE flag. |
| dev-net/protobuild | This uses Protobuild.exe to generate the solution/project(s) then these are fed into Mono to generate again Protobuild.exe.   We do not know if the first encountered Protobuild.exe is safe to use.  This is required to generate MonoGame project files.  MonoGame comes with binary protobuild.exe, but we are gentoo.  We compile everything from the source code. |
| dev-dotnet/koala | This package is for facy.  It is used to interact with the Facebook Graph API in Ruby. |
| media-gfx/libcaca | This library contains an experimental special 256 color patch from Ben Wiley Sittler.  I don't know if the patch actually works from emperical tests.  Maybe it is just me or I forward patched it wrong.  I use the experimental 256 color for facy to render Facebook photos, animated GIFs, and Facebook videos to try to better render skin color.  I still think Termpic colors rendering is better. |
| games-engines/fna | This is an XNA4 ebuild which just produces a C# assembly.  This project sadly doesn't have a MonoDevelop add-in.  This ebuild is provided for others to fix and expand. |
| dev-dotnet/{mojoshader-cs, openal-cs, sdl2-cs, theoraplay-cs, vorbisfile-cs} | These are dependencies for FNA which need testing.  Looks like it hasn't been extensively tested on Linux. |
| media-libs/theoraplay | This needs testing. |
| games-misc/sharpnav | This library is a AI pathfinding library in C# useful for games. |
| games-misc/tiledsharp | This library is a map loader in C# for the Tiled Map Editor. |
| sci-physics/farseer-physics-engine | This is a physics engine based on Box2D and is a C# library.  This one also has support for MonoGame. |
| dev-dotnet/aforgedotnet | This is the AForge.NET library containing computer vision and aritificial intelligence algorithms.  Kinect (via libfreenect) support untested.  References to FFmpeg were untested.  The package needs testing.  The author said that the video isn't feature complete on Mono for Linux. |
| games-misc/beatdetectorforgames | This is a FMOD based beat detector which may be useful for rhythm games.  It has support for both C++ and C#.  The C# is a wrapper around the FMOD library.  The author said there wasn't Linux support but it could happen because there is a FMOD library in the main Gentoo overlay.  It still needs testing. |
| dev-dotnet/tesseract | This is a C# binding to the Tesseract OCR (Optical Character Recognition) software which will allow your program to read material produced by typewriters and from books. |
| sci-physics/libbulletc | This library is a dependency for BulletSharpPInvoke.  It combines all modules, which were originally seperate dlls, into one shared object/dll. |
| dev-dotnet/bulletsharppinvoke | This is a C# wrapper for libbulletc used for realistic physics in games. |
| games-misc/monogame-extended |  This contains several common modules found in game engines like a particle engine, based on Mercury Particle Engine, and a tiled map loader for maps created by the Tiled Map Editor.  Currently a vanilla build of MonoGame stable doesn't support shaders on Linux so some features will not work for this assembly. |
| dev-dotnet/freenect | This is a C# wrapper for the libfreenect for the XBox Kinect camera. |
| dev-util/ycmd | This is a YouCompleteMe server.  Just add your ycmd client to your text editor then you have code completion support.  The 2014 ebuild is for older clients.  The 2017 ebuilds require clients use the new HMAC header calculation.  It supports C#, C, C++, Objective C, Objective C++, rust, go, javascript, typescript, python.  If you use the `javascript` or `typescript` USE flag, then you need to add the jm-overlay to pull in the dev-nodejs packages. |
| dev-util/gycm | Gycm is a Geany plugin and ycmd client to improve IntelliSense support on top of the stock completer. |
| dev-util/emacs-ycmd | This is a ycmd client for Emacs. |
| dev-util/ycm-generator | You need this if you want c/c++/objc/objc++ support with your ycmd client.  It is mandatory for those languages. |
| app-editors/nano-ycmd | This is a modified GNU nano that uses ycmd.  It is still experimental. |
| dev-dotnet/omnisharp-server | This is an older OmniSharp that ycmd still depends on.  This allows for IntelliSense for open source editors. |
| dev-dotnet/omnisharp-roslyn | This is the newer OmniSharp.  ycmd can use this but with a special patch. |
| app-emacs/omnisharp-emacs | This one depends on omnisharp-server.  It allows Emacs to use C# with IntelliSense. |
| app-emacs/company-mode | This is for code completion for Emacs. |
| app-emacs/flycheck | This is a syntax checker for Emacs. |
| app-emacs/omnisharp-emacs-roslyn | This one doesn't work.  It is still in the repo for testing and for developers to fix.  It is basically omnisharp-emacs but using the roslyn branch. |
| dev-util/monodevelop | This contains frozen versions and commit hashes for the dependencies that the package eventually checks and pulls in instead of following head for dependencies. |
| x11-drivers/ati-drivers | This contains a working OpenCL with proper dependencies for old =xorg-server-1.17 and kernel version =4.1.43 or <= 4.4.  It will present security holes both in the kernel and X.Org Server so use at your own risk.  The ebuild does extra checks to see if you have the proper versions for dependencies.  You need the XServer in this overlay since these older XServer versions do not exist in Portage.  This older package is for older ATI video cards with OpenCL.  You must add >=x11-base/xorg-server-1.18 >x11-drivers/xf86-input-evdev-2.10.3 =dev-libs/libevdev-9999 to package.mask. |
| sci-geosciences/googleearthpro | This is a working ebuild of Google Earth Pro.  The Gentoo overlay had abandoned the old Google Earth ebuild. |
| sys-power/cpupower-gui | This is a package for a graphical user interface (GUI) for changing the CPU frequency limits and the governor.  It needs elevated privileges to use it like with sudo. |
| media-libs/libjpeg-turbo | This package contains `jpeg7`, `jpeg8`, `jpeg6b` USE flags to target various API compatibility.  This compatibility is not feature complete or will not be included.  FreeImage modified with libjpeg-turbo support requires at least `jpeg7` (or higher) USE flag.  You will need to update your libraries with `revedep-rebuild --library libjpeg.so` or programs like Evince will break if dependencies are not updated.
| www-misc/socli | This is a Stack Overflow command line client. |
| x11-misc/emoji-keyboard | This is an emoji keyboard for Linux. |
| app-shells/emoji-cli | This is an emoji autocompletion plugin for Zsh.  You might want to combine it with emojify. |
| app-shells/emojify | This is a BASH shell script to convert emoji aliases described in English words into Unicode equivalent to display the emoji. |
| app-shells/oh-my-zsh | Oh My Zsh are extra themes and plugins to enhance Zsh.  This ebuild allows to pick specific themes and plugins and to get rid of the ones you don't need. |
| www-misc/ddgr | This is a command line DuckDuckGo similiar to googler. |
| www-misc/rtv | This is a command line Reddit client which has been updated. |
| www-misc/ramme | An unofficial Instagram client that works on Linux using Node.js and Electron. |
| sys-kernel/genkernel | This is a modified genkernel with subdir_mount use flag to mount the system from a folder other than / and crypt_root_plain use to mount plain mode dm-crypt.  For crypt_root_plain kernel option, you provide the path from /dev/disk/by-id/ .  For subdir_mount, you provide the path to the folder.  See https://github.com/orsonteodoro/muslx32#notes for details on how to use subdir_mount.
| sys-kernel/ot-sources | This package contains a collection of patches.  It contains UKMS, zen-tune, GraySky2's kernel_gcc_patch (more marchs for 4.x and 8.x gcc), MuQSS CPU scheduler, PDS CPU scheduler, genpatches (kernel updates), BFQ updates, AMD kernel updates, TRESOR cold boot resistant patch, O3 optimize harder patch.  The 4.20 series will use the amd-staging-drm-next branch but you can choose EITHER all the patches up to the latest amd-18.50 commit OR the latest commit from amd-staging-drm-next with amd-testing use flag.  The 4.18 series will use the amd-18.50 branch.  The TRESOR patch is experimental with for x86_64 arch.  It may take hours to clone the AMD repositories.  If you want to use the proprietary AMD driver, I recommend using this kernel if you want freesync support or for driver compatiblity.
