[ORG 0x900]

[bits 16]
prepare_protected:
[section .text]:
    mov ax,0xb800
    mov gs,ax

    mov byte [gs:0x02],'l'
    mov byte [gs:0x03],0x70

    ;关闭中断
    cli

    in al,0x02
    or al,0b1000_1000
    out 0x92,al
    lgdt [gdt_ptr]

    mov eax,cr0
    or eax,1
    mov cr0,eax

    jmp code_selector:protected

[section .gdt]:
KERNEL_ADDR equ 0x70000

code_selector equ (1<<3)
data_selector equ (2<<3)

memory_base equ 0x0
memory_limit equ 0xfffff ;段界限以4k为单位，总共4G内存分为0xfffff个

gdt_base:
    dd 0x0
    dd 0x0
code_descriptor:
    dw memory_limit&0xffff ;段基址低位
    dw memory_base&0xffff ;段界限低位
    db (memory_base>>16)&0xff ;段基址高位
    ;在内存 dlp 0 是段描述符 可执行_非依从_可读_没有被访问 
    db 0b1_00_1_1010 ;9A
    ;4k_32位_不是64位_avl 
    db 0b1_1_0_0_0000 | (memory_limit>>16) & 0xf ;cF
    db (memory_base>>24) & 0xff
data_descriptor:
    dw memory_limit & 0xffff ;段基址低位
    dw memory_base & 0xffff ;段界限低位
    db (memory_base>>16)&0xff ;段基址高位
    ;在内存 dlp 0 是段描述符 可执行_非依从_可读_没有被访问 
    db 0b1_00_1_0010 ;92
    ;4k_32位_不是64位_avl 
    db 0b1_1_0_0_0000 | (memory_limit>>16) & 0xf ;cF
    db (memory_base>>24) & 0xff
gdt_ptr:
    dw ($-gdt_base)
    dd gdt_base
;---------------------------------------------------------------------
;protected mode
[bits 32]
protected:
 mov ax, data_selector
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    xchg bx,bx
    mov esp, 0x9f000

    ; 将内核代码读入内存
    mov edi, KERNEL_ADDR
    mov ecx, 10
    mov bl, 60
    call read_hd

    mov byte [0xb8000],'P'
    mov byte [0xb8001],0x70
   
    jmp code_selector:KERNEL_ADDR

read_hd:
    ; 0x1f2 8bit 指定读取或写入的扇区数
    mov dx, 0x1f2
    mov al, bl
    out dx, al

    ; 0x1f3 8bit iba地址的第八位 0-7
    inc dx
    mov al, cl
    out dx, al

    ; 0x1f4 8bit iba地址的中八位 8-15
    inc dx
    mov al, ch
    out dx, al

    ; 0x1f5 8bit iba地址的高八位 16-23
    inc dx
    shr ecx, 16
    mov al, cl
    out dx, al

    ; 0x1f6 8bit
    ; 0-3 位iba地址的24-27
    ; 4 0表示主盘 1表示从盘
    ; 5、7位固定为1
    ; 6 0表示CHS模式，1表示LAB模式
    inc dx
    shr ecx, 8
    and cl, 0b1111
    mov al, 0b1110_0000     ; LBA模式
    or al, cl
    out dx, al

    ; 0x1f7 8bit  命令或状态端口
    inc dx
    mov al, 0x20
    out dx, al

    ; 设置loop次数，读多少个扇区要loop多少次
    mov cl, bl
.start_read:
    push cx     ; 保存loop次数，防止被下面的代码修改破坏

    call .wait_hd_prepare
    call read_hd_data

    pop cx      ; 恢复loop次数

    loop .start_read

.return:
    ret

; 一直等待，直到硬盘的状态是：不繁忙，数据已准备好
; 即第7位为0，第3位为1，第0位为0
.wait_hd_prepare:
    mov dx, 0x1f7

.check:
    in al, dx
    and al, 0b1000_1000
    cmp al, 0b0000_1000
    jnz .check

    ret

; 读硬盘，一次读两个字节，读256次，刚好读一个扇区
read_hd_data:
    mov dx, 0x1f0
    mov cx, 256

.read_word:
    in ax, dx
    mov [edi], ax
    add edi, 2
    loop .read_word

    ret


