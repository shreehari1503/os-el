[BITS 16]
[ORG 0x7c00]

TIMER_TICKS equ 18     ; Adjust this value for the desired delay

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00

    ; Set up the stack for the bootloader
    mov bp, 0x7c00

    call PrintMessage

    ; Install the timer interrupt handler
    mov ax, 0
    mov es, ax
    mov bx, 0
    mov dx, TimerHandler
    mov cx, TIMER_TICKS
    call SetTimerInterrupt

    ; Enable interrupts
    sti

    call Delay ; Introduce a delay to observe the effect

End:
    hlt
    jmp End

PrintMessage:
    mov ah, 0x13
    mov al, 1
    mov bx, 0xa
    xor dx, dx
    mov bp, Message
    mov cx, MessageLen
    int 0x10
    ret

ReadUserInput:
    mov ah, 0
    int 0x16
    mov ah, 0x0e
    int 0x10
    ret

Delay:
    ; A simple delay loop using the timer interrupt
    mov ax, 0
    mov cx, 0
DelayLoop:
    cmp cx, TIMER_TICKS
    jne DelayLoop
    ret

SetTimerInterrupt:
    ; Set up timer interrupt vector
    mov ah, 0x25
    int 0x21
    ret

TimerHandler:
    ; Your timer interrupt handler code goes here
    inc word [TimerTicks]
    iret

Message db "THIS BOOTLOADER WAS CREATED ON 15/2/2024 by shreehari and vishruth.we used x86 to write this .asm file", 0
MessageLen equ $ - Message

TimerTicks dw 0

times (0x1be - ($ - $$)) db 0

db 0x80
db 0, 2, 0
db 0f0h
db 0ffh, 0ffh, 0ffh
dd 1
dd (20*16*63-1)

times (16*3) db 0

db 0x55
db 0xaa

