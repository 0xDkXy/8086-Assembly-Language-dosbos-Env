assume cs:code, ds:data, ss:stack
data segment
    istr0 byte 0ffh,0, 0ffh dup('$')
    istr1 byte 0ffh,0, 0ffh dup('$')
    ostr0 byte 'matched!$'
    ostr1 byte 'unmatched!$'
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
    mov sp, 0ffh
    mov ah, 0ah
    mov dx, offset istr0
    int 21h
    mov dx, offset istr1
    int 21h
    mov dx, offset istr0
    add dx, 1
    mov bx, dx
    xor cx, cx
    mov cl, [bx] ; the loop of compared string
count:
    inc bx
    call comp_str
    loop count
    cmp bp, 1
    je match
    mov dx, offset ostr1
    jmp goon
match: 
    mov dx, offset ostr0
goon:
    mov ah, 9
    int 21h
    mov ax, 4c00h
    int 21h
comp_str:
    push bx
    push cx
    xor di, di
    xor cx, cx
    mov dx, offset istr1
    push bx
    mov bx, dx
    inc bx
    mov cl, [bx]
    pop bx
    mov si, 2
in_loop:
    mov ah, [bx+di]
    push bx
    mov bx, offset istr1
    mov al, [bx+si]
    pop bx
    cmp al, ah
    jne out1
    inc di
    inc si
    loop in_loop
    mov bp, 1
out1:
    nop
    pop cx
    pop bx
    ret

displaystr:
displaychr:


code ends
end start

