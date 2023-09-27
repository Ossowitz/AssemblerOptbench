loop_jamming:
        endbr64
        push    rbp     #
        mov     rbp, rsp  #,
        mov     DWORD PTR -4[rbp], edi    # x, x
        mov     DWORD PTR i[rip], 0       # i,
        jmp     .L2       #
.L3:
        mov     edx, DWORD PTR j5[rip]    # j5.0_1, j5
        mov     eax, DWORD PTR i[rip]     # i.1_2, i
        imul    edx, eax        # _3, i.1_2
        mov     eax, DWORD PTR -4[rbp]    # tmp96, x
        add     eax, edx  # _4, _3
        mov     DWORD PTR k5[rip], eax    # k5, _4
        mov     eax, DWORD PTR i[rip]     # i.2_5, i
        add     eax, 1    # _6,
        mov     DWORD PTR i[rip], eax     # i, _6
.L2:
        mov     eax, DWORD PTR i[rip]     # i.3_7, i
        cmp     eax, 4    # i.3_7,
        jle     .L3       #,
        mov     DWORD PTR i[rip], 0       # i,
        jmp     .L4       #
.L5:
        mov     eax, DWORD PTR k5[rip]    # k5.4_8, k5
        imul    eax, DWORD PTR -4[rbp]  # k5.4_8, x
        mov     edx, eax  # _9, k5.4_8
        mov     eax, DWORD PTR i[rip]     # i.5_10, i
        imul    eax, edx        # _11, _9
        mov     DWORD PTR i5[rip], eax    # i5, _11
        mov     eax, DWORD PTR i[rip]     # i.6_12, i
        add     eax, 1    # _13,
        mov     DWORD PTR i[rip], eax     # i, _13
.L4:
        mov     eax, DWORD PTR i[rip]     # i.7_14, i
        cmp     eax, 4    # i.7_14,
        jle     .L5       #,
        nop
        nop
        pop     rbp       #
        ret
.L21:   mov     edi, 7    #,
        call    loop_jamming    #
        mov     eax, 0    # _128,