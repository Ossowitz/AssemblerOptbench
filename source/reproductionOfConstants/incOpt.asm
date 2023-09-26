.LC0:
        .string "Hello"
main:
        endbr64
        sub     rsp, 8    #,
        cmp     DWORD PTR i2[rip], 1      # i2,
        mov     DWORD PTR j4[rip], 2      # j4,
        jle     .L6       #,
.L2:
        mov     eax, DWORD PTR k5[rip]    # k5.4_3, k5
        cmp     eax, DWORD PTR i2[rip]    # k5.4_3, i2
        mov     DWORD PTR j4[rip], eax    # j4, k5.4_3
        jle     .L3       #,
        cmp     eax, DWORD PTR i4[rip]    # k5.4_3, i4
        jg      .L7 #,
.L3:
        xor     eax, eax  #
        add     rsp, 8    #,
        ret
.L6:
        cmp     DWORD PTR i4[rip], 1      # i4,
        jg      .L2 #,
        lea     rsi, .LC0[rip]    # tmp88,
        mov     edi, 1    #,
        xor     eax, eax  #
        mov     DWORD PTR i2[rip], 2      # i2,
        call    __printf_chk@PLT        #
        jmp     .L2       #
.L7:
        lea     rsi, .LC0[rip]    # tmp89,
        mov     edi, 1    #,
        xor     eax, eax  #
        mov     DWORD PTR i5[rip], 3      # i5,
        call    __printf_chk@PLT        #
        jmp     .L3       #
k5:
        .zero   4
i5:
        .zero   4
j4:
        .zero   4
i4:
        .zero   4
i2:
        .zero   4