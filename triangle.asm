global _start

section .text
    
    handle_args:
        mov r10b, byte [r9]
        cmp r10b, 0
        je stars
        sub r10b, 48
        inc r9
        mov al, r10b
        mul r11
        add r8, rax
        mov rax, r11
        mov rcx, 10
        div rcx
        mov r11, rax
        jmp handle_args

    prep_args:
        mov r10b, byte [rdx]
        cmp r10b, 0
        je handle_args

        inc rdx
        push rdx
        mov rax, r11
        mov rcx, 10
        mul rcx
        pop rdx
        mov r11, rax
        jmp prep_args
        

    _start:
        mov r8, 0       ; value
        mov r11, 1      ; multiplier
        mov rax, [rsp]
        cmp rax, 1
        je zero_arguements
        mov r9, [rsp+16]
        mov rdx, [rsp+16]
        inc rdx
        
        jmp prep_args 

    stars:
        mov rdx, 0                  ; initialise length of string = 0
        mov r9, 1                   ; holds number of stars that need to be printed in this line
        mov r10, 0                  ; number of stars that is currently printed on this line
        mov r11, output             ; r11 holds the address of output

    add_stars:
        mov byte [r11], '*'         ; add * to output
        inc r11                     ; increase r11 to hold address of next byte
        inc r10                     ; +1 to stars on current line
        inc rdx                     ; +1 to size of output
        cmp r10, r9                 ; if stars on current line is less than stars needed then loop
        jl add_stars

    new_line:
        mov byte [r11], 10          ; add a new line to output
        inc r11                     ; increase r11 to hold address of next byte
        inc rdx                     ; increment size of output
        dec r8                      ; decrease number of lines needed to printed in total
        inc r9                      ; increment starts need to be printed on this line
        mov r10, 0                  ; reset number of stars currently printed to 0
        cmp r8, 0                   ; check if number of lines is 0
        jg add_stars                ; go back to adding stars 
        mov byte [r11], 0           ; if equal to zero add null character
        inc rdx                     ; increment size of output

    print_tree:
        mov rax, 1                  ; write syscall
        mov rdi, 1                  ; stdout
        mov rsi, output             ; starting address of output
        syscall 

    exit:
        mov rax, 60                 ; exit syscall
        mov rdi, 0                  ; no error
        syscall

    zero_arguements:
        mov rax, 1
        mov rdi, 1
        mov rsi, menu
        mov rdx, menu.length
        syscall

        jmp exit
        
section .data
    menu: 
        db "Args:", 10, "   n: number of lines.", 10, 0
        .length equ $ - menu

    lines equ 5                   ; lines that need to be printed

section .bss
    output: resb 10240               ; maximum length of ouput
