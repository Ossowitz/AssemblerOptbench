j5:
        .zero   4
k5:
        .zero   4
i5:
        .zero   4
main:
        endbr64
        push    rbp     #
        mov     rbp, rsp  #,
        mov     DWORD PTR j5[rip], 0      # j5,
.L2:
        mov     eax, DWORD PTR k5[rip]    # k5.0_1, k5
        sub     eax, 1    # _2,
        mov     DWORD PTR k5[rip], eax    # k5, _2
        mov     eax, DWORD PTR j5[rip]    # j5.1_3, j5
        add     eax, 1    # _4,
        mov     DWORD PTR j5[rip], eax    # j5, _4
        mov     edx, DWORD PTR k5[rip]    # k5.2_5, k5
        mov     eax, edx  # tmp94, k5.2_5
        add     eax, eax  # tmp94
        lea     ecx, [rax+rdx]    # _6,
        mov     edx, DWORD PTR j5[rip]    # j5.3_7, j5
        mov     eax, edx  # tmp95, j5.3_7
        sal     eax, 2    # tmp95,
        lea     esi, [rdx+rax]    # _8,
        mov     eax, ecx  # _6, _6
        cdq
        idiv    esi     # _8
        mov     DWORD PTR i5[rip], eax    # i5, _9
        mov     eax, DWORD PTR k5[rip]    # k5.4_10, k5
        test    eax, eax        # k5.4_10
        jg      .L2 #,
        mov     eax, 0    # _17,
        pop     rbp       #
        ret