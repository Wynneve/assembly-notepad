; Heap
align 8h
hHeap HANDLE NULL

; Class
align 8h
CLASS_NAME byte "NotepadWindowClass", 0
align 8h
wc WNDCLASS {\
    CS_HREDRAW or CS_VREDRAW,\
    NULL,\
    0,\
    0,\
    NULL,\
    NULL,\
    NULL,\
    COLOR_MENU + 1,\
    IDR_MENU,\
    offset CLASS_NAME\
} ; WNDCLASS wc = {...};

; Window
align 8h
WINDOW_NAME byte "Notepad", 0
align 8h
msg MSG {0} ; MSG msg = {0};
align 8h
clientArea RECT {0}
align 8h
hbrBack HBRUSH 0
align 8h
FONT_NAME byte "Segoe UI", 0

; Controls
align 8h
hWindow HWND NULL
align 8h
windowWidth dword 0
align 8h
windowHeight dword 0
align 8h
windowPrevWidth dword 0
align 8h
windowPrevHeight dword 0

align 8h
hLines HWND NULL
align 8h
LINES_CLASS_NAME byte "STATIC", 0
align 8h
digitsCount dword 0
align 8h
digitsWidth dword 0
align 8h
digitsPrevWidth dword 0

align 8h
hEdit HWND NULL
align 8h
EDIT_CLASS_NAME byte "EDIT", 0
align 8h
linesCount dword 0
align 8h
editFirstLine dword 0
align 8h
editLastLine dword 0
align 8h
editLineWidth dword 0
align 8h
editLineHeight dword 0
align 8h
editPrevFirstLine dword 0
align 8h
editPrevLastLine dword 0

align 8h
editScrollInfo SCROLLINFO {sizeof(SCROLLINFO), SIF_TRACKPOS}
align 8h
editClientArea RECT {0}
align 8h
editTextMetric TEXTMETRIC {0}

align 8h
baseEditProc WNDPROC NULL

LINES_ID textequ <1001>
EDIT_ID textequ <1002>

; Menu
align 8h
hMenu HMENU NULL
align 8h
currentPath byte MAX_PATH dup(0)
align 8h
saved dword TRUE
align 8h
prefix1 byte "Notepad", 0
align 8h
prefix2 byte "Notepad*", 0
align 8h
prefix3 byte "Notepad - *", MAX_PATH dup(0), 0

align 8h
fileDialogFilter byte "Text Files (*.txt)", 0, "*.txt", 0, "All Files (*.*)", 0, "*.*", 0, 0
align 8h
fileDialog OPENFILENAME {\
    sizeof(OPENFILENAME),\
    NULL,\ ; hWindow
    NULL,\
    offset fileDialogFilter,\
    NULL,\
    1,\
    0,\
    offset currentPath,\
    MAX_PATH,\
    NULL,\
    0,\
    NULL,\
    NULL,\
}

align 8h
logFont LOGFONT {0}
align 8h
chooseFont CHOOSEFONT {\
    sizeof(CHOOSEFONT),\
    NULL,\
    NULL,\
    offset logFont,\
    CF_SCREENFONTS or CF_EFFECTS\
}