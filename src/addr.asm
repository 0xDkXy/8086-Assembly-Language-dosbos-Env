.model huge
assume cs:code, ds:data, ss:stack 


person struct
    name_str db 20 dup(020h)
    tel_str db 8 dup(020h)
person ends

data segment
    store_list person 50 dup(<>)
    person_buffer person <>
    input_buffer db 20, 0, 20 dup(0)
    output_buffer db 128 dup(0)
    endl_str db 0ah, '$'
    number db 0
    press_str db 'press the index of function you want to choose:' ,0ah, '$'
    index_1 db '1. new item',0ah, '$'
    index_2 db '2. search name', 0ah, '$'
    index_3 db '3. EXIT', 0ah, '$'
    name_query db '? name:', 0ah, '$'
    name_ db 'please input name:', 0ah, '$'
    tel_ db 'please input phone number:', 0ah, '$'
    title_bar db 'name.', 09h, 'tel.', 0ah, '$'
data ends

stack segment
    dw 0ffh dup(0)
stack ends

code segment
start:
    ;initial
    mov ax, data
    mov ds, ax
    mov es, ax
    mov ax, stack
    mov ss, ax
    mov sp, 0ffh

    ;main loop
main_loop:
    call print_all_list
    lea ax, index_1
    push ax
    call print_str

    lea ax, index_2
    push ax
    call print_str

    lea ax, index_3
    push ax
    call print_str
    
    call get_char
    call endl
    cmp al, 033h
    je _end
    cmp al, 031h
    jne onelabel
    call add_item
    call sort_list
    jmp main_loop
    onelabel:
    call search_name

    jmp main_loop


    ; end
    _end:
    mov ax, 4c00h
    int 21h

;=====function area=======
print_all_list:
    push ax
    push bx
    push cx

    lea bx, number
    mov cx, 0
    mov cl, [bx]
    lea ax, store_list
    cmp cx, 0
    je print_all_list_0
    print_all_list_inner:
        push ax
        mov bx, 28
        push bx
        call copy_to_output_buffer
        lea bx, output_buffer
        push bx
        call print_str
        call endl
        add ax, 28
        
    loop print_all_list_inner
    print_all_list_0:

    pop cx
    pop bx
    pop ax
    ret
;print_all_list end

copy_to_output_buffer:
    push bp
    mov bp, sp
    push ax
    push cx
    push si
    push di

    mov ax, [bp+6]
    mov si, ax
    mov cx, [bp+4]
    lea ax, output_buffer
    mov di, ax
    rep movsb
    mov [di], '$'

    pop di
    pop si
    pop cx
    pop ax
    pop bp
    ret 4
;copy_to_output_buffer end
add_item:
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    ;get name
    lea ax, name_
    push ax
    call print_str
    call get_str

    lea bx, input_buffer
    add bx, 2
    push bx

    lea bx, number
    mov al, [bx]
    mov ah, 0
    lea bx, store_list
    mov dx, 0
    mov dl, 28
    mul dl
    add bx, ax
    push bx

    lea bx, input_buffer
    inc bx
    mov al, [bx]
    mov ah, 0
    push ax
    


    call mov_data

    ;get phone number
    lea ax, tel_
    push ax
    call print_str
    call get_str

    lea bx, input_buffer
    add bx, 2
    push bx

    lea bx, number
    mov al, [bx]
    mov ah, 0
    lea bx, store_list
    mov dx, 0
    mov dl, 28
    mul dl
    add bx, ax
    ;add bx, 20
    lea dx, [bx].store_list.tel_str
    push dx

    lea bx, input_buffer
    inc bx
    mov al, [bx]
    mov ah, 0
    push ax
    


    call mov_data

    ;increse count number
    lea bx, number
    mov ax, 0
    mov al, [bx]
    inc ax
    mov [bx], al

    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret

;add_item end

sort_list:
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    lea bx, number
    mov cx, 0
    mov cl, [bx]
    lea bx, store_list
    mov ax, 0
    mov dx, 0

sort_list_loop:
    push cx
    push ax
    lea bx, number
    mov cx, 0
    mov cl, [bx]
    sub cx, ax
    mov si, dx
    mov di, dx
    sort_list_loop_inner:
        push si
        push di
        call compare_name
        pop ax
        cmp ax, 1
        jne no_swap
        push si
        push di
        call swap_person
        no_swap:
        add di, 28
        
    loop sort_list_loop_inner
    
    pop ax
    inc ax
    add dx, 28
    pop cx
    loop sort_list_loop
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
;sort_list end

compare_name:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di
        
    mov si, [bp+6]
    mov di, [bp+4]
    mov cx, 20
    compare_name_loop:
        mov al, [si]
        mov ah, [di]
        cmp ah, al
        jnb _not_below
        mov ax, 1
        jmp compare_name_loop_out
        _not_below:
        inc si
        inc di
    loop compare_name_loop
    mov ax, 0
    compare_name_loop_out:
    mov [bp+6], ax
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax

    pop bp
    ret 2
;compare_name end

swap_person:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov ax, [bp+6]
    mov bx, [bp+4]
    mov cx, 28
    lea dx, person_buffer

    push ax
    push dx
    push cx
    call mov_data

    push bx
    push ax
    push cx
    call mov_data

    push dx
    push bx
    push cx
    call mov_data

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4
;swap_person end


search_name:
    ret
;search_name end

mov_data: ; param: address0, address1, len. copy from 0 to 1
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    mov ax, [bp+8]; 0
    mov dx, [bp+6]; 1
    mov cx, [bp+4]
    mov si, ax
    mov di, dx

    rep movsb

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 6
;mov_data end

get_str:
    push ax
    push bx
    push cx
    push dx
    mov ah, 0ah
    lea dx, input_buffer
    int 21h
    call endl
    pop dx
    pop cx
    pop bx
    pop ax
    ret
    
;get_str end
get_char:
    mov ah, 01h
    int 21h
    ret
;get_char end

print_str:
    push bp
    mov bp, sp
    push ax
    push dx
    mov dx, [bp+4]
    mov ah, 09h
    int 21h
    pop dx
    pop ax
    pop bp
    ret 2
;print_str end

endl:
    push ax
    push dx
    lea dx, endl_str
    mov ah, 09h
    int 21h
    pop dx
    pop ax
    ret
;endl end


code ends
end start


