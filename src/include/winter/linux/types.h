/*
    2022/12/12 fish
*/
#ifndef WINTER_TYPES_H
#define WINTER_TYPES_H

#define EOF -1
#define NULL ((void *)0)
#define EOS '\0'

#define bool _Bool
#define true 1
#define false 0

#define _packed __attribute__((packed))

typedef unsigned int size_t;
typedef long long int64;
typedef unsigned int uint;
typedef unsigned short ushort;
typedef unsigned char uchar;

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef unsigned long long u64;

#endif