#define ASM_FILE	1
#include <multiboot2.h>
#ifdef __ELF__
# define AOUT_KLUDGE 0
#else
# define AOUT_KLUDGE MULTIBOOT_AOUT_KLUDGE
#endif
.text
main:
	jmp boot
	.align 8
multiboot:
	#Multiboot 1.9 http://nongnu.askapache.com/grub/phcoder/multiboot.pdf
	.long MULTIBOOT2_HEADER_MAGIC
	.long 0
	.long multiboot_end - multiboot
	#.long 0xFFFFFFFF & (-(MULTIBOOT2_HEADER_MAGIC + GRUB_MULTIBOOT_ARCHITECTURE_I386 + (multiboot_end - multiboot)))
	.long -(0xE85250D6 + 0 + (multiboot_end - multiboot))

	/*framebuffer_tag:
	.align 8
	.short MULTIBOOT_HEADER_TAG_FRAMEBUFFER
	.short MULTIBOOT_HEADER_TAG_OPTIONAL
	.long framebuffer_tag_end - framebuffer_tag
	.long 1024
	.long 768
	.long 32
	framebuffer_tag_end:*/
	
	.align 8
	.short MULTIBOOT_HEADER_TAG_END
	.short 0
	.long 8
multiboot_end:
boot:
	movl	$(stack + 0x4000), %esp
	push	$0
	popf
	pushq %rbx
	pushq %rax
	call main
HaltAndCatchFire: hlt
	jmp HaltAndCatchFire
.comm stack, 0x4000
