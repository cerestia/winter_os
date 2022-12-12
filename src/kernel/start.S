[SECTION .text]
[BITS 32]
extern kernel_main

global _start


_start:
    mov byte [0xb8000], 'K'; 表示进入了内核
    call kernel_main
    jmp $; 阻塞
