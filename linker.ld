ENTRY(main)
OUTPUT_FORMAT(elf64-x86-64)
STARTUP(boot.o)
SECTIONS
{
	. +=1M;

	.text  : {
		*(.text)
		*(.gnu.linkonce.t*)
		*(.rodata*)
		*(.gnu.linkonce.r*)
	}

	.data  : {
		*(.data)
		*(.gnu.linkonce.d*)
		*(COMMON)
		*(.bss)
		*(.gnu.linkonce.b*)
		/*. = heap;
		. = + 256
		. = heap_end;*/
	}

	/*Uncomment clean up data & text for -space +security
	Removes page align empty space, but return attack executes rodata*/
	/*.rodata ALIGN(4k) : {
		*(.rodata*)
		*(.gnu.linkonce.r*)
	}

	.bss ALIGN(4k) : {
		*(COMMON)
		*(.bss)
		*(.gnu.linkonce.b*)
	}

	.heap ALIGN(4k) : {
		. = heap;
		. = + 256
		. = heap_end;
	}*/

	kernel_end = .;

	/DISCARD/ : {
		*(.comment)
		*(.eh_frame)
	}
}