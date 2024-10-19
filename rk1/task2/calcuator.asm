calcuate_sum:
    push rax           ; Сохранить rax
    push rbx           ; Сохранить rbx
    push rcx           ; Сохранить rcx
    mov rbx, rax       ; Начальное значение N в rbx
    xor rdi, rdi       ; Инициализация суммы (rdi)

.loop:
    mov rax, rbx       ; Копировать текущее значение rbx в rax
    call reverse_digits ; Реверсировать цифры в rax
    add rdi, rax       ; Добавить результат к сумме
    dec rbx            ; Уменьшить rbx на 1
    jnz .loop          ; Повторять, пока rbx не станет 0

    pop rcx            ; Восстановить rcx
    pop rbx            ; Восстановить rbx
    pop rax            ; Восстановить rax
    ret                ; Вернуться из функции


reverse_digits:
    push rbx
    push rcx
    push rdi
    xor rcx, rcx       ; Обнуляем rcx для подсчета количества цифр
.push_digits:
    xor rdx, rdx       ; Обнуляем rdx перед делением
    mov rdi, 10        ; Делим на 10
    div rdi             ; rax = rax / 10, rdx = остаток (последняя цифра)
    push rdx           ; Сохраняем последнюю цифру на стеке
    inc rcx            ; Увеличиваем счетчик цифр
    xor rdx, rdx
    test rax, rax      ; Проверяем, не стало ли rax нулем
    jnz .push_digits    ; Если не ноль, продолжаем извлекать цифры
    mov rdi, 0
    mov rbx, rcx
.pop_digits:
    
    pop rax            ; Извлекаем цифру из стека
    push rcx
    push rbx
    sub rbx, rcx
    mov rcx, rbx
    pop rbx
    mov rdi, 10        ; Умножаем на 10
    push rdx

.loop_multiply:
    test rcx, rcx      ; Проверяем, остались ли еще цифры
    jz .main_loop       ; Если нет, переходим к главному циклу
    mul rdi            ; Умножаем rax на 10
    dec rcx            ; Уменьшаем счетчик цифр
    jmp .loop_multiply  ; Повторяем для следующей позиции

.main_loop:
    pop rdx
    add rdx, rax
    pop rcx
    dec rcx
    jnz .pop_digits    ; Если остались, продолжаем извлекать цифрыъ
    mov rax, rdx
    pop rdi
    pop rcx
    pop rbx
    ret                 ; Возврат из функции