.code

; rcx (1) = HWND hwnd,
; rdx (2) = UINT msg,
; r8  (3) = WPARAM wParam,
; r9  (4) = LPARAM lParam
WndProc proc
    ; form stack frame
    enter 60h, 0

    ; save variables
    mov [rsp+20h], rcx ; volatile
    mov [rsp+28h], rdx
    mov [rsp+30h], r8
    mov [rsp+38h], r9
    mov [rsp+40h], r12 ; saved
    mov [rsp+48h], r13
    mov [rsp+50h], r14
    mov [rsp+58h], r15

    ; switch
    cmp rdx, WM_DESTROY
    je wndproc__switch_wm_destroy

    cmp rdx, WM_CREATE
    je wndproc__switch_wm_create

    cmp rdx, WM_SIZE
    je wndproc__switch_wm_size

    cmp rdx, WM_CTLCOLORSTATIC
    je wndproc__switch_wm_ctlcolorstatic

    cmp rdx, WM_COMMAND
    je wndproc__switch_wm_command

    jmp wndproc__switch_end

    ; case WM_DESTROY
    wndproc__switch_wm_destroy:
        ; PostQuitMessage(0)
        mov rcx, 0
        call PostQuitMessage

        ; return 0
        mov rax, 0
        jmp wndproc__return
    ; case WM_CREATE
    wndproc__switch_wm_create:
        ; GetClientRect(hWindow, &clientArea)

        mov rcx, [hWindow]
        mov rdx, offset clientArea
        call GetClientRect

        ; windowWidth = clientArea.right - clientArea.left
        mov r12d, [clientArea.right]
        mov r13d, [clientArea.left]
        sub r12d, r13d
        mov dword ptr [windowWidth], r12d

        ; windowHeight = clientArea.bottom - clientArea.top
        mov r12d, [clientArea.bottom]
        mov r13d, [clientArea.top]
        sub r12d, r13d
        mov dword ptr [windowHeight], r12d

        ; break
        jmp wndproc__switch_end
    ; case WM_SIZE
    wndproc__switch_wm_size:
        ; windowPrevWidth = windowWidth
        mov r12d, [windowWidth]
        mov [windowPrevWidth], r12d

        ; windowPrevHeight = windowHeight
        mov r12d, [windowHeight]
        mov [windowPrevHeight], r12d

        ; windowWidth = LOWORD(lParam)
        mov r12d, r9d
        movzx r12d, r12w
        mov [windowWidth], r12d

        ; windowHeight = HIWORD(lParam)
        mov r12d, r9d
        shr r12d, 16
        mov [windowHeight], r12d

        ; UpdateControls()
        call UpdateControls

        ; break
        jmp wndproc__switch_end
    ; case WM_CTLCOLORSTATIC
    wndproc__switch_wm_ctlcolorstatic:
        ; HDC hdc = (HDC)wParam
        mov r12, r8
        ; HWND hwndCtl = (HWND)lParam
        mov r13, r9

        ; SetTextColor(hdc, RGB(128,128,128))
        mov rcx, r12
        mov rdx, 0
        or  rdx, 128
        shl rdx, 8
        or  rdx, 128
        shl rdx, 8
        or  rdx, 128

        call SetTextColor

        ; SetBkMode(hdx, TRANSPARENT)
        mov rcx, r12
        mov rdx, TRANSPARENT
        call SetBkMode

        ; return hbrBack
        mov rax, [hbrBack]
        jmp wndproc__return
    ; case WM_COMMAND
    wndproc__switch_wm_command:
        ; int code = LOWORD(wParam)
        mov r12, r8
        
        ; switch(code)
        cmp r12w, EDIT_ID
        je wndproc__code_switch_edit

        cmp r12w, IDM_FILE_NEW
        je wndproc__code_switch_file_new

        cmp r12w, IDM_FILE_OPEN
        je wndproc__code_switch_file_open

        cmp r12w, IDM_FILE_SAVE
        je wndproc__code_switch_file_save

        cmp r12w, IDM_FILE_SAVE_AS
        je wndproc__code_switch_file_save_as

        cmp r12w, IDM_FILE_EXIT
        je wndproc__code_switch_file_exit

        cmp r12w, IDM_VIEW_FONT
        je wndproc__code_switch_view_font

        jmp wndproc__code_switch_end

        ; case EDIT_ID
        wndproc__code_switch_edit:
            ; switch(HIWORD(wParam))
            shr r12, 16
            
            cmp r12w, EN_CHANGE
            je wndproc__param_switch_change

            cmp r12w, EN_VSCROLL
            je wndproc__param_switch_vscroll

            jmp wndproc__param_switch_end

            ; case EN_CHANGE
            wndproc__param_switch_change:
                mov [saved], FALSE
                call UpdateWindowName

                mov r12b, byte ptr [currentPath]
                cmp r12b, 0
                
                je wndproc__param_switch_vscroll ; fallthrough

                ; EnableMenuItem(hMenu, IDM_FILE_SAVE, MF_BYCOMMAND | MF_ENABLED)
                mov rcx, [hMenu]
                mov rdx, IDM_FILE_SAVE
                mov r8, MF_BYCOMMAND or MF_ENABLED

                call EnableMenuItem
                ; fallthrough
            ; case EN_VSCROLL
            wndproc__param_switch_vscroll:
                call UpdateControls

            wndproc__param_switch_end:
            
            ; break
            jmp wndproc__code_switch_end
        wndproc__code_switch_file_new:
            ; *currentPath = 0
            mov byte ptr [currentPath], 0
            
            ; SetWindowTextA(hEdit, NULL)
            mov rcx, [hEdit]
            mov rdx, NULL
            
            call SetWindowTextA
            
            ; saved = TRUE
            mov [saved], TRUE

            ; UpdateWindowName()
            call UpdateWindowName

            ; EnableMenuItem(hMenu, IDM_FILE_SAVE, MF_BYCOMMAND | MF_GRAYED)
            mov rcx, [hMenu]
            mov rdx, IDM_FILE_SAVE
            mov r8, MF_BYCOMMAND or MF_GRAYED

            call EnableMenuItem

            ; break
            jmp wndproc__code_switch_end
        wndproc__code_switch_file_open:
            ; fileDialog.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST
            mov [fileDialog.Flags], OFN_PATHMUSTEXIST or OFN_FILEMUSTEXIST
            
            ; int success = GetOpenFileNameA(&fileDialog)
            mov rcx, offset fileDialog
            call GetOpenFileNameA
            mov r12, rax

            ; if(success)
            cmp r12, TRUE
            jne wndproc_code_switch_file_open_cond_else
                ; saved = TRUE
                mov [saved], TRUE
                
                ; ReadFileToEdit()
                call ReadFileToEdit

                ; UpdateControls()
                call UpdateControls

                ; UpdateWindowName()
                call UpdateWindowName
            wndproc_code_switch_file_open_cond_else:
            
            ; break
            jmp wndproc__code_switch_end
        wndproc__code_switch_file_save_as:
            ; fileDialog.Flags = OFN_OVERWRITEPROMPT | OFN_PATHMUSTEXIST
            mov [fileDialog.Flags], OFN_OVERWRITEPROMPT or OFN_PATHMUSTEXIST
            
            ; int success = GetSaveFileNameA(&fileDialog)
            mov rcx, offset fileDialog
            call GetSaveFileNameA
            mov r12, rax

            ; if(!success) break
            cmp r12, FALSE
            je wndproc__code_switch_end
        wndproc__code_switch_file_save:
            ; saved = TRUE
            mov [saved], TRUE

            ; WriteFileFromEdit()
            call WriteFileFromEdit
            
            ; UpdateWindowName()
            call UpdateWindowName

            ; EnableMenuItem(hMenu, IDM_FILE_SAVE, MF_GRAYED)
            mov rcx, [hMenu]
            mov rdx, IDM_FILE_SAVE
            mov r8, MF_BYCOMMAND or MF_GRAYED

            call EnableMenuItem

            ; break
            jmp wndproc__code_switch_end
        wndproc__code_switch_file_exit:
            ; PostMessageA(hWindow, WM_CLOSE, 0, 0)
            mov rcx, [hWindow]
            mov rdx, WM_CLOSE
            mov r8, 0
            mov r9, 0

            call PostMessageA
            
            ; break
            jmp wndproc__code_switch_end
        wndproc__code_switch_view_font:
            ; ChangeFont()
            call ChangeFont

            ; UpdateControls()
            call UpdateControls

            ; break
            jmp wndproc__code_switch_end
        wndproc__code_switch_end:

        ; break
        jmp wndproc__switch_end

    wndproc__switch_end:
    call DefWindowProcA

wndproc__return:
    ; restore variables
    mov rcx, [rsp+20h] ; volatile
    mov rdx, [rsp+28h]
    mov r8,  [rsp+30h]
    mov r9,  [rsp+38h]
    mov r12, [rsp+40h] ; saved
    mov r13, [rsp+48h]
    mov r14, [rsp+50h]
    mov r15, [rsp+58h]

    leave
    ret
WndProc endp