DISK = ../build/virtual_disk.img

image:os_file
	dd if=../build/boot.bin of=$(DISK) bs=512 count=1 conv=notrunc
	dd if=../build/loader.bin of=$(DISK) bs=512 count=4 seek=2 conv=notrunc

os_file:./boot/boot.S ./boot/loader.S
	nasm -f bin -o ../build/boot.bin ./boot/boot.S
	nasm -f bin -o ../build/loader.bin ./boot/loader.S

.PHONY:qemu
qemu: ../build/virtual_disk.img
	qemu-system-i386 \
	-m 32M \
	-boot c \
	-hda $(DISK)

.PHONY:clean
clean:
	rm -rf ../build/boot/*