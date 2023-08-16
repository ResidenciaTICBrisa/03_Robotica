# Installing ROS1 using native packages

ROS1 has been natively packaged [1][1] by the following Debian-based GNU/Linux
distributions:

- Debian
    - Stretch (9): ROS 1.7
    - Buster (10): ROS 1.12
    - Bullseye (11): ROS 1.16
    - Bookworm (12): ROS 1.16
- Ubuntu
    - Xenial (16.04): ROS 1.5
    - Bionic (18.04): ROS 1.10
    - Eoan (19.10): ROS 1.14
    - Focal (20.04): ROS 1.15
    - Groovy (20.10): ROS 1.16
    - Hirsute (21.04): ROS 1.16
    - Impish (21.10): ROS 1.16
    - Jammy (22.04): ROS 1.16
    - Kinetic (22.10): ROS 1.16
    - Lunar (23.04): ROS 1.16

[1]: https://qa.debian.org/madison.php?package=ros-desktop-full&table=all&a=&c=&s=#

## Installing on Debian-based distributions

Debian-based distributions use `apt` as a front-end for the `dpkg`. Packages
can be installed using:

```
apt install the-package-name
```

### Installing on Debian and Ubuntu

The following important packages are available on the Debian repositories:

- `ros-desktop-full-dev`: `ros-desktop-full` and the dependencies needed to
compile it
- `ros-desktop-full`
- `ros-desktop`: different from the upstream, this package lacks the tutorials
and `roslint`, which must be compiled from source if needed
- `ros-base`: provides all the ROS base system
- `ros-core`: different from the upstream, it lacks `geneus` and
`rosbag_migration_rule`, which must be compiled from source if needed