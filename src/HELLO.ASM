stack segment 
    db 200 dup(0)
stack ends

data segment
    buf db 'hello world!$'

data ends

code segment
    assume cs:code, ds:data, ss:stack

start:
    mov ax, data
    mov ds, ax
    lea dx, buf
    mov ah, 9
    int 21h
    mov ax, 4c00h
    int 21h

code ends
end start


