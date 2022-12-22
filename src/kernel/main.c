#include "winter/linux/kernel.h"
#include "winter/linux/console.h"
#include "winter/assert.h"
#include "winter/descriptor/gdt.h"
#include "winter/descriptor/interrupt.h"
#include "winter/stdlib.h"
extern void clock_init();

void kernel_main()
{
    console_init();
    printk("hello world,%d %d %d\n", 2022, 12, 23);
    gdt_init();
    interrupt_init();

    clock_init();
    return;
}