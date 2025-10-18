.code

FillLines proc
    enter 80h, 0

    ; save variables
    mov [rsp+40h], rcx
    mov [rsp+48h], rdx
    mov [rsp+50h], r8
    mov [rsp+58h], r9
    mov [rsp+60h], r12
    mov [rsp+68h], r13
    mov [rsp+70h], r14
    mov [rsp+78h], r15

    ; if(editPrevFirstLine == editFirstLine && editPrevLastLine == editLastLine) return;
    mov r12d, [editPrevFirstLine]
    mov r13d, [editFirstLine]
    cmp r12d, r13d

    jne filllines__cond_continue

    mov r12d, [editPrevLastLine]
    mov r13d, [editLastLine]
    cmp r12d, r13d

    jne filllines__cond_continue

    jmp filllines__cond_return

filllines__cond_continue:
    ; char *buffer = (char*)HeapAlloc(hHeap, 0, linesCount * (digitsCount + 2) + 1)
    mov rcx, [hHeap]
    mov rdx, 0
    mov r8d, [digitsCount]
    add r8d, 2
    mov r9d, [linesCount]
    imul r8d, r9d
    add r8d, 1
    
    call HeapAlloc

    mov r12, rax

    ; char *window = buffer
    mov r13, r12

    ; int line = editFirstLine
    mov r14d, [editFirstLine]
    mov r15d, [editLastLine]
    ; do
    filllines__loop:
        ; window = NumberToString(window, line)
        mov rcx, r13
        mov rdx, r14

        call NumberToString

        mov r13, rax

        ; *(window++) = '\r'
        mov byte ptr [r13], 0Dh
        inc r13
        ; *(window++) = '\n'
        mov byte ptr [r13], 0Ah
        inc r13

        ; line++
        inc r14

        ; line <= editLastLine
        cmp r14d, r15d
        jle filllines__loop

    ; *window = '\0'
    mov byte ptr [r13], 0

    ; SetWindowTextA(hLines, buffer)
    mov rcx, hLines
    mov rdx, r12

    call SetWindowTextA

filllines__cond_return:
    ; restore variables
    mov rcx, [rsp+40h]
    mov rdx, [rsp+48h]
    mov r8,  [rsp+50h]
    mov r9,  [rsp+58h]
    mov r12, [rsp+60h]
    mov r13, [rsp+68h]
    mov r14, [rsp+70h]
    mov r15, [rsp+78h]

    leave
    ret
FillLines endp