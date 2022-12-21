assume cs:code, ds:data, ss:stack
data segment
    istr0 byte 0ffh,0, 0ffh dup('$')
    istr1 byte 0ffh,0, 0ffh dup('$')
    ostr byte 0ffh, 0, 0ffh dup('$')
data ends

stack segment
    db 100 dup(0)
stack ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov ah, 0ah
    mov dx, offset istr0
    int 21h
    mov dx, offset istr1
    int 21h
    mov dx, offset ostr
    mov ah, 9
    int 21h
    mov ax, 4c00h
    int 21h
displaystr:
displaychr:


code ends
end start

