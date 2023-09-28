jump_compression:
        endbr64
        push    rbp     #
        mov     rbp, rsp  #,
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
        pop     rbp       #
        ret