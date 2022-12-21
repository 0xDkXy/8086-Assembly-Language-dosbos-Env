.model small
.data
string byte 0, 0, 81 dup('$')
.code 
main proc far
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

main endp
end

