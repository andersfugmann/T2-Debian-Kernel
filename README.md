## THIS REPO IS A FORK of [T2 Ubuntu kernel](https://github.com/t2linux/T2-Ubuntu-Kernel)

Please go there for an updated kernel, unless you require a kernel
build specifically for debian. Credits to @AdityaGarg8 for keeping the
kernels up2date.

## T2 Debian Kernel for Debian unstable

Debian kernel with Apple T2 patches built-in. Kernels are build on
debian unstable

![Build Kernel Package](https://github.com/andersfugmann/T2-Debian-Kernel/actions/workflows/build.yml/badge.svg?branch=Mainline)

This project is closely inspired by mikeeq/mbp-fedora-kernel and marcosfad/mbp-ubuntu-kernel. Thank you @mikeeq and @marcosfad for the scripts and setup.

Special thanks to @Redecorating for the CI.

**If this repo helped you in any way, consider inviting a coffee to the people in the [credits](https://github.com/t2linux/T2-Ubuntu-Kernel#credits) (links given [here](https://wiki.t2linux.org/contribute/)).**

## Installation

### Using the kernel upgrade script

Firstly add the **t2-ubuntu-repo** apt repo :-

```bash
curl -s --compressed "https://adityagarg8.github.io/t2-ubuntu-repo/key.gpg" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/t2-ubuntu-repo.gpg >/dev/null
sudo curl -s --compressed -o /etc/apt/sources.list.d/t2.list "https://adityagarg8.github.io/t2-ubuntu-repo/t2.list"
sudo apt update
```

Then, install the script by running :-

```bash
sudo apt install t2-kernel-script-debian
```

Now, whenever you wish to upgrade your kernel, run :-

```bash
update_t2_kernel
```

**Note :-** By default, whenever you run `update_t2_kernel`, the script installs the latest kernel (lts or mainline, depending on your script) as well as preserves the kernel which is booted during running of the script. Rest all old t2 kernels get removed (self compiled and official Debian kernels are not affected). In case you wish to remove the kernel which is booted as well, run `update_t2_kernel --remove-current`.

### Download package manually

Download the .deb packages of **linux-headers** and **linux-image** of the kernel you wish to install from the [releases](https://github.com/andersfugmann/T2-Debian-Kernel/releases) section.

Install **linux-headers** first and then **linux-image** using `apt` and restart your Mac. In case you do not know how to do so, follow the instructions given below. Else you are good to go.

On terminal, type `sudo apt install ` and then drag and drop the **linux-headers** file to the terminal and press enter/return key.

Do the similar process for **linux-images** package.

Restart your Mac.

## Docs

- Discord: <https://discord.gg/Uw56rqW>
- WiFi firmware:
  - <https://wiki.t2linux.org/guides/wifi/>
- blog `Installing Fedora 31 on a 2018 Mac mini`: <https://linuxwit.ch/blog/2020/01/installing-fedora-on-mac-mini/>
- iwd:
  - <https://iwd.wiki.kernel.org/networkconfigurationsettings>
  - <https://wiki.archlinux.org/index.php/Iwd>
  - <https://www.vocal.com/secure-communication/eap-types/>

### Ubuntu

- <https://wiki.ubuntu.com/KernelTeam/GitKernelBuild>
- <https://help.ubuntu.com/community/Repositories/Personal>
- <https://medium.com/sqooba/create-your-own-custom-and-authenticated-apt-repository-1e4a4cf0b864>
- <https://help.ubuntu.com/community/Kernel/Compile>
- <https://wiki.ubuntu.com/Kernel/BuildYourOwnKernel>
- <https://www.linux.com/training-tutorials/kernel-newbie-corner-building-and-running-new-kernel/>
- <https://wiki.ubuntu.com/KernelTeam/KernelMaintenance>

## Credits

- @Redecorating - thanks for editing the scripts and CI for Ubuntu
- @fishpm-anu - thanks for the kernel upgrade script
- @marcosfad - thanks for the original script for Ubuntu
- @MCMrARM - thanks for all RE work
- @ozbenh - thanks for submitting NVME patch
- @roadrunner2 - thanks for SPI (touchbar) driver
- @aunali1 - thanks for ArchLinux Kernel CI and active support
- @jamlam - thanks for providing the Correlium wifi patch
- @ppaulweber - thanks for keyboard and Macbook Air patches
- @mikeeq - thanks for the fedora kernel project and compilation scripts
