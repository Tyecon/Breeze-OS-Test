[BITS 32]
global start
start:
    mov esp, sysstack     ; This points the stack to our new stack area
    jmp stublet

ALIGN 4
mboot:
    ; Multiboot macros to make a few lines later more readable
    MULTIBOOTPAGEALIGN	equ 1<<0
    MULTIBOOTMEMORYINFO	equ 1<<1
    MULTIBOOTAOUTKLUDGE	equ 1<<16
    MULTIBOOTHEADERMAGIC	equ 0x1BADB002
    MULTIBOOTHEADERFLAGS	equ MULTIBOOTPAGEALIGN | MULTIBOOTMEMORYINFO | MULTIBOOTAOUTKLUDGE
    MULTIBOOTCHECKSUM	equ -(MULTIBOOTHEADERMAGIC + MULTIBOOTHEADERFLAGS)
    EXTERN code, bss, end

    ; This is the GRUB Multiboot header. A boot signature
    dd MULTIBOOTHEADERMAGIC
    dd MULTIBOOTHEADERFLAGS
    dd MULTIBOOTCHECKSUM
    
    ; AOUT kludge - must be physical addresses. Make a note of these:
    ; The linker script fills in the data for these ones!
    dd mboot
    dd code
    dd bss
    dd end
    dd start

stublet:
    extern main
    call main
    jmp $

;--gdtflush()--
global gdtflush
extern gp
gdtflush:
    lgdt [gp]
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    jmp 0x08:flush2
flush2:
    ret

;--idtload()--
global idtload
extern idtp
idtload:
    lidt [idtp]
    ret

;--ISR Declarations--
global isr0
global isr1
global isr2
global isr3
global isr4
global isr5
global isr6
global isr7
global isr8
global isr9
global isr10
global isr11
global isr12
global isr13
global isr14
global isr15
global isr16
global isr17
global isr18
global isr19
global isr20
global isr21
global isr22
global isr23
global isr24
global isr25
global isr26
global isr27
global isr28
global isr29
global isr30
global isr31

;  0: Divide By Zero Exception
isr0:
    cli
    push byte 0
    push byte 0
    jmp isrcommonstub

;  1: Debug Exception
isr1:
    cli
    push byte 0
    push byte 1
    jmp isrcommonstub

;  2: Non Maskable Interrupt Exception
isr2:
    cli
    push byte 0
    push byte 2
    jmp isrcommonstub

;  3: Int 3 Exception
isr3:
    cli
    push byte 0
    push byte 3
    jmp isrcommonstub

;  4: INTO Exception
isr4:
    cli
    push byte 0
    push byte 4
    jmp isrcommonstub

;  5: Out of Bounds Exception
isr5:
    cli
    push byte 0
    push byte 5
    jmp isrcommonstub

;  6: Invalid Opcode Exception
isr6:
    cli
    push byte 0
    push byte 6
    jmp isrcommonstub

;  7: Coprocessor Not Available Exception
isr7:
    cli
    push byte 0
    push byte 7
    jmp isrcommonstub

;  8: Double Fault Exception (With Error Code!)
isr8:
    cli
    push byte 8
    jmp isrcommonstub

;  9: Coprocessor Segment Overrun Exception
isr9:
    cli
    push byte 0
    push byte 9
    jmp isrcommonstub

; 10: Bad TSS Exception (With Error Code!)
isr10:
    cli
    push byte 10
    jmp isrcommonstub

; 11: Segment Not Present Exception (With Error Code!)
isr11:
    cli
    push byte 11
    jmp isrcommonstub

; 12: Stack Fault Exception (With Error Code!)
isr12:
    cli
    push byte 12
    jmp isrcommonstub

; 13: General Protection Fault Exception (With Error Code!)
isr13:
    cli
    push byte 13
    jmp isrcommonstub

; 14: Page Fault Exception (With Error Code!)
isr14:
    cli
    push byte 14
    jmp isrcommonstub

; 15: Reserved Exception
isr15:
    cli
    push byte 0
    push byte 15
    jmp isrcommonstub

; 16: Floating Point Exception
isr16:
    cli
    push byte 0
    push byte 16
    jmp isrcommonstub

; 17: Alignment Check Exception
isr17:
    cli
    push byte 0
    push byte 17
    jmp isrcommonstub

; 18: Machine Check Exception
isr18:
    cli
    push byte 0
    push byte 18
    jmp isrcommonstub

; 19: Reserved
isr19:
    cli
    push byte 0
    push byte 19
    jmp isrcommonstub

; 20: Reserved
isr20:
    cli
    push byte 0
    push byte 20
    jmp isrcommonstub

; 21: Reserved
isr21:
    cli
    push byte 0
    push byte 21
    jmp isrcommonstub

; 22: Reserved
isr22:
    cli
    push byte 0
    push byte 22
    jmp isrcommonstub

; 23: Reserved
isr23:
    cli
    push byte 0
    push byte 23
    jmp isrcommonstub

; 24: Reserved
isr24:
    cli
    push byte 0
    push byte 24
    jmp isrcommonstub

; 25: Reserved
isr25:
    cli
    push byte 0
    push byte 25
    jmp isrcommonstub

; 26: Reserved
isr26:
    cli
    push byte 0
    push byte 26
    jmp isrcommonstub

; 27: Reserved
isr27:
    cli
    push byte 0
    push byte 27
    jmp isrcommonstub

; 28: Reserved
isr28:
    cli
    push byte 0
    push byte 28
    jmp isrcommonstub

; 29: Reserved
isr29:
    cli
    push byte 0
    push byte 29
    jmp isrcommonstub

; 30: Reserved
isr30:
    cli
    push byte 0
    push byte 30
    jmp isrcommonstub

; 31: Reserved
isr31:
    cli
    push byte 0
    push byte 31
    jmp isrcommonstub


; We call a C function in here. We need to let the assembler know
; that 'faulthandler' exists in another file
extern faulthandler

; This is our common ISR stub. It saves the processor state, sets
; up for kernel mode segments, calls the C-level fault handler,
; and finally restores the stack frame.
isrcommonstub:
    pusha
    push ds
    push es
    push fs
    push gs
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov eax, esp
    push eax
    mov eax, faulthandler
    call eax
    pop eax
    pop gs
    pop fs
    pop es
    pop ds
    popa
    add esp, 8
    iret

global irq0
global irq1
global irq2
global irq3
global irq4
global irq5
global irq6
global irq7
global irq8
global irq9
global irq10
global irq11
global irq12
global irq13
global irq14
global irq15

; 32: IRQ0
irq0:
    cli
    push byte 0
    push byte 32
    jmp irqcommonstub

; 33: IRQ1
irq1:
    cli
    push byte 0
    push byte 33
    jmp irqcommonstub

; 34: IRQ2
irq2:
    cli
    push byte 0
    push byte 34
    jmp irqcommonstub

; 35: IRQ3
irq3:
    cli
    push byte 0
    push byte 35
    jmp irqcommonstub

; 36: IRQ4
irq4:
    cli
    push byte 0
    push byte 36
    jmp irqcommonstub

; 37: IRQ5
irq5:
    cli
    push byte 0
    push byte 37
    jmp irqcommonstub

; 38: IRQ6
irq6:
    cli
    push byte 0
    push byte 38
    jmp irqcommonstub

; 39: IRQ7
irq7:
    cli
    push byte 0
    push byte 39
    jmp irqcommonstub

; 40: IRQ8
irq8:
    cli
    push byte 0
    push byte 40
    jmp irqcommonstub

; 41: IRQ9
irq9:
    cli
    push byte 0
    push byte 41
    jmp irqcommonstub

; 42: IRQ10
irq10:
    cli
    push byte 0
    push byte 42
    jmp irqcommonstub

; 43: IRQ11
irq11:
    cli
    push byte 0
    push byte 43
    jmp irqcommonstub

; 44: IRQ12
irq12:
    cli
    push byte 0
    push byte 44
    jmp irqcommonstub

; 45: IRQ13
irq13:
    cli
    push byte 0
    push byte 45
    jmp irqcommonstub

; 46: IRQ14
irq14:
    cli
    push byte 0
    push byte 46
    jmp irqcommonstub

; 47: IRQ15
irq15:
    cli
    push byte 0
    push byte 47
    jmp irqcommonstub

extern irqhandler

irqcommonstub:
    pusha
    push ds
    push es
    push fs
    push gs

    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov eax, esp

    push eax
    mov eax, irqhandler
    call eax
    pop eax

    pop gs
    pop fs
    pop es
    pop ds
    popa
    add esp, 8
    iret

; Here is the definition of our BSS section. Right now, we'll use
; it just to store the stack. Remember that a stack actually grows
; downwards, so we declare the size of the data before declaring
; the identifier 'sysstack'
SECTION .bss
    resb 8192               ; This reserves 8KBytes of memory here
sysstack: