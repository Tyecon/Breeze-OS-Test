@echo off
set PATH=%PATH%;c:\cygwin\bin
SET FLAGS_GCC=-std=gnu99 -I./Include -ffreestanding -Wall -Wextra -m64 -mcmodel=kernel -mno-red-zone
SET FLAGS_LD=-lgcc -nostdlib -z max-page-size=0x1000
echo Assembling
"Cross/bin/x86_64-elf-cpp" boot.S -o bootpp.s -I./Include
"Cross/bin/x86_64-elf-as" bootpp.s -o boot.o -I./Include
echo Compiling
"Cross/bin/x86_64-elf-gcc" -c kernel.c -o kernel.o %FLAGS_GCC%
rem "Cross/bin/x86_64-elf-gcc" -c tty.c -o terminal.o %FLAGS_GCC%
echo Linking
"Cross/bin/x86_64-elf-gcc" -T linker.ld -o kernel.sys boot.o kernel.o %FLAGS_LD%
echo Cleaning
del *.o
echo Finished
pause