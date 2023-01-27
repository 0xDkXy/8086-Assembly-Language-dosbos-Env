.model huge
assume cs:code, ds:data, ss:stack

data segment
    useless db 0ffh dup(0)
    input_int db 14, 0, 14 dup(0)
    int_128_0 db 1, 15 dup(0)
    int_128_1 db 1, 15 dup(0)
    int_128_2 db 16 dup(0)
    endl_str db 0ah, 0dh, '$'
    dextable db '0123456789ABCDEF'
data ends

stack segment
    db 0ffffh dup(0)
stack ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov es, ax
    mov ax, stack
    mov ss, ax
    mov sp, 0fffh
    ;===========

    lea ax, input_int
    push ax
    call get_str
    call endl

    lea ax, input_int
    push ax
    call str_to_dex
    pop cx; return loop number

    cmp cx, 1
    jne upper_1
    mov ah, 02h
    mov dl, 031h
    int 21h
    call endl
    jmp end_
upper_1:
    cmp cx, 2
    jne upper_2
    mov ah, 02h
    mov dl, 032h
    int 21h
    call endl
    jmp end_
upper_2:
    sub cx, 2

loop_main:
    call calc_fib_once
    loop loop_main

    xor cx, cx
div_main_loop:
    push ax
    call div_big_number
    pop ax ; use ax to receipt the rest
    push ax
    inc cx

    push ax
    call check_zero ; check int_128_1 is zero or not
    pop ax
    cmp ax, 0
    jne div_main_loop

    ;push cx
    ;call print_hex
    ;call endl
;print dex
print_dex_loop:
    pop ax
    add ax, 030h
    mov dl, al
    mov ah, 02h
    int 21h
    loop print_dex_loop

end_:
    mov ax, 4c00h
    int 21h
    
;=====function area======
print_hex:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx

    mov ax, [bp+4]
    add ax, 030h
    mov dl, al
    mov ah, 02h
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2

check_zero:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    
    mov cx, 0fh
    lea ax, int_128_1
    mov bx, ax
    xor ax, ax
loop_check_zero:
    or al, [bx]
    inc bx
    loop loop_check_zero
    mov [bp+4], ax

    pop cx
    pop bx
    pop ax
    pop bp
    ret

hex_to_dex:

;hex_to_dex end

div_big_number:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push di
    push si

    lea ax, int_128_1
    mov di, ax
    add di, 0eh
    lea ax, int_128_2
    mov si, ax
    add si, 0eh
    mov cx, 0fh
    mov bl, 0ah

    mov ah, [di+1]
loop_div_0:
    mov al, [di]
    div bl
    xor dx, dx
    mov dl, al
    mov [si], dl
    sub si, 1
    sub di,1
    loop loop_div_0

    mov al, ah; move rest to al
    xor ah, ah
    mov [bp+4], ax ;use stack to return

    lea ax, int_128_1
    mov di, ax
    lea ax, int_128_2
    mov si, ax
    mov cx, 0fh
    rep movsb

    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret

endl:
    push ax
    push dx
    mov ah, 09h
    lea dx, endl_str
    int 21h
    pop ax
    pop dx
    ret
;endl end

get_str:; function  get input string
    push bp
    mov bp, sp
    push ax
    push dx
    
    mov dx, [bp+4]
    mov ah, 0ah
    int 21h
    
    pop dx
    pop ax
    pop bp
    ret 2
;get_str end

str_to_dex:
    push bp
    mov bp, sp
    push ax
    push cx
    push dx
    push bx

    mov bx, [bp+4]
    inc bx
    xor cx, cx
    mov cl, [bx]
    inc bx
    xor dx, dx
    xor ax, ax

loop_2dex:
    push cx
    mov cx, 0ah
    mul cl
    pop cx
    mov dl, [bx]
    sub dx, 030h
    add al, dl
    inc bx
    loop loop_2dex
    mov [bp+4], ax
    
    pop bx
    pop dx
    pop cx
    pop ax
    pop bp
    ret
; str_to_dex end

calc_fib_once:
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov cx, 08h
    lea ax, int_128_0
    mov si, ax
    lea ax, int_128_1
    mov di, ax
    lea bx, int_128_2
    xor ax, ax
    xor dx, dx
    CLC

loop_calc_0:
    mov ax, [si]
    mov dx, [di]
    adc ax, dx
    mov [bx], ax
    pushf
    add si, 2
    add di, 2
    add bx, 2
    popf
    loop loop_calc_0

    lea ax, int_128_0
    mov di, ax
    lea ax, int_128_1
    mov si, ax
    mov cx, 08h
    rep movsw

    lea ax, int_128_1
    mov di, ax
    lea ax, int_128_2
    mov si,ax
    mov cx, 08h
    rep movsw

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
;calc_fib_once end

code ends
end start
