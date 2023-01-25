.model huge
assume cs:code, ds:data, ss:stack
data segment
    istr0 byte 0ffh,0, 0ffh dup('$')
    istr1 byte 0ffh,0, 0ffh dup('$')
    sente byte 'Please enter the sentence:', 0ah, 0dh, '$'
    keys  byte 'Please enter the keys:', 0ah, 0dh, '$'
    ostr0 byte 'matched!$'
    ostr1 byte 'unmatched!$'
    crlf byte 0ah, 0dh,'$'
    table byte '0123456789ABCDEF$'
    position byte 'Position:0$'
data ends

stack segment
    db 0ffh dup(0)
stack ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov sp, 0ffh

    lea dx, sente ; 
    mov ah, 9h
    int 21h

    mov ah, 0ah
    mov dx, offset istr0
    int 21h
    call func_crlf

    lea dx, keys
    mov ah, 9h
    int 21h

    mov ah, 0ah
    mov dx, offset istr1
    int 21h
    call func_crlf

    mov dx, offset istr0
    add dx, 1
    mov bx, dx
    xor cx, cx
    mov cl, [bx] ; the loop of compared string
count:
    inc bx
    call comp_str
    cmp bp, 1
    je match
    loop count
    mov dx, offset ostr1
    jmp goon
match: 
    mov dx, offset ostr0
goon:
    mov ah, 9
    int 21h
    mov al, cl
    mov ah, 0
    push ax
    lea dx, istr0
    inc dx
    mov bx, dx
    mov al, [bx]
    mov ah, 0
    push ax
    call func_print_pos
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
    pop cx
    pop bx
    ret
func_crlf:
    push ax
    lea dx, crlf
    mov ah, 9
    int 21h
    pop ax
    ret
func_print_pos: 
    lea dx, position
    mov ah, 9h
    int 21h
    push bp
    mov bp, sp
    mov ax, [bp+4]
    sub ax, [bp+6]
    push bx
    push dx
    push di
    xor di, di
    mov bl, 0fh
    mov cx, 0ffffh
while_16:
    div bl
    cmp al, 0
    push ax
    mov al, ah
    mov ah, 0
    mov di, ax
    lea dx, table
    mov bx, dx
    mov dl, [bx+di]
    call print_chr
    xor ax, ax
    pop ax
    mov ah, 0
    je break_0
    loop while_16
break_0:
    call tail_h
    pop di
    pop dx
    pop bx
    pop bp
    ret 4
print_chr:
    push ax
    mov ah, 02h
    int 21h
    pop ax
    ret
tail_h: ; function tail h to print tail char h
    push ax
    push dx
    mov dl, 'H'
    mov ah, 02h
    int 21h
    pop dx
    pop ax
    ret


code ends
end start
