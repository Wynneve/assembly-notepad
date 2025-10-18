.code

ReadFileToEdit proc
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
    mov rdx, GENERIC_READ
    mov r8,  FILE_SHARE_READ
    mov r9,  NULL
    mov dword ptr [rsp+20h], OPEN_EXISTING
    mov dword ptr [rsp+28h], FILE_ATTRIBUTE_NORMAL
    mov qword ptr [rsp+30h], NULL

    call CreateFileA
    mov r12, rax

    ; DWORD fileSize = GetFileSize(hCurrentFile, NULL)
    
    mov rcx, r12
    mov rdx, NULL
    call GetFileSize
    mov r13, rax

    ; char *buffer = (char*)HeapAlloc(hHeap, 0, fileSize + 1)
    
    mov rcx, [hHeap]
    mov rdx, 0
    lea r8,  [r13 + 1]
    
    call HeapAlloc
    mov r14, rax

    ; ReadFile(hCurrentFile, buffer, fileSize, NULL, NULL)
    
    mov rcx, r12
    mov rdx, r14
    mov r8,  r13
    mov r9,  NULL
    mov qword ptr [rsp+20h], NULL

    call ReadFile

    ; buffer[fileSize] = '\0'

    mov byte ptr [r14 + r13], 0

    ; CloseHandle(hCurrentFile)

    mov rcx, r12

    call CloseHandle

    ; SetWindowTextA(hEdit, buffer)

    mov rcx, [hEdit]
    mov rdx, r14

    call SetWindowTextA

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
ReadFileToEdit endp