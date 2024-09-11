format ELF
public _start
surname db "Bodnya", 0xA, 0
name db "Vladislav", 0xA, 0
second_name db "Alexandrovich", 0xA, 0

_start:
    ;инициализация регистров для вывода информации на экран
    mov eax, 4
    mov ebx, 1
    mov ecx, surname
    mov edx, 8
    int 0x80
    mov ecx, name
    mov edx, 11
    int 0x80
    mov edx, 15
    mov ecx, second_name
    int 0x80
    ;инициализация регистров для успешного завершения работы программы
    mov eax, 1
    mov ebx, 0
    int 0x80