@echo off
@set PATH=C:\Program Files\MinGW\bin;C:\Program Files\nasm;%path%

echo Assembling Bootloader
nasm -f coff -o ks.o Kernel_Start.asm
echo Finished Assembling

echo Compiling C Kernel
gcc -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -o main.o -c Kernel.c
gcc -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o videot.o Drivers/TextMode.c
gcc -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o videog.o Drivers/GraphicsMode.c
gcc -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o gdt.o Interupt/GDT.c
gcc -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o idt.o Interupt/IDT.c
gcc -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o isr.o Interupt/ISR.c
gcc -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o irq.o Interupt/IRQ.c
gcc -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o timer.o Drivers/Timer.c
gcc -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -fno-builtin -I./include -c -o key.o Drivers/Keyboard.c
echo Kernel finished compiling

echo Linking
gcc -T link.ld -o Breeze.bin ks.o main.o videot.o videog.o gdt.o idt.o isr.o irq.o timer.o key.o
echo Linking finished
del *.o
copy Breeze.bin A:\
pause