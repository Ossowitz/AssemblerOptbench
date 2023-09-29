# Работа оптимизирующего компилятора GCC

## Отказ от цикла

### Код на языке C

```c
for (i = 0; i < 3; i++) ivector[i] = 1;
```

### Неоптимизированный код

```asm
mov     DWORD PTR i[rip], 0
jmp     .L2
.L3:
mov     eax, DWORD PTR i[rip]
cdqe
lea     rdx, 0[0+rax*4]
lea     rax, ivector[rip]
mov     DWORD PTR [rdx+rax], 1
	
mov     eax, DWORD PTR i[rip]
add     eax, 1 
mov     DWORD PTR i[rip], eax
.L2:
mov     eax, DWORD PTR i[rip]
cmp     eax, 2
jle     .L3
```

### Оптимизированный код

```asm
mov    rax, QWORD PTR .LC0[rip] 
mov    DWORD PTR ivector[rip+8],1 
mov    DWORD PTR i[rip], 3  
mov    QWORD PTR ivector[rip], rax 
.LC0: 
       .long 1 
       .long 1
```

#### Комментарий:

_В неоптимизированном варианте происходит 3 проверки и 3 передачи управления. При оптимизации использование цикла
заменяется на размещение меток. В процессе разметки кода метки помещаются на близкое расстояние от инструкций. В метках
могут размещаться директивы, которые объявляют константные значение. Использование констант позволяет предварительно
загрузить значения._

## Размножение констант и копий

### Код на языке C

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
 jge       .L2 
 mov     edx, DWORD PTR i4[rip] 
 mov     eax, DWORD PTR j4[rip] 
 cmp     edx, eax 
 jge       .L2 
 mov     DWORD PTR i2[rip], 2 
 lea       rax, .LC0[rip] 
 mov     rdi, rax 
 mov     eax, 0 
 call       printf@PLT 
.L2: 
 mov     eax, DWORD PTR k5[rip] 
 mov     DWORD PTR j4[rip], eax 
 mov     eax, DWORD PTR j4[rip] 
 cmp     edx, eax 
 jge       .L3 
 mov     edx, DWORD PTR i4[rip] 
 mov     eax, DWORD PTR j4[rip] 
 cmp     edx, eax 
 jge       .L3 
 mov     DWORD PTR i5[rip], 3 
 lea       rax, .LC0[rip] 
 mov     rdi, rax 
 mov     eax, 0 
 call     printf@PLT 
.L3: 
 mov     eax, 0 
```

### Оптимизированный код

```asm
mov      eax, DWORD PTR k5[rip] 
mov      DWORD PTR j4[rip], eax 
cmp      eax, 6 
jle         .L4 
cmp      eax, DWORD PTR i4[rip] 
jg          .L8 
.L8: 
mov     DWORD PTR i5[rip], 3 
```

#### Комментарий:

_В неоптимизированном варианте идёт последовательное сравнение переменных. В то время как в оптимизированном первый
условный блок игнорируется из-за того, что условие заведомо неверно. Однако для второго блока код генерируется не смотря
на то, что если условие не выполнится. Возможно, это связано с тем, что перед первым условием мы передаём в переменную
j4 конкретное значение, а во втором приравниваем её к другой переменной, из-за чего компилятор вместо того, чтобы найти
значение переменной k5, просто генерирует код для условного блока._

## Лишнее присваивание

### Код на языке C

```c
k3 = 1;
k3 = 1;
```

### Неоптимизированный код

```asm
mov     DWORD PTR k3[rip], 1
mov     DWORD PTR k3[rip], 1
```

### Оптимизированный код

```asm
mov     DWORD PTR k3[rip], 1
```

#### Комментарий

_Второе присваивание игнорируется, так как оно дублируется._

## Простой цикл

### Код на языке C

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
mov	DWORD PTR j5[rip], 0  
mov	DWORD PTR k5[rip], 10000  
.L2: 
mov	eax, DWORD PTR k5[rip]  
sub	eax, 1  
mov	DWORD PTR k5[rip], eax  
mov	eax, DWORD PTR j5[rip]  
add	eax, 1  
mov	DWORD PTR j5[rip], eax  
mov	edx, DWORD PTR k5[rip]  
mov	eax, edx  
add	eax, eax  
lea	ecx, [rax+rdx]  
mov	edx, DWORD PTR j5[rip]  
mov	eax, edx  
sal	eax, 2  
lea	esi, [rdx+rax]  
mov	eax, ecx  
cdq 
idiv 	esi  
mov	DWORD PTR i5[rip], eax  
mov	eax, DWORD PTR k5[rip]  
test	eax, eax  
jg	.L2  
mov	eax, 0 
```

### Оптимизированный код

```asm
mov	eax, 10000  
mov	ecx, 10000  
.L2: 
sub	eax, 1  
mov	edx, ecx  
sub	edx, eax  
test	eax, eax  
jg	.L2 #, 
mov	DWORD PTR k5[rip], eax  
mov	DWORD PTR j5[rip], edx  
lea	eax, [rax+rax*2]  
lea	ecx, [rdx+rdx*4]  
cdq 
idiv	ecx  
mov	DWORD PTR i5[rip], eax  
mov	eax, 0 
```

#### Комментарий:

_В неоптимизированном варианте компилятор операция вычитания и умножения происходит за счёт использования
дополнительного регистра: в регистр копируется значение переменной, изменяется, а затем копируется обратно в переменную.
В оптимизированном варианте компилятор заменил использование инструкции add: в самом начале происходит копирование
значения k5 в регистр ecx. Далее из k5 вычитают 1 и помещают в регистр eax, в регистр edx копируется значение временной
переменной, затем из j5 вычитают eax. Это позволяет копировать значения из одного места в другое, что влечёт
незамедлительность операции._

## Глубокие подвыражения

### Код на языке C

```c
if( i < 10 )
    j5 = i5 + i2;
else
    k5 = i5 + i2;
```

### Неоптимизированный код

```asm
L9: 
mov	eax, DWORD PTR i[rip] 
cmp	eax, 9 
jg	.L11 
mov	edx, DWORD PTR i5[rip] 
mov	eax, DWORD PTR i2[rip] 
add	eax, edx 
mov	DWORD PTR j5[rip], eax 
jmp	.L12 
.L11: 
mov	edx, DWORD PTR i5[rip] 
mov	eax, DWORD PTR i2[rip] 
add	eax, edx 
mov	DWORD PTR k5[rip], eax 
.L12: 
mov	eax, 0 
```

### Оптимизированный код

```asm
mov     DWORD PTR k5[rip], 5
```

#### Комментарий:

_Игнорируется условие, которое не выполняется, а также вместо сложения двух переменных, одна из которых равняется нулю,
происходит приравнивание к ненулевой переменной._

## Удаление общих подвыражений

### Код на языке C

```c
if(( h3 + k3 ) < 0 || ( h3 + k3 ) > 5 )
    printf("Common subexpression elimination\n");
else {
    m3 = ( h3 + k3 ) / i3;
    g3 = i3 + (h3 + k3);
}
```

### Неоптимизированный код

```asm
mov	edx, DWORD PTR h3[rip] 
mov	eax, DWORD PTR k3[rip] 
add	eax, edx 
test	eax, eax 
js	.L13 
mov	edx, DWORD PTR h3[rip] 
mov	eax, DWORD PTR k3[rip] 
add	eax, edx 
cmp	eax, 5 
jle	.L14 
.L13: 
lea	rax, .LC2[rip] 
mov	rdi, rax 
call	puts@PLT 
jmp	.L15 
.L14: 
mov	edx, DWORD PTR h3[rip] 
mov	eax, DWORD PTR k3[rip] 
add	eax, edx 
mov	esi, DWORD PTR i3[rip] 
cdq 
idiv	esi 
mov	DWORD PTR m3[rip], eax 
mov	edx, DWORD PTR h3[rip] 
mov	eax, DWORD PTR k3[rip] 
add	edx, eax 
mov	eax, DWORD PTR i3[rip] 
add	eax, edx 
mov	DWORD PTR g3[rip], eax 
.L15: 
mov	eax, 0 
```

### Оптимизированный код

```asm
LC4:  

.string "Common subexpression elimination"  

.L19:  

lea	rdi, .LC4[rip] 

call	puts@PLT 

jmp .L10 

.L10:  

mov	DWORD PTR i4[rip], 0 

lea	rbp, ivector2[rip] 

mov	ecx, DWORD PTR h3[rip]  
lea	edx, 1[rcx]  
cmp	edx, 5  
ja	.L10  
movsx	rax, edx  
sar	edx, 31  
add	ecx, 4  
imul	rax, rax, 1431655766  
mov	DWORD PTR g3[rip], ecx  
shr	rax, 32  
sub	eax, edx  
mov	DWORD PTR m3[rip], eax 
```

#### Комментарий относительно оптимизированного кода:

_Вместо занесения суммы h3 и k3 в два разных регистра, сумма присваивается только одно одному регистру, и все дальнейшие
сравнения
происходят только с ним._

## Вызов функции с аргументами

### Код на языке C

```c
void dead_code( a, b )
    int a;
    char *b;
{
    int idead_store;
    idead_store = a;
    if( 0 )
    printf( "%s\n", b );
}
			
dead_code( 1, "This line should not be printed" );
```

### Неоптимизированный код

```asm
dead_code: 
endbr64  
push	rbp  
mov	rbp, rsp  
mov	DWORD PTR -20[rbp], edi  
mov	QWORD PTR -32[rbp], rsi  
mov	eax, DWORD PTR -20[rbp]  
mov	DWORD PTR -4[rbp], eax  
nop  
pop	rbp  
ret  
 
lea	rax, .LC3[rip]  
mov	rsi, rax  
mov	edi, 1  
call	dead_code  
mov	eax, 0 
```

### Оптимизированный код

```c
dead_code( 1, "This line should not be printed" );
```

#### Комментарий относительно оптимизированного кода:

_Поскольку условие в функции dead_code не выполняется, она не вызывается, соответственно, код не вызывается.
Проверка непостижимого кода и лишних присваиваний. Не должен генерироваться код._

## loop_jamming

### Код на языке C

```c
void loop_jamming( x )
    int x;
{
    for( i = 0; i < 5; i++ )
    k5 = x + j5 * i;
    for( i = 0; i < 5; i++ )
        i5 = x * k5 * i;
}
loop_jamming(7);
```

### Неоптимизированный код

```asm
loop_jamming: 
endbr64 
push	rbp  
mov	rbp, rsp  
mov	DWORD PTR -4[rbp], edi  
mov	DWORD PTR i[rip], 0  
jmp	.L2  
.L3: 
mov	edx, DWORD PTR j5[rip]  
mov	eax, DWORD PTR i[rip]  
imul	edx, eax  
mov	eax, DWORD PTR -4[rbp]  
add	eax, edx  
mov	DWORD PTR k5[rip], eax  
mov	eax, DWORD PTR i[rip]  
add	eax, 1  
mov	DWORD PTR i[rip], eax  
.L2: 
mov	eax, DWORD PTR i[rip]  
cmp	eax, 4  
jle	.L3  
mov	DWORD PTR i[rip], 0  
jmp	.L4  
.L5: 
mov	eax, DWORD PTR k5[rip]  
imul	eax, DWORD PTR -4[rbp]  
mov	edx, eax  
mov	eax, DWORD PTR i[rip]  
imul	eax, edx  
mov	DWORD PTR i5[rip], eax  
mov	eax, DWORD PTR i[rip]  
add	eax, 1 # _13, 
mov	DWORD PTR i[rip], eax  
.L4: 
mov	eax, DWORD PTR i[rip]  
cmp	eax, 4  
jle	.L5  
nop 
nop 
pop	rbp  
ret 
.L21:	mov edi, 7  
call	loop_jamming  
mov	eax, 0 
```

### Оптимизированный код

```asm
loop_jamming: 
mov	DWORD PTR i[rip], 5  
mov	eax, DWORD PTR j5[rip]  
lea	eax, [rdi+rax*4]  
mov	DWORD PTR k5[rip], eax  
imul	eax, edi  
sal	eax, 2  
mov	DWORD PTR i5[rip], eax  
ret  
mov	edi, 7  
call	loop_jamming 
```

#### Комментарий относительно оптимизированного кода:

_После оптимизации компилятор не слил два цикла воедино, однако в первом цикле произвёл лишь одну операцию присваивания,
а во втором цикле лишь зафиксировал для переменной i значение 0._

## jump_compression

### Код на языке C

```c
jump_compression(1, 2, 3, 4, 5);

int jump_compression(i, j, k, l, m)
        int i, j, k, l, m;
{
    beg_1:
    if (i < j)
        if (j < k)
            if (k < l)
                if (l < m)
                    l += m;
                else
                    goto end_1;
            else
                k += l;
        else {
            j += k;
            end_1:
            goto beg_1;
        }
    else
        i += j;
    return (i + j + k + l + m);
}
```

### Неоптимизированный код

```asm
jump_compression:
        mov     DWORD PTR -4[rbp], edi    # i, i
        mov     DWORD PTR -8[rbp], esi    # j, j
        mov     DWORD PTR -12[rbp], edx   # k, k
        mov     DWORD PTR -16[rbp], ecx   # l, l
        mov     DWORD PTR -20[rbp], r8d   # m, m
.L4:
        mov     eax, DWORD PTR -4[rbp]    # tmp87, i
        cmp     eax, DWORD PTR -8[rbp]    # tmp87, j
        jge     .L5       #,
        mov     eax, DWORD PTR -8[rbp]    # tmp88, j
        cmp     eax, DWORD PTR -12[rbp]   # tmp88, k
        jge     .L6       #,
        mov     eax, DWORD PTR -12[rbp]   # tmp89, k
        cmp     eax, DWORD PTR -16[rbp]   # tmp89, l
        jge     .L7       #,
        mov     eax, DWORD PTR -16[rbp]   # tmp90, l
        cmp     eax, DWORD PTR -20[rbp]   # tmp90, m
        jge     .L12      #,
        mov     eax, DWORD PTR -20[rbp]   # tmp91, m
        add     DWORD PTR -16[rbp], eax   # l, tmp91
        jmp     .L9       #
.L7:
        mov     eax, DWORD PTR -16[rbp]   # tmp92, l
        add     DWORD PTR -12[rbp], eax   # k, tmp92
        jmp     .L9       #
.L6:
        mov     eax, DWORD PTR -12[rbp]   # tmp93, k
        add     DWORD PTR -8[rbp], eax    # j, tmp93
        jmp     .L4       #
.L12:
        nop     
        jmp     .L4       #
.L5:
        mov     eax, DWORD PTR -8[rbp]    # tmp94, j
        add     DWORD PTR -4[rbp], eax    # i, tmp94
.L9:
        mov     edx, DWORD PTR -4[rbp]    # tmp95, i
        mov     eax, DWORD PTR -8[rbp]    # tmp96, j
        add     edx, eax  # _1, tmp96
        mov     eax, DWORD PTR -12[rbp]   # tmp97, k
        add     edx, eax  # _2, tmp97
        mov     eax, DWORD PTR -16[rbp]   # tmp98, l
        add     edx, eax  # _3, tmp98
        mov     eax, DWORD PTR -20[rbp]   # tmp99, m
        add     eax, edx  # _18, _3
```

### Оптимизированный код

```asm
jump_compression: 
cmp	esi, edi 
jle	.L4 
cmp	ecx, r8d 
jl	.L22 
cmp	edx, ecx # k, l 
jge	.L11 #, 
.L10: 
cmp	edx, esi # k, j 
jle	.L23 #, 
cmp	edi, esi # i, j 
jge	.L4 #, 
.L13: 
jmp	.L13 # 
.L23: 
add	esi, edx # j, k 
cmp	edi, esi # i, j 
jl	.L10 #, 
.L4: 
add	edi, esi # i, j 
.L26: 
lea	eax, [rdi+rsi] # tmp92, 
add	eax, edx # tmp93, k 
add	eax, ecx # tmp94, l 
add	eax, r8d # tmp91, m 
ret  
.L24: 
add	esi, edx # j, k 
cmp	edi, esi # i, j 
jge	.L4 #, 
.L11: 
cmp	edx, esi # k, j 
jle	.L24 #, 
.L7: 
add	edx, ecx # k, l 
lea	eax, [rdi+rsi] # tmp92, 
add	eax, edx # tmp93, k 
add	eax, ecx # tmp94, l 
add	eax, r8d # tmp91, m 
ret  
.L22: 
cmp	edx, ecx # k, l 
jge	.L8 #, 
.L6: 
cmp	edx, esi # k, j 
jle	.L14 #, 
lea	eax, [rdi+rsi] # tmp92, 
add	ecx, r8d # l, m 
add	eax, edx # tmp93, k 
add	eax, ecx # tmp94, l 
add	eax, r8d # tmp91, m 
ret  
.L25 

add	esi, edx # j, k 
cmp	edi, esi # i, j 
jge	.L4 #, 
.L8: 
cmp	edx, esi # k, j 
jg	.L7 #, 
jmp	.L25 # 
.L14: 
add	esi, edx # j, k 
cmp	edi, esi # i, j 
jl	.L6 #, 
add	edi, esi # i, j 
jmp	.L26 # 
```

#### Комментарий относительно оптимизированного кода:

_Сжимается цепочка переходов: после сравнения j и i, сразу происходит сравнение l и m.
В зависимости от исхода сравнения происходит переход к следующему. Также не выполняются лишние
присваивания за счёт невыполнения проверок._