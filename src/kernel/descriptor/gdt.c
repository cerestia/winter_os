#include "winter/descriptor/gdt.h"
#include "winter/linux/kernel.h"
#include "winter/string.h"
#include "winter/debugk.h"

descriptor_t gdt[GDT_SIZE]; // 内核全局描述符表
pointer_t kernel_gdt_ptr;   // 内核全局描述符表指针

void gdt_init()
{
    DEBUGK("init gdt!!!\n");
    asm volatile("sgdt kernel_gdt_ptr");

    memcpy(&gdt, (void *)kernel_gdt_ptr.base, kernel_gdt_ptr.limit + 1);

    kernel_gdt_ptr.base = (u32)&gdt;
    kernel_gdt_ptr.limit = sizeof(gdt) - 1;
    asm volatile("lgdt kernel_gdt_ptr\n");
}