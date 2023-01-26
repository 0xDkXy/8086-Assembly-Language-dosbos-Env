.model huge
assume cs:code, ds:data, ss:stack

data segment
    digit db 0
    letter db 0
    char db 0
    ostr1 byte 'Counting result:', 0ah, 0dh, '$'
    ostr0 byte 'Please input text you want count characters:', 0ah, 0dh, '$'
    asciitable byte 128 dup(0)
    input_text byte 0ffh, 0, 0ffh dup('$')
    digittable db '0123456789'
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

    lea ax, ostr0
    push ax
    call print

    lea ax, input_text
    push ax
    call get_char

    lea ax, input_text
    push ax
    call count

    call print_char
    ;call print_digit
    ;call print_letter

    mov ax , 4c00h
    int 21h

; ===========================
; function area
print_char:
    push ax
    push bx
    lea ax, char
    mov bx, ax
    xor ax, ax
    mov al, [bx]
    push ax
    call print_dex
    pop bx
    pop ax
    ret

print_dex:
    push bp
    mov bp, sp
    mov ax, [bp+4]
    push cx
    push dx
    push bx
    xor bx, bx
    mov cx, 0ffh
    mov dl, 0ah
    mov dx, sp ; keep sp
loop_dex:
    div dl
    push ah
    xor ah, ah
    inc bx
    cmp ax, 0
    je out_dex
    loop loop_dex
out_dex:
    mov cx, bx
    push dx
    xor dx, dx
loop_dex0:
    pop dl
    mov ah, 02h
    int 21h
    loop loop_dex0
    pop dx
    pop bx
    pop dx
    pop cx
    pop bp
    ret 2
print:
    push bp
    mov bp, sp
    push dx
    mov dx, [bp+4]
    mov ah, 09h
    int 21h
    pop dx
    pop bp
    ret 2

get_char:
    push bp
    mov bp, sp
    mov dx, [bp+4]
    mov ah, 0ah
    int 21h
    pop bp
    ret 2
    
count:
    push bp
    mov bp, sp
    push bx
    mov bx, [bp+4]
    inc bx
    push cx
    xor cx, cx
    mov cl, [bx]
    inc bx
loop0:
    xor ax, ax
    mov al, [bx]
    call compare_and_store
    inc bx
    loop loop0
    pop cx
    pop bx
    pop bp
    ret 2

compare_and_store:
    cmp ax, 030h
    jnb label0
    ;=== ascii below 48, other character===
    push ax
    lea ax, char
    push ax
    call inc_count
    pop ax
    ret
label0:
    ;===not below 48===
    cmp ax, 039h
    jnb label1
    ;=== is digit ===
    push ax
    lea ax, digit
    push ax
    call inc_count
    pop ax
    ret
label1:
    cmp ax, 041h
    jnb label2
    ;===other char===
    push ax
    lea ax, char
    push ax
    call inc_count
    pop ax
    ret
label2:
    cmp ax, 05bh
    jnb label3
    ;===upper case letter===
    push ax
    lea ax, letter
    push ax
    call inc_count
    pop ax
    ret
label3:
    cmp ax, 061h
    jnb label4
    ;===other char===
    push ax
    lea ax, char
    push ax
    call inc_count
    pop ax
    ret
label4:
    cmp ax, 07bh
    jnb label5
    ;===lower case letter
    push ax
    lea ax, letter
    push ax
    call inc_count
    pop ax
    ret
label5:
    ;===other letter===
    push ax
    lea ax, char
    push ax
    call inc_count
    pop ax
    ret


inc_count:
    push bp
    mov bp, sp
    push bx
    push ax
    mov ax, [bp+4]
    mov bx, ax
    mov al, [bx]
    inc al
    mov [bx], al
    pop ax
    pop bx
    pop bp
    ret 2

code ends
end start
