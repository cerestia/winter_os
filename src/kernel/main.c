#include "linux/kernel.h"
#include "linux/console.h"
void kernel_main()
{
    console_init();
    printk("hello world,%d %d %d\n", 2022, 12, 23);
}