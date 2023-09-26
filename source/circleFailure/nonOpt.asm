ivector:
        .zero   12
i:
        .zero   4
main:
        endbr64
        push    rbp     #
        mov     rbp, rsp  #,
        # Инициализируем переменную i
        mov     DWORD PTR i[rip], 0       # i,
        # Переходим на проверку условия в .L2
        jmp     .L2       #
.L3:
        # Загружаем значение переменной i
        mov     eax, DWORD PTR i[rip]     # i.0_1, i
        # Расширяем значение в регистре до 64 бит
        cdqe
        # Вычисляем адрес элемента и сохраняем его
        lea     rdx, 0[0+rax*4]   # tmp89,
        # Загружаем адрес массива
        lea     rax, ivector[rip] # tmp90,
        # Устанавливаем значение 1
        mov     DWORD PTR [rdx+rax], 1    # ivector[i.0_1],

        # Загружаем значение переменной i
        mov     eax, DWORD PTR i[rip]     # i.1_2, i
        # Увеличваем значение на 1
        add     eax, 1    # _3,
        # Сохраняем новое значение переменной
        mov     DWORD PTR i[rip], eax     # i, _3
.L2:
        # Загружаем значение переменной i
        mov     eax, DWORD PTR i[rip]     # i.2_4, i
        # Сравниваем значение i с 2 (меньше или равно)
        cmp     eax, 2    # i.2_4,
        # Если меньше или равно, то переходим в .L3
        jle     .L3       #,
        mov     eax, 0    # _8,
        pop     rbp       #
        ret