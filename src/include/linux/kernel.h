#ifndef WINTER_KERNEL_H
#define WINTER_KERNEL_H

#include "../stdarg.h"

int vsprintf(char *buf, const char *fmt, va_list args);

int printk(const char *fmt, ...);

#endif