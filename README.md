# Работа оптимизирующего компилятора GCC

## Отказ от цикла

### Кода на языке C

```c
for (i = 0; i < 3; i++) ivector[i] = 1;
```

### Неоптимизированный код

```asm
	mov     DWORD PTR i[rip], 0     # Инициализируем переменную i
	jmp     .L2                     # Переходим на проверку условия в .L2
.L3:
	mov     eax, DWORD PTR i[rip]   # Загружаем значение переменной i
	cdqe                            # Расширяем значение в регистре до 64 бит
	lea     rdx, 0[0+rax*4]         # Вычисляем адрес элемента и сохраняем его
	lea     rax, ivector[rip]       # Загружаем адрес массива
	mov     DWORD PTR [rdx+rax], 1  # Устанавливаем значение 1
	
	mov     eax, DWORD PTR i[rip]   # Загружаем значение переменной i
	add     eax, 1                  # Увеличиваем значение переменной на 1
	mov     DWORD PTR i[rip], eax   # Сохраняем новое значение переменной 
.L2:
	mov     eax, DWORD PTR i[rip]   # Загружаем значение переменной i
	cmp     eax, 2                  # Сравниваем значение i с 2 (меньше или равно)
	jle     .L3                     # Если меньше или равно, то переходим в .L3
```

#### Комментарий относительно неоптимизированного кода:

_В неоптимизированном варианте происходит 3 проверки и 3 передачи управления_

### Оптимизированный код

```asm
                                    # Перемещаем значение из памяти в регистр
    mov     rax, QWORD PTR .LC0[rip]    #   Загружаем значение из локации .LC0
    mov     DWORD PTR ivector[rip+8], 1 # Устанавливаем значение 1 по смещению от начала массива
    mov     DWORD PTR i[rip], 3         # Устанавливаем значение 2 переменной i
    mov     QWORD PTR ivector[rip], rax # Перемещаем значение из регистра rax в начало массива
.LC0:
        .long   1
        .long   1
```

#### Комментарий относительно оптимизированного кода:

_Фактическое использование цикла заменяется на размещение меток. В процессе разметки кода метки помещаются на близкое
расстояние от инструкций.
В метках могут размещаться директивы, которые объявляют константные значения. Использование констант позволяет
предварительно
загрузить значения._

## Размножение констант и копий

### Кода на языке C

```c
j4 = 2;
if( i2 < j4 && i4 < j4 ){
    i2 = 2;
    printf("Hello");
}

j4 = k5;
if( i2 < j4 && i4 < j4 ){
    i5 = 3;
    printf("Hello");
}
```

### Неоптимизированный код

```asm
.LC0:
        .string "Hello"
	mov     DWORD PTR j4[rip], 2
	mov     edx, DWORD PTR i2[rip]
	mov     eax, DWORD PTR j4[rip]
	cmp     edx, eax
	jge     .L2
	mov     edx, DWORD PTR i4[rip]
	mov     eax, DWORD PTR j4[rip]
	cmp     edx, eax
	jge     .L2
	mov     DWORD PTR i2[rip], 2
	lea     rax, .LC0[rip]
	mov     rdi, rax
	mov     eax, 0
	call    printf@PLT
.L2:
	mov     eax, DWORD PTR k5[rip]
	mov     DWORD PTR j4[rip], eax
	mov     eax, DWORD PTR j4[rip]
	cmp     edx, eax
	jge     .L3
	mov     edx, DWORD PTR i4[rip]
	mov     eax, DWORD PTR j4[rip]
	cmp     edx, eax
	jge     .L3
	mov     DWORD PTR i5[rip], 3
	lea     rax, .LC0[rip]
	mov     rdi, rax
	mov     eax, 0
	call    printf@PLT
.L3:
    mov     eax, 0
```

#### Комментарий относительно неоптимизированного кода:

_В неоптимизированном варианте идёт последовательное сравнение переменных._

### Оптимизированный код

```asm
        cmp     DWORD PTR i2[rip], 1
        mov     DWORD PTR j4[rip], 2
        jle     .L6
.L2:
		mov     eax, DWORD PTR k5[rip]
		cmp     eax, DWORD PTR i2[rip]
		mov     DWORD PTR j4[rip], eax
		jle     .L3
		cmp     eax, DWORD PTR i4[rip]
		jg      .L7
.L6:
		cmp     DWORD PTR i4[rip], 1 
        jg      .L2
		mov     DWORD PTR i2[rip], 2
.L7:
		mov     DWORD PTR i5[rip], 3
```

#### Комментарий относительно оптимизированного кода:

_Компилятор не убрал присваивание значения переменной j4, однако в условном операторе использовал константу, подставляя её 
в аргумент функции cmp._