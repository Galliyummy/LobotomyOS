#!/bin/bash

QEMU_ARGS="-S -gdb stdio -m 32"

if [ "$#" -le 1 ]; then
    echo "usage: ./debug.sh <image_type> <image>"
    exit 1
fi

case "$1" in
    "floppy")   QEMU_ARGS="${QEMU_ARGS} -fda $PWD/$2"
    ;;
    "disk")     QEMU_ARGS="${QEMU_ARGS} -hda $PWD/$2"
    ;;
    *)          echo "Unknown image type $1."
                exit 2
esac

cat > .vscode/.gdb_script.gdb << EOF
    symbol-file $PWD/build/i686_debug/kernel/kernel.elf
    set disassembly-flavor intel
    target remote | qemu-system-i386 $QEMU_ARGS
EOF

gdb -x .vscode/.gdb_script.gdb