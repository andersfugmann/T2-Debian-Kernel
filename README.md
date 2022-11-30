## T2 Debian Kernel for Debian unstable

Debian kernel with Apple T2 patches built-in. Kernels are build on
debian unstable.

The kernels are based on [T2 Ubuntu
kernels](https://github.com/t2linux/T2-Ubuntu-Kernel).
The build periodically (6h) checks for changes and in case of a change,
grabs build parameters, patches and driver repositories to build a new
set of debian packages.

## Installation

### Using the kernel upgrade script

Firstly add the **t2-ubuntu-repo** apt repo

```bash
curl -s --compressed "https://adityagarg8.github.io/t2-ubuntu-repo/KEY.gpg" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/t2-ubuntu-repo.gpg >/dev/null
sudo curl -s --compressed -o /etc/apt/sources.list.d/t2.list "https://adityagarg8.github.io/t2-ubuntu-repo/t2.list"
sudo apt update
```

Install the script by running:

```bash
sudo apt install t2-kernel-script-debian
```

Whenever you wish to upgrade your kernel, run:

```bash
update_t2_kernel
```

**Note :-** By default, whenever you run `update_t2_kernel`, the script installs the latest kernel as well as preserves the kernel which is booted during running of the script. Rest all old t2 kernels get removed (self compiled and official Debian kernels are not affected). In case you wish to remove the kernel which is booted as well, run `update_t2_kernel --remove-current`.

### Download package manually

Download the .deb packages of **linux-headers** and **linux-image** of
the kernel you wish to install from the
[releases](https://github.com/andersfugmann/T2-Debian-Kernel/releases)
section.

Enter the directory where the packages has been downloaded to, and run:
```bash
sudo dpkg -i linux-headers*.deb && sudo dpkg -i linux-image*.deb
```

Restart your Mac.

Consider removing previous images:
```bash
dpkg -l linux-image\*
apt purge linux-{image,headers}-<insert-version-here>*
```

## More information
Please visit [T2 Ubuntu kernels](https://github.com/t2linux/T2-Ubuntu-Kernel).

## Thanks
Special Thanks to @AdityaGarg8 for maintaining the T2 Apple Ubuntu
kernel images
