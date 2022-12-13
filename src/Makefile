BUILD:=../build
KERNELENTRY:=0x70000

CFLAGS:= -m32 # 32 位的程序
CFLAGS+= -masm=intel
CFLAGS+= -fno-builtin	# 不需要 gcc 内置函数
CFLAGS+= -nostdinc		# 不需要标准头文件
CFLAGS+= -fno-pic		# 不需要位置无关的代码  position independent code
CFLAGS+= -fno-pie		# 不需要位置无关的可执行程序 position independent executable
CFLAGS+= -nostdlib		# 不需要标准库
CFLAGS+= -fno-stack-protector	# 不需要栈保护
CFLAGS:=$(strip ${CFLAGS})

DEBUG:= -g
INCLUDE = -I./include

DISK = ../build/virtual_disk.img

all:$(BUILD)/boot/boot.bin $(BUILD)/boot/loader.bin $(BUILD)/system.bin
	dd if=$(BUILD)/boot/boot.bin of=$(DISK) bs=512 count=1 conv=notrunc
	dd if=$(BUILD)/boot/loader.bin of=$(DISK) bs=512 count=4 seek=2 conv=notrunc
	dd if=$(BUILD)/system.bin of=$(DISK) bs=512 count=60 seek=10 conv=notrunc

$(BUILD)/boot/%.bin: ./boot/%.S
	$(shell mkdir -p ${BUILD}/boot)
	nasm -f bin -o $@ $<

$(BUILD)/system.bin:$(BUILD)/kernel.bin
	objcopy -O binary $< $@
	nm ${BUILD}/kernel.bin | sort > ${BUILD}/system.map

$(BUILD)/kernel.bin: $(BUILD)/kernel/start.o \
					$(BUILD)/kernel/main.o 	\
					$(BUILD)/lib/string.o \
					$(BUILD)/kernel/asm/io.o \
					$(BUILD)/kernel/chr_drv/console.o 

	$(shell mkdir -p $(dir $@))
	ld -m elf_i386 -static $^ -o $@ -Ttext $(KERNELENTRY)

$(BUILD)/kernel/%.o: ./kernel/%.S
	$(shell mkdir -p $(dir @))
	nasm -f elf32 $< -o $@

$(BUILD)/kernel/%.o: ./kernel/%.c
	$(shell mkdir -p $(dir @))
	gcc ${CFLAGS} ${INCLUDE} ${DEBUG} -c $< -o $@

${BUILD}/lib/%.o: ./lib/%.c
	$(shell mkdir -p $(dir @))
	gcc ${CFLAGS} $(INCLUDE) ${DEBUG} -c $< -o $@

.PHONY:qemu
qemu: ../build/virtual_disk.img
	qemu-system-i386 \
	-m 32M \
	-boot c \
	-hda $(DISK)

.PHONY:qemug
qemug: ../build/virtual_disk.img
	qemu-system-i386 \
	-m 32M \
	-boot c \
	-hda $(DISK) \
	-s -S

.PHONY:clean
clean:
	rm -rf ../build/boot/*
	rm -rf ../build/kernel/*
