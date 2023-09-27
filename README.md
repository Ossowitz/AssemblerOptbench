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
предварительно загрузить значения._

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
	mov     eax, DWORD PTR k5[rip]
	mov     DWORD PTR j4[rip], eax
	cmp     eax, 6
	jle     .L4
	cmp     eax, DWORD PTR i4[rip]
	jg      .L8
.L8:
	mov     DWORD PTR i5[rip], 3
```

#### Комментарий относительно оптимизированного кода:

_В оптимизированном варианте программы первый условный блок игнорируется из-за того, что условие заведомо
неверно. Однако для второго блока код генерируется не смотря на то, что если условие не выполнится.
Возможно, это связано с тем, что перед первым условием мы передаём в переменную j4 конкретное значение, 
а во втором приравниваем её к другой переменной, из-за чего компилятор вместо того, чтобы найти значение 
переменной k5, просто генерирует код для условного блока._

## Лишнее присваивание

### Кода на языке C

```c
k3 = 1;
k3 = 1;
```

### Неоптимизированный код

```asm
mov     DWORD PTR k3[rip], 1
mov     DWORD PTR k3[rip], 1
```

#### Комментарий относительно неоптимизированного кода:

_Оба присваивания происходят._

### Оптимизированный код

```asm
mov     DWORD PTR k3[rip], 1
```

_Второе присваивание игнорируется, так как оно дублируется._

## Простой цикл

### Кода на языке C

```c
#define constant5 5

j5 = 0;
k5 = 10000;
do {
    k5 = k5 - 1;
    j5 = j5 + 1;
    i5 = (k5 * 3) / (j5 * constant5);
} while (k5 > 0)
```

### Неоптимизированный код

```asm
mov     DWORD PTR j5[rip], 0
.L2:
	        mov     eax, DWORD PTR k5[rip]
		sub     eax, 1
		mov     DWORD PTR k5[rip], eax
		mov     eax, DWORD PTR j5[rip]
		add     eax, 1
		mov     DWORD PTR j5[rip], eax
		mov     edx, DWORD PTR k5[rip]
		mov     eax, edx
		add     eax, eax
		lea     ecx, [rax+rdx]
		mov     edx, DWORD PTR j5[rip]
		mov     eax, edx
		sal     eax, 2
		lea     esi, [rdx+rax]
		mov     eax, ecx
		cdq
		idiv    esi
		mov     DWORD PTR i5[rip], eax
		mov     eax, DWORD PTR k5[rip]
		test    eax, eax
		jg      .L2
		mov     eax, 0	
```

#### Комментарий относительно неоптимизированного кода:

_Компилятор сохранил цикл, все операции умножения сохранены. Проверка условия выполнения цикла происходит
в самом конце._

### Оптимизированный код

```asm
mov     eax, DWORD PTR k5[rip]
mov     edx, 1
test    eax, eax
cmovg   edx, eax
sub     eax, edx
lea     ecx, [rdx+rdx*4]
mov     DWORD PTR j5[rip], edx
mov     DWORD PTR k5[rip], eax
lea     eax, [rax+rax*2]
cdq
idiv    ecx
mov     DWORD PTR i5[rip], eax
```

#### Комментарий относительно оптимизированного кода:

_Компилятор сначала проводит проверку условия, а лишь затем начинает производить операции
Все остальные операции были сохранены._