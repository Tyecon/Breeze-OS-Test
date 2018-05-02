@echo off
echo Assembling
nasm -f elf -o loader.o Loader.asm
echo Compiling
i586-elf-gcc -o kernel.o -c Kernel.c -Wall -Wextra -Werror -nostdlib -fno-builtin -nostartfiles -nodefaultlibs
echo Linking
i586-elf-ld -T Linker.ld -o kernel.bin loader.o kernel.o
echo Cleaning
del *.o
echo Mounting Virtual Drive
diskpart /s mount.bat
echo Moving Kernel to Drive
del F:\kernel.bin
copy kernel.bin F:\
echo Unmounting Drive
diskpart /s unmount.bat
echo Finished
pause