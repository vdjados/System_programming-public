format elf64
public _start

include 'func.asm'

section '.data' writable

buffer rb 101

section '.text' executable

_start:
   pop rcx ;читаем количество параметров командной строки
   cmp rcx, 5 ;если один параметр(имя исполняемого файла)
   jne .l1 ;завершаем работу

   mov rdi,[rsp+8] ;загружаем адрес имени файла из стека
   mov rax, 2 ;системный вызов открытия файла
   mov rsi, 0o ;Права только на чтение
   syscall
   cmp rax, 0 ;если вернулось отрицательное значение,
   jl .l1 ;то произошла ошибка открытия файла, также завершаем работу
   
   mov r8, rax ;сохраняем файловый дескриптор

    
   mov rdi,[rsp+16] 
   mov rax, 2 
   ;;Формируем O_WRONLY|O_TRUNC|O_CREAT
   mov rsi, 577
   mov rdx, 777o
   syscall 
   cmp rax, 0 
      jl .l1
   mov r9, rax         ; Сохраняем дескриптор выходного файла

  mov rsi, [rsp+24]
  call str_number
  mov r10, rax

  mov rsi, [rsp+32]
  call str_number
  mov r11, rax

    sub r10, r11             ; n - k
    mov r12, r10             ; сохраняем n-k в r12
    add r10, r11             ; n + k

.loop_read: ;начинаем цикл чтения из файла
   mov rax, 0            ; Номер системного вызова для чтения
   mov rdi, r8           ; Файловый дескриптор
   mov rsi, buffer       ; Буфер для хранения прочитанного символа
   mov rdx, 100         ; Читаем 100 байт
   syscall               ; Выполняем системный вызов read
   cmp rax, 0            ; Проверяем, прочитали ли 0 байт (EOF)
   je .next              ; Если да, выходим из цикла

   ; Печатаем символы от n до n-k
    mov rbx, rax            ; сохраняем количество прочитанных байт в rbx
    lea r13, [buffer + r10] ; устанавливаем указатель на n
    lea r14, [buffer + r10] ; устанавливаем указатель на n
    mov rdi, r9
.print_loop:

    cmp r12, r10            ; сравниваем с n
    jg .next               ; если n-k > n, выходим
    cmp r13, r14
    je .skip
    mov rax, 1              ; системный вызов для записи
    mov rsi, r13            ; буфер с символом
    mov rdx, 1              ; записываем 1 байт
    syscall
    .skip:
    mov rax, 1              ; системный вызов для записи
    mov rsi, r14            ; буфер с символом
    mov rdx, 1              ; записываем 1 байт
    syscall

    dec r10                  ; уменьшаем указатель
    inc r14
    dec r13                  ; переходим к предыдущему символу
    jmp .print_loop         ; продолжаем печать

   jmp .loop_read        ; Продолжаем чтение
 
.next:   ;;Системный вызов close
   mov rdi, r8
   mov rax, 3
   syscall
   
.l1:
   call exit