## T2 Debian Kernel for Debian unstable

Debian kernel with Apple T2 patches built-in. Kernels are build on
debian unstable.

The kernels are based on [T2 Ubuntu
kernels](https://github.com/t2linux/T2-Ubuntu-Kernel).
The build periodically (6h) checks for changes and in case of a change,
grabs build parameters, patches and driver repositories to build a new
set of debian packages.

## Installation

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
