#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

extern void terminal_init();
extern void terminal_setcolor(uint8_t color);
extern void terminal_writestring(const char* data);
extern void terminal_writeint(const long data);
extern void terminal_writehex(const long data);
extern void terminal_scroll();

enum vga_color
{
	COLOR_BLACK = 0,
	COLOR_BLUE = 1,
	COLOR_GREEN = 2,
	COLOR_CYAN = 3,
	COLOR_RED = 4,
	COLOR_MAGENTA = 5,
	COLOR_BROWN = 6,
	COLOR_LIGHT_GREY = 7,
	COLOR_DARK_GREY = 8,
	COLOR_LIGHT_BLUE = 9,
	COLOR_LIGHT_GREEN = 10,
	COLOR_LIGHT_CYAN = 11,
	COLOR_LIGHT_RED = 12,
	COLOR_LIGHT_MAGENTA = 13,
	COLOR_LIGHT_BROWN = 14,
	COLOR_WHITE = 15,
};

size_t strlen(const char* str) {
	size_t ret = 0;
	while (str[ret]!=0)
		ret++;
	return ret;
}

uint8_t make_color(enum vga_color fg, enum vga_color bg) {
	return fg | bg << 4;
}

uint16_t make_vgaentry(char c, uint8_t color) {
	uint16_t c16=c;
	uint16_t color16=color;
	return c16 | color16 << 8;
}

static const size_t VGA_WIDTH=80;
static const size_t VGA_HEIGHT=25;

size_t terminal_row;
size_t terminal_column;
uint8_t terminal_color;
uint16_t* terminal_buffer;

void terminal_init(void) {
	terminal_row=0;
	terminal_column=0;
	terminal_color=make_color(COLOR_WHITE, COLOR_BLUE);
	terminal_buffer=(uint16_t*) 0xB8000;

	for (size_t y=0; y<VGA_HEIGHT; y++) {
		for (size_t x=0; x<VGA_WIDTH; x++) {
			const size_t index=y*VGA_WIDTH+x;
			terminal_buffer[index]=make_vgaentry(' ', terminal_color);
		}
	}
}

void terminal_setcolor(uint8_t color) {
	terminal_color=color;
}

void terminal_putentryat(char c, uint8_t color, size_t x, size_t y) {
	const size_t index=y*VGA_WIDTH+x;
	terminal_buffer[index]=make_vgaentry(c, color);
}

void terminal_putchar(char c) {
	switch(c) {
		case('\n'): terminal_row++; terminal_column=-1; break;
		case('\r'): terminal_column=-1; break;
		default: terminal_putentryat(c, terminal_color, terminal_column, terminal_row); break;
	}
	if (++terminal_column==VGA_WIDTH) {
		terminal_column=0;
		if (++terminal_row==VGA_HEIGHT) {
			terminal_scroll();
		}
	}
}

void terminal_writestring(const char* data) {
	size_t datalen = strlen(data);
	for (size_t i=0; i<datalen; i++) {
		terminal_putchar(data[i]);
	}
}

char* calcint(long value, char* str, int base) {
    char * rc;
    char * ptr;
    char * low;
    // Check for supported base.
    if ( base < 2 || base > 36 )
    {
        *str = '\0';
        return str;
    }
    rc = ptr = str;
    // Set '-' for negative decimals.
    if ( value < 0 && base == 10 )
    {
        *ptr++ = '-';
    }
    // Remember where the numbers start.
    low = ptr;
    // The actual conversion.
    do
    {
        // Modulo is negative for negative value. This trick makes abs() unnecessary.
        *ptr++ = "ZYXWVUTSRQPONMLKJIHGFEDCBA9876543210123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"[35 + value % base];
        value /= base;
    } while ( value );
    // Terminating the string.
    *ptr-- = '\0';
    // Invert the numbers.
    while ( low < ptr )
    {
        char tmp = *low;
        *low++ = *ptr;
        *ptr-- = tmp;
    }
    return rc;
}

void terminal_writeint(const long data) {
	char* str="";
	char* ret=calcint(data, str, 10);
	size_t datalen = strlen(ret);
	for (size_t i=0; i<datalen; i++) {
		terminal_putchar(ret[i]);
	}
}

void terminal_writehex(const long data) {
	char* str="";
	char* ret=calcint(data, str, 16);
	size_t datalen = strlen(ret);
	for (size_t i=0; i<datalen; i++) {
		terminal_putchar(ret[i]);
	}
}

void terminal_writestringlen(const char* data, int datalen) {
	for (int i=0; i<datalen; i++) {
		terminal_putchar(data[i]);
	}
}

void terminal_scroll(void) {
	terminal_row=0;
	terminal_column=VGA_HEIGHT-1;
	for (size_t y=1; y<VGA_HEIGHT; y++) {
		for (size_t x=0; x<VGA_WIDTH; x++) {
			uint16_t c=terminal_buffer[y*VGA_WIDTH+x];
			const size_t index=(y-1)*VGA_WIDTH+x;
			terminal_buffer[index]=c;
		}
	}
}