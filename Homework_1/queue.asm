format ELF64

section '.bss' writable
    head  rq 1
    tail  rq 1
    size  rq 1
    buffer rb 1
    f db "/dev/random", 0

section '.text' executable
    public init_queue
    public free_queue
    public q_push
    public q_pop
    public rand_fill
    public count_even_numbers
    public ends_with_one
    public count_odd

include 'func.asm'

init_queue:
    mov rbx, rdi
    imul rbx, 8
    mov [size],rbx

	mov rdi, 0
	mov rsi, rbx
	mov rdx, 0x3
	mov r10,0x22
	mov r8, -1
	mov r9, 0
	mov rax, 9
	syscall

    mov [head], rax
    mov [tail], rax
    ret


free_queue:
    mov rdi, [head]
    mov rsi, [size]
    mov rax, 11
    syscall
    ret

q_push:

    mov rbx, [tail]
    mov rcx, [head]
    add rcx, [size]


    cmp rbx, rcx
    jae .overflow


    mov [rbx], rdi
    add rbx, 8
    mov [tail], rbx

    mov rax, 0
    ret

.overflow:
    mov rax, -1
    ret

q_pop:
    mov rax, [head]
    mov rcx, [rax]
    push rcx
    xor rcx, rcx
    .loop:
        mov rbx, [rax+8]
        mov [rax], rbx

        add rax, 8
        add rcx, 8
        cmp rcx, [size]
        jl .loop
    pop rax
    ret

rand_fill:
    mov r8, rdi
    imul r8, 8
    add r8, [tail]
    mov rax, 2
    mov rdi, f
    mov rsi, 0o
    syscall
    mov r9, rax
    .loop:
    cmp r8, [tail]
    je .fin
    mov rax, 0
    mov rdi, r9
    mov rsi, buffer
    mov rdx, 1
    syscall
    xor rax, rax
    xor rdi, rdi
    mov al, byte[rsi]
    add rdi, rax
    call q_push
    jmp .loop
    .fin:
    mov rax, 3
    mov rdi, r9
    syscall
    ret

count_even_numbers:
    xor r8, r8                 
    mov r9, [head]           
.loop:
    cmp r9, [tail]           
    jge .fin
    mov rdi, [r9]             
    xor rdx, rdx              
    mov rcx, 2                
    div rcx                     
    cmp rdx, 0                 
    jne .not_even
    inc r8                    
.not_even:
    add r9, 8                  
    jmp .loop
.fin:
    mov rax, r8                
    ret


ends_with_one:
    xor r8, r8
    mov r9, [head]
    .loop:
    cmp r9, [tail]
    jge .fin
    xor rdx, rdx
    mov rax, [r9]
    mov rdi, 10
    div rdi
    add r9, 8
    cmp rdx, 1
    jne .loop
    inc r8
    jmp .loop
    .fin:
    mov rax, r8
    ret

count_odd:
    mov rbx, [head]
    xor r8, r8
    jmp .loop



    .loop:
    cmp rbx, [tail]
    jge .fin

    mov rax, [rbx]
    add rbx, 8
    xor rdx, rdx
    mov rcx, 2
    div rcx
    cmp rdx, 0
    je .loop
    inc r8
    jmp .loop

    .fin:
    mov rax, r8
    ret