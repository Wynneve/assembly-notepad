.code

WriteFileFromEdit proc
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

    ; HANDLE hCurrentFile = CreateFileA(...)

    mov rcx, offset currentPath
    mov rdx, GENERIC_WRITE
    mov r8,  NULL
    mov r9,  NULL
    mov dword ptr [rsp+20h], CREATE_ALWAYS
    mov dword ptr [rsp+28h], FILE_ATTRIBUTE_NORMAL
    mov qword ptr [rsp+30h], NULL

    call CreateFileA
    mov r12, rax

    ; int length = GetWindowTextLengthA(hEdit)
    
    mov rcx, [hEdit]
    call GetWindowTextLengthA
    mov r13, rax

    ; char *buffer = (char*)HeapAlloc(hHeap, 0, length + 1)
    
    mov rcx, [hHeap]
    mov rdx, 0
    lea r8,  [r13 + 1]
    
    call HeapAlloc
    mov r14, rax

    ; GetWindowTextA(hEdit, buffer, length + 1)
    
    mov rcx,       [hEdit]
    mov rdx,       r14
    lea r8,        [r13 + 1]
    
    call GetWindowTextA

    ; WriteFile(hCurrentFile, buffer, length, NULL, NULL)

    mov rcx, r12
    mov rdx, r14
    mov r8,  r13
    mov r9,  NULL
    mov qword ptr [rsp+20h], NULL

    call WriteFile

    ; CloseHandle(hCurrentFile)

    mov rcx, r12

    call CloseHandle

    ; HeapFree(hHeap, 0, buffer)

    mov rcx, [hHeap]
    mov rdx, 0
    mov r8,  r14

    call HeapFree

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
WriteFileFromEdit endp
