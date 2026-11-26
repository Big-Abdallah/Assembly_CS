; ============================================
;  VENDO - Vending Machine (8086, TASM)
;  Abdallah Mohamed
; ============================================

printstr macro msg
    lea dx, msg
    mov ah, 9
    int 21h
endm

.model small
.stack 100h

.data
    ; ---- product names (padded for alignment) ----
    n1 db 'Water     $'
    n2 db 'Juice     $'
    n3 db 'Chips     $'
    n4 db 'Biscuits  $'
    n5 db 'Chocolate $'
    name_tbl dw offset n1, offset n2, offset n3, offset n4, offset n5

    ; ---- prices and stock (index 0..4) ----
    prices db 5, 10, 8, 6, 12
    stock  db 5, 5, 5, 5, 5
    total  dw 0                      ; total sales

    ; ---- messages ----
    title_msg db 13,10,'===== VENDO - Vending Machine =====',13,10,'$'
    msg_price db '  Price: $'
    msg_stock db '  Stock: $'
    msg_choose db 13,10,'Choose product (1-5): $'
    msg_bad   db 13,10,'Invalid choice!',13,10,'$'
    msg_out   db 13,10,'Sorry, this product is out of stock!',13,10,'$'
    msg_pay   db 13,10,'Insert money: $'
    msg_low   db 13,10,'Not enough money! Money returned.',13,10,'$'
    msg_ok    db 13,10,'Enjoy your product!',13,10,'$'
    msg_change db 'Your change: $'
    msg_again db 13,10,'Another purchase? (y/n): $'
    msg_total db 13,10,'Total sales today: $'
    msg_bye   db 13,10,'Thank you for using VENDO!',13,10,'$'
    nl        db 13,10,'$'

.code
main proc
    mov ax, @data
    mov ds, ax

start_menu:
    call show_menu
    printstr msg_choose
    call read_num                    ; AX = chosen number

    ; ---- validate choice (1..5) ----
    cmp ax, 1
    jl  bad_choice
    cmp ax, 5
    jle choice_ok
bad_choice:
    printstr msg_bad
    jmp start_menu

choice_ok:
    dec ax
    mov si, ax                       ; SI = product index (0..4)

    ; ---- check stock ----
    cmp stock[si], 0
    jne have_stock
    printstr msg_out
    jmp start_menu

have_stock:
    ; ---- read payment ----
    printstr msg_pay
    call read_num                    ; AX = money inserted

    ; ---- check money >= price ----
    mov bl, prices[si]
    xor bh, bh                       ; BX = price
    cmp ax, bx
    jge pay_ok
    printstr msg_low
    jmp start_menu

pay_ok:
    sub ax, bx                       ; AX = change
    dec stock[si]                    ; update stock
    add total, bx                    ; update sales

    push ax                          ; <<< save the change

    printstr msg_ok
    printstr msg_change

    pop ax                           ; <<< restore the change
    call print_num                   ; print change (AX)
    printstr nl
    
ask_again:
    printstr msg_again
    mov ah, 1
    int 21h
    cmp al, 'y'
    je  restart
    cmp al, 'Y'
    je  restart
    jmp exit_prog
restart:
    jmp start_menu

exit_prog:
    printstr msg_total
    mov ax, total
    call print_num
    printstr msg_bye
    mov ah, 4Ch
    int 21h
main endp

; --------------------------------------------
; show_menu : prints the product list
; --------------------------------------------
show_menu proc
    push ax
    push bx
    push dx
    push si

    printstr title_msg
    xor si, si                       ; index = 0

menu_loop:
    mov ax, si
    inc ax
    call print_num                   ; product number
    mov dl, '.'
    mov ah, 2
    int 21h
    mov dl, ' '
    mov ah, 2
    int 21h

    mov bx, si
    shl bx, 1                        ; word table -> index*2
    mov dx, name_tbl[bx]
    mov ah, 9
    int 21h                          ; product name

    printstr msg_price
    mov al, prices[si]
    xor ah, ah
    call print_num

    printstr msg_stock
    mov al, stock[si]
    xor ah, ah
    call print_num

    printstr nl
    inc si
    cmp si, 5
    jb  menu_loop

    pop si
    pop dx
    pop bx
    pop ax
    ret
show_menu endp

; --------------------------------------------
; read_num : reads a decimal number until Enter
; output: AX = number
; --------------------------------------------
read_num proc
    push bx
    push cx
    push dx
    xor bx, bx                       ; accumulator = 0

read_loop:
    mov ah, 1
    int 21h                          ; read char (with echo)
    cmp al, 13
    je  read_done
    cmp al, '0'
    jb  read_loop                    ; ignore non-digits
    cmp al, '9'
    ja  read_loop

    sub al, '0'
    xor ah, ah
    mov cx, ax                       ; CX = digit
    mov ax, bx
    mov dx, 10
    mul dx                           ; AX = acc * 10
    add ax, cx
    mov bx, ax
    jmp read_loop

read_done:
    mov ax, bx
    pop dx
    pop cx
    pop bx
    ret
read_num endp

; --------------------------------------------
; print_num : prints AX as decimal
; --------------------------------------------
print_num proc
    push ax
    push bx
    push cx
    push dx

    xor cx, cx                       ; digit counter
    mov bx, 10
pn_div:
    xor dx, dx
    div bx                           ; AX / 10 -> remainder in DX
    push dx
    inc cx
    cmp ax, 0
    jne pn_div

pn_print:
    pop dx
    add dl, '0'
    mov ah, 2
    int 21h
    loop pn_print

    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num endp

end main