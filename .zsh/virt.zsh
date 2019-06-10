# Shortcut to start VM using QEMU.
# Usage: virt <arch> <disk> [qemu options]
function virt {
    local arch=$1
    local disk=$2
    shift 2

    local disk_option=
    case $disk in
        *.qcow2)
            disk_option="driver=qcow2,file=$disk" ;;
        *)
            disk_option="driver=file,filename=$disk" ;;
    esac

    qemu-system-$arch \
        -drive "$disk_option",index=0 \
        -netdev bridge,id=net,br=virbr0 \
        -net nic,netdev=net \
        $@
}

# Shortcut to start VM using QEMU and KVM.
# Usage: virt-kvm <disk> [qemu options]
function virt-kvm {
    virt $(uname -i) $1 -enable-kvm ${@:2}
}
