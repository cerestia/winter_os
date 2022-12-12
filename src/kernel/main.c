#include "../include/string.h"

void kernel_main()
{
    char test[] = "test memcpy";
    char src[16];
    strcpy(&src, test);
    return;
}