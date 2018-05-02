#ifndef __SYSTEM_H
#define __SYSTEM_H

/* Kernel.c */
extern unsigned char *memcpy(unsigned char *dest, const unsigned char *src, int count);
extern unsigned short *memcpyw(unsigned short *dest, const unsigned short *src, int count);
extern unsigned char *memset(unsigned char *dest, unsigned char val, int count);
extern unsigned short *memsetw(unsigned short *dest, unsigned short val, int count);
extern unsigned int *memseti(unsigned int *dest, unsigned int val, int count);
extern int strlen(const char *str);
extern unsigned char inportb(unsigned short _port);
extern void outportb(unsigned short _port, unsigned char _data);

/* Video.c */
extern void cls();
extern void Print(char *c);
extern void PrintLn(char *c);
extern void Write_Char(char c);
extern void settextcolor(unsigned char forecolor, unsigned char backcolor);

/* GDT.c */
extern void gdt_set_gate(int num, unsigned long base, unsigned long limit, unsigned char access, unsigned char gran);
extern void gdt_install();

/* IDT.c */
extern void idt_install();
extern void idt_set_gate(unsigned char num, unsigned long base, unsigned short sel, unsigned char flags);

/* ISR.c */
extern void isr_install();
struct regs
{
    unsigned int gs, fs, es, ds;      /* pushed the segs last */
    unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eax;  /* pushed by 'pusha' */
    unsigned int int_no, err_code;    /* our 'push byte #' and ecodes do this */
    unsigned int eip, cs, eflags, useresp, ss;   /* pushed by the processor automatically */ 
};

/* IRQ.c */
extern void irq_install();
extern void irq_install_handler(int irq, void (*handler)(struct regs *r));
extern void irq_uninstall_handler(int irq);

/* Timer.c */
extern void timer_install();
extern void timer_phase(int hz);
extern int Wait(int ticks);

/* Keyboard.c */
extern void keyboard_install();
extern void video_install();
#endif
