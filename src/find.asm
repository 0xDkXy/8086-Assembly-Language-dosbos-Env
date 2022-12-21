assume cs:code, ds:data, ss:stack
data segment
    istr0 byte 0ffh,0, 0ffh dup('$')
    istr1 byte 0ffh,0, 0ffh dup('$')
    ostr byte 0ffh dup('$')
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
    xor di, di ; clear di for count the position
count:
    inc di
    inc bx
    call comp_str
    cmp ax, 1
    loop count
    mov dx, offset ostr
    mov ah, 9
    int 21h
    mov ax, 4c00h
    int 21h
comp_str:
    push bx
    push cx
    push di
    xor ax, ax
    xor di, di
    xor si, si
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
    xor ax, ax
    inc di
    inc si
    loop in_loop
    mov ax, 1
out1:
    pop di
    pop cx
    pop bx
    ret

displaystr:
displaychr:


code ends
end start

