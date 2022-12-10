[ORG 0x7c00]  ;或者SECTION MBR VSTART=0X7C00
;将所有符号地址从0x7c00处开始，这样放入机器0x7c00处时才能一一对应。

;清屏
mov ax,3
int 0x10

;初始化
mov ax,cs
mov ds,ax
mov ss,ax
mov fs,ax
mov sp,0x7c00
;显存区域
mov ax,0xb800
mov gs,ax

mov byte [gs:0x00],'H' ;显存0xb8000，屏幕第一行第一个字
mov byte [gs:0x01],0x70 ;颜色控制
 
mov edi,0x900
mov ecx,2
mov bl,4

call read_disk

jmp 0x900

jmp $
;-
;edi 目标内存
;exc 起始扇区
;bl 扇区数量
read_disk:
 ; 设置读写扇区的数量
    mov dx, 0x1f2
    mov al, bl
    out dx, al

    inc dx; 0x1f3
    mov al, cl; 起始扇区的前八位
    out dx, al

    inc dx; 0x1f4
    shr ecx, 8
    mov al, cl; 起始扇区的中八位
    out dx, al

    inc dx; 0x1f5
    shr ecx, 8
    mov al, cl; 起始扇区的高八位
    out dx, al

    inc dx; 0x1f6
    shr ecx, 8
    and cl, 0b1111; 将高四位置为 0

    mov al, 0b1110_0000;
    or al, cl
    out dx, al; 主盘 - LBA 模式

    inc dx; 0x1f7
    mov al, 0x20; 读硬盘
    out dx, al

    xor ecx, ecx; 将 ecx 清空
    mov cl, bl; 得到读写扇区的数量

    .read:
        push cx; 保存 cx
        call .waits; 等待数据准备完毕
        call .reads; 读取一个扇区
        pop cx; 恢复 cx
        loop .read

    ret

    .waits:
        mov dx, 0x1f7
        .check:
            in al, dx
            jmp $+2; nop 直接跳转到下一行
            jmp $+2; 一点点延迟
            jmp $+2
            and al, 0b1000_1000
            cmp al, 0b0000_1000
            jnz .check
        ret

    .reads:
        mov dx, 0x1f0
        mov cx, 256; 一个扇区 256 字
        .readw:
            in ax, dx
            jmp $+2; 一点点延迟
            jmp $+2
            jmp $+2
            mov [edi], ax
            add edi, 2
            loop .readw
        ret

;--------------------------------
times 510-($-$$) db 0

db 0x55,0xaa