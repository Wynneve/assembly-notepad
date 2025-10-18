.code

; rcx (1) = hInstance
; rdx (2) = hPrevInstance
; r8  (3) = lpCmdLine
; r9  (4) = nCmdShow 
WinMain proc
    ; form stack frame
    enter 90h, 0

    ; Get the module handle manually, as Windows won't give it to us
    ; (hInstance) = GetModuleHandleA(NULL)
    mov rcx, 0
    call GetModuleHandleA
    
    ; save arguments (with correct hInstance)
    mov [rsp+70h], rax ; hInstance (from GetModuleHandle, not first argument)
    mov [rsp+78h], rdx ; hPrevInstance
    mov [rsp+80h], r8  ; lpCmdLine
    mov [rsp+88h], r9  ; nCmdShow

    call GetProcessHeap
    mov [hHeap], rax

    ; wc.hInstance = hInstance
    mov rax, [rsp+70h]
    mov [wc.hInstance], rax

    ; wc.lpfnWndProc = WndProc
    mov rax, offset WndProc
    mov [wc.lpfnWndProc], rax

    ; wc.hCursor = LoadCursorA(NULL, IDC_ARROW)
    mov rcx, NULL
    mov rdx, IDC_ARROW
    call LoadCursorA
    mov [wc.hCursor], rax

    ; wc.hIcon = LoadIconA(NULL, IDI_APPLICATION)
    mov rcx, NULL
    mov rdx, IDI_APPLICATION
    call LoadIconA
    mov [wc.hIcon], rax

    ; RegisterClass(&wc);
    mov rcx, offset wc
    call RegisterClassA

    ; hWindow = CreateWindowExA(...)
    mov rcx, 0                         ; 0
    mov rdx, offset CLASS_NAME         ; CLASS_NAME
    mov r8,  offset WINDOW_NAME        ; WINDOW_NAME
    mov r9,  WS_OVERLAPPEDWINDOW       ; WS_OVERLAPPEDWINDOW
    mov dword ptr [rsp+20h], 80000000h ; CW_DEFAULT
    mov dword ptr [rsp+28h], 80000000h ; CW_DEFAULT
    mov dword ptr [rsp+30h], 80000000h ; CW_DEFAULT
    mov dword ptr [rsp+38h], 80000000h ; CW_DEFAULT
    mov qword ptr [rsp+40h], 0         ; NULL
    mov rax, [hMenu]                   ; (hMenu)
    mov qword ptr [rsp+48h], rax       ; hMenu
    mov rax, [rsp+70h]                 ; (hInstance)
    mov qword ptr [rsp+50h], rax       ; hInstance
    mov qword ptr [rsp+58h], 0         ; NULL

    call CreateWindowExA
    mov [hWindow], rax

    ; hMenu = GetMenu(hWindow)
    mov rcx, [hWindow]
    call GetMenu
    mov [hMenu], rax
    ; fileDialog.hwndOwner = hWindow
    ; chooseFont.hwndOwner = hWindow
    mov rax, [hWindow]
    mov [fileDialog.hwndOwner], rax
    mov [chooseFont.hwndOwner], rax

    ; hbrBack = CreateSolidBrush(GetSysColor(COLOR_MENU))
    mov rcx, COLOR_MENU
    call GetSysColor
    mov rcx, rax
    call CreateSolidBrush
    mov [hbrBack], rax

    ; HFONT hFont = CreateFontA(...)
    mov rcx, 24
    mov rdx, 0
    mov r8,  0
    mov r9,  0
    mov dword ptr [rsp+20h], FW_NORMAL
    mov dword ptr [rsp+28h], FALSE
    mov dword ptr [rsp+30h], FALSE
    mov dword ptr [rsp+38h], FALSE
    mov dword ptr [rsp+40h], DEFAULT_CHARSET
    mov dword ptr [rsp+48h], OUT_DEFAULT_PRECIS
    mov dword ptr [rsp+50h], CLIP_DEFAULT_PRECIS
    mov dword ptr [rsp+58h], DEFAULT_QUALITY
    mov dword ptr [rsp+60h], DEFAULT_PITCH or FF_DONTCARE
    mov rax, offset FONT_NAME
    mov qword ptr [rsp+68h], rax

    call CreateFontA
    mov r12, rax

    ; hLines = CreateWindowExA(...)
    mov rcx, 0                                  ; 0
    mov rdx, offset LINES_CLASS_NAME            ; LINES_CLASS_NAME
    mov r8,  NULL                               ; WINDOW_NAME
    mov r9,  WS_CHILD or WS_VISIBLE or ES_RIGHT ; ...
    mov dword ptr [rsp+20h], 0h                 ; 0
    mov dword ptr [rsp+28h], 0h                 ; 0
    mov dword ptr [rsp+30h], 0h                 ; 0
    mov dword ptr [rsp+38h], 0h                 ; 0
    mov rax, [hWindow]                          ; (hWindow)
    mov qword ptr [rsp+40h], rax                ; hWindow
    mov qword ptr [rsp+48h], LINES_ID           ; LINES_ID
    mov rax, [rsp+70h]                          ; (hInstance)
    mov [rsp+50h], rax                          ; hInstance
    mov qword ptr [rsp+58h], 0                  ; NULL

    call CreateWindowExA
    mov [hLines], rax

    ; hEdit = CreateWindowExA(...)
    mov rcx, 0                                  ; 0
    mov rdx, offset EDIT_CLASS_NAME             ; EDIT_CLASS_NAME
    mov r8,  NULL                               ; WINDOW_NAME
    mov r9,  WS_CHILD or WS_VISIBLE or WS_VSCROLL\
             or ES_LEFT or ES_MULTILINE or ES_AUTOVSCROLL ; ...
    mov dword ptr [rsp+20h], 0h                 ; 0
    mov dword ptr [rsp+28h], 0h                 ; 0
    mov dword ptr [rsp+30h], 0h                 ; 0
    mov dword ptr [rsp+38h], 0h                 ; 0
    mov rax, [hWindow]                          ; (hWindow)
    mov qword ptr [rsp+40h], rax                ; hWindow
    mov qword ptr [rsp+48h], EDIT_ID            ; EDIT_ID
    mov rax, [rsp+70h]                          ; (hInstance)
    mov [rsp+50h], rax                          ; hInstance
    mov qword ptr [rsp+58h], 0                  ; NULL

    call CreateWindowExA
    mov [hEdit], rax

    ; baseEditProc = (WNDPROC)SetWindowLongPtrA(hEdit, GWLP_WNDPROC, (LONG_PTR)EditWndProc)
    mov rcx, [hEdit]
    mov rdx, GWLP_WNDPROC
    mov r8, offset EditWndProc
    
    call SetWindowLongPtrA
    mov [baseEditProc], rax

    ; SendMessageA(hLines, WM_SETFONT, (WPARAM)hFont, TRUE)
    mov rcx, [hLines]
    mov rdx, WM_SETFONT
    mov r8, r12
    mov r9, TRUE

    call SendMessageA
    
    ; SendMessageA(hEdit, WM_SETFONT, (WPARAM)hFont, TRUE)
    mov rcx, [hEdit]
    mov rdx, WM_SETFONT
    mov r8, r12
    mov r9, TRUE

    call SendMessageA

    ; ShowWindow(hWindow, 1)
    mov rcx, [hWindow] ; hWnd
    mov rdx, 1         ; nCmdShow

    call ShowWindow

    ; UpdateWindow(hWindow)
    mov rcx, [hWindow]

    call UpdateWindow

    ; UpdateControls()
    call UpdateControls

    ; while(GetMessageA(&msg, NULL, 0, 0))
    winmain__message_loop:
        ; GetMessageA(&msg, NULL, 0, 0)
        mov rcx, offset msg
        mov rdx, NULL
        mov r8,  0
        mov r9,  0
        call GetMessageA

        cmp rax, 0
        je winmain__message_loop_end

        ; TranslateMessage(&msg)
        mov rcx, offset msg
        call TranslateMessage

        ; DispatchMessageA(&msg)
        mov rcx, offset msg
        call DispatchMessageA
        
        jmp winmain__message_loop

    winmain__message_loop_end:

    ; ExitProcess(0)
    mov rcx, 0
    call ExitProcess
    
    ; failsafe (return 0)
    leave
    mov rax, 0
    ret
WinMain endp