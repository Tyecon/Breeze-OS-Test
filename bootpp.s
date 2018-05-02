# 1 "boot.S"
# 1 "<command-line>"
# 1 "boot.S"

# 1 "./Include/multiboot2.h" 1
# 3 "boot.S" 2





.text
main:
 jmp boot
 .align 8
multiboot:
 #Multiboot 1.9 http:
 .long 0xe85250d6
 .long 0
 .long multiboot_end - multiboot
 #.long 0xFFFFFFFF & (-(0xe85250d6 + GRUB_MULTIBOOT_ARCHITECTURE_I386 + (multiboot_end - multiboot)))
 .long -(0xE85250D6 + 0 + (multiboot_end - multiboot))
# 30 "boot.S"
 .align 8
 .short 0
 .short 0
 .long 8
multiboot_end:
boot:
 movl $(stack + 0x4000), %esp
 push $0
 popf
 pushq %rbx
 pushq %rax
 call main
HaltAndCatchFire: hlt
 jmp HaltAndCatchFire
.comm stack, 0x4000
