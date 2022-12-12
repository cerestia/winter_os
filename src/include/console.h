#ifndef WINTER_CONSOLE_H
#define WINTER_CONSOLE_H

#include "types.h"

void console_init();
void console_clean();
void console_write(char *buf, u32 count);

#endif