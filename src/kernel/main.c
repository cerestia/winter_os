

void kernel_main()
{
    char *first_char = 0xb8000;
    *first_char = 'm';
    first_char++;
    *first_char = 0x70;
}