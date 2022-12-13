#include "winter/linux/kernel.h"
#include "winter/linux/console.h"
#include "winter/assert.h"

void kernel_main()
{
    console_init();
    printk("hello world,%d %d %d\n", 2022, 12, 23);
}