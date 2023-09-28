jump_compression:
        endbr64
.L8:
        cmp     esi, edi  # j, i
        jle     .L5       #,
        cmp     edx, esi  # k, j
        jle     .L6       #,
        cmp     edx, ecx  # k, l
        jge     .L7       #,
        cmp     ecx, r8d  # l, m
        jge     .L8       #,
        add     ecx, r8d  # l, m
.L9:
        lea     eax, [rdi+rsi]    # tmp92,
        add     eax, edx  # tmp93, k
        add     eax, ecx  # tmp94, l
        add     eax, r8d  # tmp91, m
        ret
.L6:
        add     esi, edx  # j, k
        jmp     .L8       #
.L5:
        add     edi, esi  # i, j
        jmp     .L9       #
.L7:
        add     edx, ecx  # k, l
        jmp     .L9       #