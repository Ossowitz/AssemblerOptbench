i2:
        .zero   4
i4:
        .zero   4
j4:
        .zero   4
i5:
        .zero   4
k5:
        .zero   4
.LC0:
        .string "Hello"
main:
        endbr64
        push    rbp     #
        mov     rbp, rsp  #,
        mov     DWORD PTR j4[rip], 2      # j4,
        mov     edx, DWORD PTR i2[rip]    # i2.0_1, i2
        mov     eax, DWORD PTR j4[rip]    # j4.1_2, j4
        cmp     edx, eax  # i2.0_1, j4.1_2
        jge     .L2       #,
        mov     edx, DWORD PTR i4[rip]    # i4.2_3, i4
        mov     eax, DWORD PTR j4[rip]    # j4.3_4, j4
        cmp     edx, eax  # i4.2_3, j4.3_4
        jge     .L2       #,
        mov     DWORD PTR i2[rip], 2      # i2,
        lea     rax, .LC0[rip]    # tmp93,
        mov     rdi, rax  #, tmp93
        mov     eax, 0    #,
        call    printf@PLT      #
.L2:
        mov     eax, DWORD PTR k5[rip]    # k5.4_5, k5
        mov     DWORD PTR j4[rip], eax    # j4, k5.4_5
        mov     edx, DWORD PTR i2[rip]    # i2.5_6, i2
        mov     eax, DWORD PTR j4[rip]    # j4.6_7, j4
        cmp     edx, eax  # i2.5_6, j4.6_7
        jge     .L3       #,
        mov     edx, DWORD PTR i4[rip]    # i4.7_8, i4
        mov     eax, DWORD PTR j4[rip]    # j4.8_9, j4
        cmp     edx, eax  # i4.7_8, j4.8_9
        jge     .L3       #,
        mov     DWORD PTR i5[rip], 3      # i5,
        lea     rax, .LC0[rip]    # tmp94,
        mov     rdi, rax  #, tmp94
        mov     eax, 0    #,
        call    printf@PLT      #
.L3:
        mov     eax, 0    # _19,
        pop     rbp       #
        ret