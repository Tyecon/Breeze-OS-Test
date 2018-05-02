#include <system.h>
unsigned char *vidmem2 = (unsigned char *)0xA0000;
int attributeByte2 = 0x0F;
int y=50, x=50;
int width=320, height=200;
int pitch=8;
int color=0x7800;

void draw()
{
    unsigned where = x*3 + y*240;
    vidmem2[where] = color & 8;              // BLUE
    vidmem2[where + 1] = (color >> 8) & 8;   // GREEN
    vidmem2[where + 2] = (color >> 16) & 8;  // RED
}

void video_handler()
{
	outportb(0x3C00, 0x00);
}

void video_install()
{
	irq_install_handler(2, video_handler);
}
