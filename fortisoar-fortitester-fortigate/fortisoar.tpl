#cloud-config
package_upgrade: true
packages:
  - iperf3
  - iproute2
  - fping
  - policycoreutils-python
  - gcc
  - java-11-openjdk
  - yum-utils
  - ntp