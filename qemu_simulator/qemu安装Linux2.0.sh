
https://qemu-advent-calendar.org/2014/
预制的 Qemu 图像，可以从这里免费下载： http: //www.qemu-advent-calendar.org/2014/download/qemu-xmas-slackware.tar.xz

centos 安装虚拟化环境 zhuanlan.zhihu.com/p/460224616
sudo dnf install pixman-devel -y
yum install -y vim wget net-tools
yum install qemu-kvm libvirt libvirt-python3 libguestfs-tools virt-install -y
Total download size: 91 M    Installed size: 330 M
qemu-img create -f qcow2 slackware.qcow2 500M        ///home/yan/bak文件夹下，生成了slackware.qcow2文件
Formatting 'slackware.qcow2', fmt=qcow2 size=524288000 cluster_size=65536 lazy_refcounts=off refcount_bits=16

gpt答案： CentOS 8安装QEMU
1. 更新系统：确保系统最新，避免可能的依赖问题。sudo dnf update
	sudo dnf update  
	Install 4 Packages, Upgrade 46 Packages, Total download size: 202 M
2. 安装QEMU包：CentOS8使用dnf包管理器。sudo dnf install qemu-kvm qemu-img libvirt virt-install
   这会安装 QEMU、KVM（如果你的硬件支持虚拟化）以及与虚拟化相关的一些其他工具。
3. 启用并启动 libvirt 服务，这样你可以通过 `virsh` 或其他虚拟化管理工具管理虚拟机。 sudo systemctl enable --now libvirtd
4. qemu --version   安装成功，你会看到 QEMU 的版本信息。
https://unix.stackexchange.com/questions/585610/qemu-and-centos-8-where-is-usr-bin-qemu-system-x86-64-and-the-qemu-system-x86
sudo dnf in qemu-kvm.x86_64 qemu-kvm-core.x86_64 qemu-kvm-common.x86_64
Nothing to do.
5. 在VMware中开启虚拟化支持

启动：
/usr/libexec/qemu-kvm -enable-kvm -m 16M -drive if=ide,format=qcow2,file=slackware.qcow2 -netdev user,id=slirp -serial stdio
/usr/libexec/qemu-kvm -enable-kvm -m 16M -drive if=ide,format=qcow2,file="slackware.qcow2" -netdev user,id=slirp -device ne2k_pci,netdev=slirp -serial stdio
                                  -m 16M -drive file=slackware-1.01.img,format=raw -device ne2k_pci,netdev=slirp -netdev slirp,id=slirp
/usr/libexec/qemu-kvm -enable-kvm -m 16M -drive if=ide,format=qcow2,file="slackware.qcow2" -netdev user,id=slirp -device e1000,netdev=slirp -serial stdio
-device e1000,netdev=slirp

Disadvantages Defects drawback limitations
