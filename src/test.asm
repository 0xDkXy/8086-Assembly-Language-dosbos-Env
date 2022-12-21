assume cs:code, ds:data
data segment
string byte 0ffh, 0, 81 dup('$')
data ends
code segment
start:
mov ax, data
mov ds, ax
mov ah, 0ah
mov dx, offset string
int 21h
mov ax, dx
inc dx
mov bx, dx
add ax, [bx]
inc ax
mov bx, ax
mov [bx], '$'
inc dx
mov ah, 9
int 21h
mov ax, 4c00h
int 21h

code ends
end start

