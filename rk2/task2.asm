format ELF64

include 'func.asm'

public _start

THREAD_FLAGS=2147585792

section '.bss' writable
    array dq ?
    buffer rb 10
    stack1 rq 4096
    stack2 rq 4096
    
section '.text' executable
_start:
    mov rsi, [rsp+16]
    xor rax, rax
    call str_number
    mov r8, rax

    xor rdi,rdi
 mov rax, 12
 syscall
    mov [array], rax
    
    mov rdi, [array]
 add rdi, r8
    mov rax, 12
 syscall

    mov rsi, [array]
    mov rcx, 1
    .fill_loop:
        cmp rcx, r8
        jg .next
        mov byte[rsi], cl
        inc rsi
        inc rcx
        jmp .fill_loop

    .next:    
    mov rax, 56                 ; first child
    mov rdi, THREAD_FLAGS
    mov rsi, 4095
    add rsi, stack1
    syscall

    cmp rax, 0
    je .first

    mov rax, 56                 ; second child
    mov rdi, THREAD_FLAGS
    mov rsi, 4095
    add rsi, stack2
    syscall

    cmp rax, 0
    je .second
    
    mov rax, 61
    mov rdi, -1
    mov rdx, 0
    mov r10, 0
    syscall

    mov rsi, [array]
    xor rcx, rcx
    xor rax, rax
    .print_loop:
        cmp rcx, r8
        je .end
        mov al, byte[rsi+rcx]
        push rsi
        mov rsi, buffer
        call number_str
        call print_str
        call new_line
        pop rsi
        inc rcx
        jmp .print_loop

    .end:
    call exit
    call exit
    
.first:
    mov rsi, [array]
    xor rcx, rcx
    xor rax, rax
    mov rbx, 2
    .even_loop:
        cmp rcx, r8
        je .end

        mov al, byte[rsi+rcx]
        xor rdx, rdx
        div rbx
        cmp rdx, 0
        jne @f
        inc byte[rsi+rcx]

        @@:
        inc rcx
        jmp .even_loop

.second:
    mov rsi, [array]
    xor rcx, rcx
    xor rax, rax
    mov rbx, 2
    .odd_loop:
        cmp rcx, r8
        je .end

        mov al, byte[rsi+rcx]
        xor rdx, rdx
        div rbx
        cmp rdx, 0
        je @f
        dec byte[rsi+rcx]

        @@:
        inc rcx
        jmp .odd_loop