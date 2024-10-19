format ELF64
public _start
public calcuate_sum

include 'help.asm'
include 'calcuator.asm'

section '.bss' writable
    place rb 255
    answer rb 2
    
section '.text' executable
_start:
    mov rsi, place
    call input_keyboard
    call str_number
    call calcuate_sum
    mov rax, rdi
    mov rsi, answer
    call number_str
    call print_str
    call new_line
    call exit