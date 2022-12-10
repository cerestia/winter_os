image:os_file
	dd if=../build/boot.bin of=../build/virtual_disk.img bs=512 count=1 conv=notrunc

os_file:./boot/boot.S
	nasm -f bin -o ../build/boot.bin ./boot/boot.S

.PHONY:qemu
qemu: ../build/virtual_disk.img
	qemu-system-i386 \
	-m 32M \
	-boot c \
	-hda ../build/virtual_disk.img