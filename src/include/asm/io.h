#ifndef WINTER_IO_H
#define WINTER_IO_H

char in_byte(int port);
char in_word(int port);

void out_byte(int port, int v);
void out_word(int port, int v);

#endif
