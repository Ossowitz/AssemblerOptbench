main:
        endbr64
        # Перемещаем значение из памяти в регистр
        #   Значение загружается из локации .LC0
        mov     rax, QWORD PTR .LC0[rip]  # tmp84,
        # Установка значения 1 по смещению 8 от начала массива
        mov     DWORD PTR ivector[rip+8], 1       # ivector[2],
        # Установка значения 3 переменной i
        mov     DWORD PTR i[rip], 3       # i,
        # Перемещение значения из регистра rax в начало массива
        mov     QWORD PTR ivector[rip], rax       # MEM <...> [(int *)&ivector], tmp84
        xor     eax, eax  #
        ret
i:
        .zero   4
ivector:
        .zero   12
.LC0:
        .long   1
        .long   1