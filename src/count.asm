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
    endl_str db 0ah, 0dh, '$'
    digit_str db 'digit:', 0ah, 0dh, '$'
    letter_str db 'letter:', 0ah, 0dh, '$'
    other_str db 'other:', 0ah, 0dh, '$'
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
    call endl

    lea ax, input_text
    push ax
    call count

    lea ax, ostr1
    push ax
    call print
    
    lea ax, digit_str
    push ax
    call print
    lea bx, digit
    xor ax, ax
    mov al, [bx]
    push ax
    call print_dex
    call endl

    lea ax, letter_str
    push ax
    call print
    lea bx, letter
    xor ax, ax
    mov al, [bx]
    push ax
    call print_dex
    call endl
     
    lea ax, other_str
    push ax
    call print
    lea bx, char
    xor ax, ax
    mov al, [bx]
    push ax
    call print_dex
    call endl

    mov ax , 4c00h
    int 21h

; ===========================
; function area
print_dex: ; function to print dex
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    mov ax,[bp+4] ; move target number to ax
    mov dl, 0ah
    xor cx, cx
    xor bx, bx
div_0:
    div dl
    mov bl, ah
    xor ah, ah
    push bx
    inc cx
    cmp ax, 0
    jne div_0
loop_pop:
    xor dx, dx
    pop dx
    add dx, 030h
    mov ah, 02h
    int 21h
    loop loop_pop
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2
;====print_dex End====

endl: ; print \n
    push ax
    push dx
    lea dx, endl_str
    mov ah, 09h
    int 21h
    pop dx
    pop ax
    ret
; endl end

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

;======function area end========

code ends
end start
