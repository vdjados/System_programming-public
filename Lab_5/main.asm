format elf64
public _start

include 'func.asm'

section '.data' writable

buffer rb 101

section '.text' executable

_start:
   pop rcx ;читаем количество параметров командной строки
   cmp rcx, 3 ;если один параметр(имя исполняемого файла)
   jne .l1 ;завершаем работу

   mov rdi,[rsp+8] ;загружаем адрес имени файла из стека
   mov rax, 2 ;системный вызов открытия файла
   mov rsi, 0o ;Права только на чтение
   syscall
   cmp rax, 0 ;если вернулось отрицательное значение,
   jl .l1 ;то произошла ошибка открытия файла, также завершаем работу
   
   mov r8, rax ;сохраняем файловый дескриптор

   ; Получаем имя выходного файла
   mov rdi,[rsp+16] 
   mov rax, 2 
   ;;Формируем O_WRONLY|O_TRUNC|O_CREAT
   mov rsi, 577
   mov rdx, 777o
   syscall 
   cmp rax, 0 
      jl .l1
   mov r9, rax         ; Сохраняем дескриптор выходного файла
   
.loop_read: ;начинаем цикл чтения из файла
   mov rax, 0            ; Номер системного вызова для чтения
   mov rdi, r8           ; Файловый дескриптор
   mov rsi, buffer       ; Буфер для хранения прочитанного символа
   mov rdx, 1            ; Читаем 1 байт
   syscall               ; Выполняем системный вызов read
   cmp rax, 0            ; Проверяем, прочитали ли 0 байт (EOF)
   je .next              ; Если да, выходим из цикла
   cmp byte [buffer], 'A'
   je .loop_read
   cmp byte [buffer], 'E'
   je .loop_read
   cmp byte [buffer], 'I'
   je .loop_read
   cmp byte [buffer], 'O'
   je .loop_read
   cmp byte [buffer], 'U'
   je .loop_read
   cmp byte [buffer], 'Y'
   je .loop_read


    mov rdi, r9         ; Дескриптор выходного файла
   mov rax, 1          ; Системный вызов для записи
   mov rsi, buffer     ; Буфер с символом
   mov rdx, 1          ; Записываем 1 байт
   syscall
   
   jmp .loop_read        ; Продолжаем чтение
 
.next:   ;;Системный вызов close
   mov rdi, r8
   mov rax, 3
   syscall
   
.l1:
   call exit