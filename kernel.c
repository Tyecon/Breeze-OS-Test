#include "multiboot2.h"
//#include "tty.c"
#include "ktypes.h"

unsigned char inportb(unsigned short _port);
void outportb(unsigned short _port, unsigned char _data);

static uint16* const vram = (uint16*) 0xB8000;
void main(unsigned long magic, unsigned long addr) {
	/*if (magic != MULTIBOOT2_BOOTLOADER_MAGIC) {terminal_writestring("Invalid Magic number");}
	else {terminal_writestring("Testing");}*/
	
	/*for (unsigned int i=0; i< 80 * 24 * 2; i+=3) {
		*(vram + i) = 4 & 255;
		*(vram + i + 1) = (4 >> 8) & 255;
		*(vram + i + 2) = (4 >> 16) & 255;
	}*/
	*(vram + (0 + 0 * 80) * 2) = 'A' & 0xFF;
	*(vram + (0 + 0 * 80) * 2 + 1) = 7;
	
	for (int i=0; i<4; i++) {
		for (int j=0; j<60; i++) {
			if (i%2) outportb(0x61, inportb(0x61) & 0x01);
			else outportb(0x61, inportb(0x61) ^ 0x01);
		}
	}
}

//Get char from port
unsigned char inportb(unsigned short _port)
{unsigned char rv; asm volatile("inb %1, %0" : "=a" (rv) : "dN" (_port)); return rv;}
//Send char to port
void outportb(unsigned short _port, unsigned char _data)
{asm volatile("outb %1, %0" : : "dN" (_port), "a" (_data));}