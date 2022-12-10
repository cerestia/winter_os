[ORG 0x7c00]  ;或者SECTION MBR VSTART=0X7C00
;将所有符号地址从0x7c00处开始，这样放入机器0x7c00处时才能一一对应。

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

jmp $

times 510-($-$$) db 0

db 0x55,0xaa