/* System clock driver */
#include <system.h>

int timer_ticks = 0;
int seconds=0;

void timer_handler(struct regs *r)
{
    timer_ticks++;
	if (timer_ticks % 18 == 0)
    {
        seconds++;
    }
}

//Install system clock to IRQ0
void timer_install() {irq_install_handler(0, timer_handler);}

void timer_phase(int hz)
{
    int divisor = 1193180 / hz;       /* Calculate our divisor */
    outportb(0x43, 0x36);             /* Set our command byte 0x36 */
    outportb(0x40, divisor & 0xFF);   /* Set low byte of divisor */
    outportb(0x40, divisor >> 8);     /* Set high byte of divisor */
}

/* This will continuously loop until the given time has
*  been reached */
int Wait(int ticks)
{
	
	return seconds;
}
