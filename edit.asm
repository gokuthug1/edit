; ==============================================================================
; EditPad Pro Native — x64 Assembly Windows Code Editor
; Built with Microsoft Macro Assembler (ML64) & Win32 API
; ==============================================================================

extrn ExitProcess          : proc
extrn GetModuleHandleA     : proc
extrn RegisterClassExA     : proc
extrn CreateWindowExA      : proc
extrn ShowWindow           : proc
extrn UpdateWindow         : proc
extrn GetMessageA          : proc
extrn TranslateMessage     : proc
extrn DispatchMessageA     : proc
extrn PostQuitMessage      : proc
extrn DefWindowProcA       : proc
extrn LoadCursorA          : proc
extrn SendMessageA         : proc
extrn SetFocus             : proc
extrn GetClientRect        : proc
extrn MoveWindow           : proc
extrn CreateSolidBrush     : proc
extrn DeleteObject         : proc
extrn SetTextColor         : proc
extrn SetBkColor           : proc
extrn CreateFontA          : proc
extrn CreateMenu           : proc
extrn CreatePopupMenu      : proc
extrn AppendMenuA          : proc
extrn SetMenu              : proc
extrn DrawMenuBar          : proc
extrn GetOpenFileNameA     : proc
extrn GetSaveFileNameA     : proc
extrn CreateFileA          : proc
extrn ReadFile             : proc
extrn WriteFile            : proc
extrn CloseHandle          : proc
extrn GetFileSizeEx        : proc
extrn MessageBoxA          : proc
extrn SetWindowTextA       : proc
extrn GetWindowTextA       : proc
extrn GetWindowTextLengthA : proc
extrn wsprintfA            : proc
extrn lstrlenA             : proc
extrn lstrcpyA             : proc
extrn InitCommonControlsEx : proc

; --- Constants ---
WS_OVERLAPPEDWINDOW equ 00CF0000h
WS_VISIBLE          equ 10000000h
WS_CHILD            equ 40000000h
WS_CLIPCHILDREN     equ 02000000h
WS_VSCROLL          equ 00200000h
WS_HSCROLL          equ 00100000h
ES_MULTILINE        equ 0004h
ES_AUTOVSCROLL      equ 0040h
ES_AUTOHSCROLL      equ 0080h
ES_WANTRETURN       equ 1000h
ES_NOHIDESEL        equ 0100h

WM_CREATE           equ 0001h
WM_DESTROY          equ 0002h
WM_SIZE             equ 0005h
WM_SETFOCUS         equ 0007h
WM_SETTEXT          equ 000Ch
WM_GETTEXT          equ 000Dh
WM_GETTEXTLENGTH    equ 000Eh
WM_SETFONT          equ 0030h
WM_COMMAND          equ 0111h
WM_CTLCOLOREDIT     equ 0133h
WM_CTLCOLORSTATIC   equ 0138h

EM_SETSEL           equ 00B1h
EM_GETSEL           equ 00B0h
EM_LINEINDEX        equ 00BBh
EM_LINEFROMCHAR     equ 00C9h
EM_UNDO             equ 00C7h
WM_CUT              equ 0300h
WM_COPY             equ 0301h
WM_PASTE            equ 0302h

EN_CHANGE           equ 0300h
EN_UPDATE           equ 0400h

SB_SETTEXTA         equ 0401h
SB_SETPARTS         equ 0404h

MF_STRING           equ 00000000h
MF_POPUP            equ 00000010h
MF_SEPARATOR        equ 00000800h

IDM_FILE_NEW        equ 1001
IDM_FILE_OPEN       equ 1002
IDM_FILE_SAVE       equ 1003
IDM_FILE_SAVEAS     equ 1004
IDM_FILE_EXIT       equ 1005

IDM_EDIT_UNDO       equ 2001
IDM_EDIT_CUT        equ 2002
IDM_EDIT_COPY       equ 2003
IDM_EDIT_PASTE      equ 2004
IDM_EDIT_SELECTALL  equ 2005

IDM_HELP_ABOUT      equ 3001

GENERIC_READ        equ 80000000h
GENERIC_WRITE       equ 40000000h
FILE_SHARE_READ     equ 00000001h
CREATE_ALWAYS       equ 2
OPEN_EXISTING       equ 3
FILE_ATTRIBUTE_NORMAL equ 80h

OFN_FILEMUSTEXIST   equ 00001000h
OFN_PATHMUSTEXIST   equ 00000800h
OFN_OVERWRITEPROMPT equ 00000002h

IDC_ARROW           equ 32512

.data
szClassName         db "EditPadProNativeClass", 0
szAppTitle          db "EditPad Pro (x64 Assembly Native)", 0
szEditClass         db "EDIT", 0
szStatusClass       db "msctls_statusbar32", 0
szFontName          db "Consolas", 0

; Menu strings
szMenuFile          db "&File", 0
szMenuNew           db "&New`tCtrl+N", 0
szMenuOpen          db "&Open...`tCtrl+O", 0
szMenuSave          db "&Save`tCtrl+S", 0
szMenuSaveAs        db "Save &As...", 0
szMenuExit          db "E&xit", 0

szMenuEdit          db "&Edit", 0
szMenuUndo          db "&Undo`tCtrl+Z", 0
szMenuCut           db "Cu&t`tCtrl+X", 0
szMenuCopy          db "&Copy`tCtrl+C", 0
szMenuPaste         db "&Paste`tCtrl+V", 0
szMenuSelectAll     db "Select &All`tCtrl+A", 0

szMenuHelp          db "&Help", 0
szMenuAbout         db "&About EditPad Pro...", 0

szFilter            db "All Supported Files (*.*)", 0, "*.*", 0
                    db "Assembly Files (*.asm;*.inc)", 0, "*.asm;*.inc", 0
                    db "C/C++ Files (*.c;*.cpp;*.h)", 0, "*.c;*.cpp;*.h", 0
                    db "Web Files (*.html;*.css;*.js)", 0, "*.html;*.css;*.js", 0
                    db "Text Files (*.txt)", 0, "*.txt", 0, 0

szOpenTitle         db "Open File", 0
szSaveTitle         db "Save File As", 0
szDefExt            db "txt", 0

szAboutTitle        db "About EditPad Pro", 0
szAboutText         db "EditPad Pro Native", 13, 10
                    db "Engineered in 100% pure 64-bit x64 MASM Assembly.", 13, 10
                    db "Optimized for speed, low memory footprint, and native Win32 execution.", 13, 10, 13, 10
                    db "Created for pair-programming and developer productivity.", 0

szStatusReady       db "Ready", 0
szStatusSaved       db "File saved successfully", 0
szStatusOpened      db "File opened", 0
szStatusArch        db "x64 MASM Native", 0

fmtCursor           db "Ln %d, Col %d", 0
fmtChars            db "%d chars", 0
fmtTitleFile        db "EditPad Pro - [%s]", 0

; Status bar part boundaries
sbParts             dd 260, 420, 560, -1

.data?
hInstance           dq ?
hMainWnd            dq ?
hEditWnd            dq ?
hStatusWnd          dq ?
hFont               dq ?
hBrushBg            dq ?
hBrushEdit          dq ?

szCurrentFile       db 260 dup(?)
szBufferTemp        db 512 dup(?)
szCursorBuf         db 64 dup(?)
szCharsBuf          db 64 dup(?)

; 4MB buffer for file I/O
szFileBuffer        db 4194304 dup(?)

.code

; ==============================================================================
; Helper: Update Status Bar with Line, Column, and Character Count
; ==============================================================================
UpdateStatusBar proc
    sub rsp, 48h

    ; 1. Get current selection: EM_GETSEL
    mov rcx, hEditWnd
    mov edx, EM_GETSEL
    lea r8, [rsp + 20h] ; start pos
    lea r9, [rsp + 28h] ; end pos
    call SendMessageA

    mov r8d, dword ptr [rsp + 20h] ; char index

    ; 2. Get line number: EM_LINEFROMCHAR
    mov rcx, hEditWnd
    mov edx, EM_LINEFROMCHAR
    ; r8 is already char index
    xor r9, r9
    call SendMessageA
    mov r12d, eax ; line (0-based)
    inc r12d      ; 1-based line

    ; 3. Get line start index: EM_LINEINDEX
    mov rcx, hEditWnd
    mov edx, EM_LINEINDEX
    mov r8d, dword ptr [rsp + 20h]
    mov rcx, hEditWnd
    mov edx, EM_LINEFROMCHAR
    call SendMessageA ; eax = line index
    mov edx, EM_LINEINDEX
    mov r8d, eax
    mov rcx, hEditWnd
    call SendMessageA ; eax = start char index of current line

    mov r13d, dword ptr [rsp + 20h]
    sub r13d, eax ; col offset (0-based)
    inc r13d      ; 1-based column

    ; Format Cursor: "Ln %d, Col %d"
    lea rcx, szCursorBuf
    lea rdx, fmtCursor
    mov r8d, r12d
    mov r9d, r13d
    call wsprintfA

    ; Set Status Part 1
    mov rcx, hStatusWnd
    mov edx, SB_SETTEXTA
    mov r8d, 1
    lea r9, szCursorBuf
    call SendMessageA

    ; 4. Get text length: WM_GETTEXTLENGTH
    mov rcx, hEditWnd
    mov edx, WM_GETTEXTLENGTH
    xor r8, r8
    xor r9, r9
    call SendMessageA
    mov r14d, eax

    ; Format Chars: "%d chars"
    lea rcx, szCharsBuf
    lea rdx, fmtChars
    mov r8d, r14d
    call wsprintfA

    ; Set Status Part 2
    mov rcx, hStatusWnd
    mov edx, SB_SETTEXTA
    mov r8d, 2
    lea r9, szCharsBuf
    call SendMessageA

    add rsp, 48h
    ret
UpdateStatusBar endp

; ==============================================================================
; Helper: Open File via Common Dialog
; ==============================================================================
DoOpenFile proc
    sub rsp, 0B8h ; 152 bytes for OFN + shadow space

    ; Clear OFN struct
    lea rdi, [rsp + 20h]
    mov ecx, 152
    xor al, al
    rep stosb

    ; Setup OPENFILENAMEA
    lea rdi, [rsp + 20h]
    mov dword ptr [rdi], 152 ; lStructSize = 152 (0x98)
    mov rax, hMainWnd
    mov qword ptr [rdi + 8], rax ; hwndOwner
    mov rax, hInstance
    mov qword ptr [rdi + 16], rax ; hInstance
    lea rax, szFilter
    mov qword ptr [rdi + 24], rax ; lpstrFilter
    lea rax, szCurrentFile
    mov qword ptr [rdi + 48], rax ; lpstrFile
    mov dword ptr [rdi + 56], 260 ; nMaxFile
    lea rax, szOpenTitle
    mov qword ptr [rdi + 88], rax ; lpstrTitle
    mov dword ptr [rdi + 96], OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST ; Flags
    lea rax, szDefExt
    mov qword ptr [rdi + 104], rax ; lpstrDefExt

    lea rcx, [rsp + 20h]
    call GetOpenFileNameA
    test eax, eax
    jz OpenDone

    ; Open the selected file
    lea rcx, szCurrentFile
    mov edx, GENERIC_READ
    mov r8d, FILE_SHARE_READ
    xor r9, r9
    mov qword ptr [rsp + 20h], OPEN_EXISTING
    mov qword ptr [rsp + 28h], FILE_ATTRIBUTE_NORMAL
    mov qword ptr [rsp + 30h], 0
    call CreateFileA
    cmp rax, -1
    je OpenDone
    mov rbx, rax ; file handle

    ; Read file content
    mov rcx, rbx
    lea rdx, szFileBuffer
    mov r8d, 4194300 ; max read bytes
    lea r9, [rsp + 20h] ; bytes read
    mov qword ptr [rsp + 28h], 0
    call ReadFile

    ; Null-terminate buffer
    mov eax, dword ptr [rsp + 20h]
    lea rdx, szFileBuffer
    mov byte ptr [rdx + rax], 0

    ; Close file handle
    mov rcx, rbx
    call CloseHandle

    ; Send text to Edit control
    mov rcx, hEditWnd
    mov edx, WM_SETTEXT
    xor r8, r8
    lea r9, szFileBuffer
    call SendMessageA

    ; Update window title
    lea rcx, szBufferTemp
    lea rdx, fmtTitleFile
    lea r8, szCurrentFile
    call wsprintfA

    mov rcx, hMainWnd
    lea rdx, szBufferTemp
    call SetWindowTextA

    ; Update status
    mov rcx, hStatusWnd
    mov edx, SB_SETTEXTA
    xor r8d, r8d
    lea r9, szStatusOpened
    call SendMessageA

    call UpdateStatusBar

OpenDone:
    add rsp, 0B8h
    ret
DoOpenFile endp

; ==============================================================================
; Helper: Save File
; ==============================================================================
DoSaveFile proc bPromptSaveAs:dword
    sub rsp, 0B8h

    ; If current file is empty or prompt requested, ask for filename
    cmp bPromptSaveAs, 1
    je PromptSave
    lea rcx, szCurrentFile
    call lstrlenA
    test eax, eax
    jnz WriteCurrentFile

PromptSave:
    ; Setup OPENFILENAMEA
    lea rdi, [rsp + 20h]
    mov ecx, 152
    xor al, al
    rep stosb

    lea rdi, [rsp + 20h]
    mov dword ptr [rdi], 152 ; lStructSize
    mov rax, hMainWnd
    mov qword ptr [rdi + 8], rax
    mov rax, hInstance
    mov qword ptr [rdi + 16], rax
    lea rax, szFilter
    mov qword ptr [rdi + 24], rax
    lea rax, szCurrentFile
    mov qword ptr [rdi + 48], rax
    mov dword ptr [rdi + 56], 260
    lea rax, szSaveTitle
    mov qword ptr [rdi + 88], rax
    mov dword ptr [rdi + 96], OFN_OVERWRITEPROMPT or OFN_PATHMUSTEXIST
    lea rax, szDefExt
    mov qword ptr [rdi + 104], rax

    lea rcx, [rsp + 20h]
    call GetSaveFileNameA
    test eax, eax
    jz SaveDone

WriteCurrentFile:
    ; Get text from edit control
    mov rcx, hEditWnd
    mov edx, WM_GETTEXTLENGTH
    xor r8, r8
    xor r9, r9
    call SendMessageA
    mov r12d, eax ; length

    mov rcx, hEditWnd
    mov edx, WM_GETTEXT
    lea r8d, [r12d + 1]
    lea r9, szFileBuffer
    call SendMessageA

    ; Create or overwrite file
    lea rcx, szCurrentFile
    mov edx, GENERIC_WRITE
    xor r8d, r8d
    xor r9, r9
    mov qword ptr [rsp + 20h], CREATE_ALWAYS
    mov qword ptr [rsp + 28h], FILE_ATTRIBUTE_NORMAL
    mov qword ptr [rsp + 30h], 0
    call CreateFileA
    cmp rax, -1
    je SaveDone
    mov rbx, rax ; file handle

    ; Write file
    mov rcx, rbx
    lea rdx, szFileBuffer
    mov r8d, r12d
    lea r9, [rsp + 20h] ; bytes written
    mov qword ptr [rsp + 28h], 0
    call WriteFile

    ; Close handle
    mov rcx, rbx
    call CloseHandle

    ; Update window title
    lea rcx, szBufferTemp
    lea rdx, fmtTitleFile
    lea r8, szCurrentFile
    call wsprintfA

    mov rcx, hMainWnd
    lea rdx, szBufferTemp
    call SetWindowTextA

    ; Update status
    mov rcx, hStatusWnd
    mov edx, SB_SETTEXTA
    xor r8d, r8d
    lea r9, szStatusSaved
    call SendMessageA

SaveDone:
    add rsp, 0B8h
    ret
DoSaveFile endp

; ==============================================================================
; Window Procedure
; ==============================================================================
WndProc proc hWnd:dq, uMsg:dword, wParam:dq, lParam:dq
    sub rsp, 68h

    cmp edx, WM_CREATE
    je OnCreate
    cmp edx, WM_SIZE
    je OnSize
    cmp edx, WM_COMMAND
    je OnCommand
    cmp edx, WM_SETFOCUS
    je OnSetFocus
    cmp edx, WM_CTLCOLOREDIT
    je OnCtlColor
    cmp edx, WM_CTLCOLORSTATIC
    je OnCtlColor
    cmp edx, WM_DESTROY
    je OnDestroy

    call DefWindowProcA
    add rsp, 68h
    ret

OnCreate:
    ; 1. Create Monospace Font ("Consolas", height 18)
    mov dword ptr [rsp + 20h], 0 ; dwWeight = FW_DONTCARE
    mov dword ptr [rsp + 28h], 0 ; bItalic = FALSE
    mov dword ptr [rsp + 30h], 0 ; bUnderline = FALSE
    mov dword ptr [rsp + 38h], 0 ; bStrikeOut = FALSE
    mov dword ptr [rsp + 40h], 0 ; ANSI_CHARSET
    mov dword ptr [rsp + 48h], 0 ; OUT_DEFAULT_PRECIS
    mov dword ptr [rsp + 50h], 0 ; CLIP_DEFAULT_PRECIS
    mov dword ptr [rsp + 58h], 0 ; DEFAULT_QUALITY
    mov dword ptr [rsp + 60h], 0 ; FIXED_PITCH
    mov ecx, 18                 ; nHeight
    xor edx, edx                ; nWidth
    xor r8d, r8d                ; nEscapement
    xor r9d, r9d                ; nOrientation
    lea rax, szFontName
    mov qword ptr [rsp + 68h], rax ; lpFaceName
    call CreateFontA
    mov hFont, rax

    ; 2. Create dark background brushes (Zinc theme: #18181b = 0x001B1818)
    mov ecx, 001B1818h
    call CreateSolidBrush
    mov hBrushEdit, rax

    mov ecx, 00141414h
    call CreateSolidBrush
    mov hBrushBg, rax

    ; 3. Create Multi-line EDIT Control
    xor ecx, ecx ; dwExStyle
    lea rdx, szEditClass
    xor r8, r8 ; window name
    mov r9d, WS_CHILD or WS_VISIBLE or WS_VSCROLL or WS_HSCROLL or ES_MULTILINE or ES_AUTOVSCROLL or ES_AUTOHSCROLL or ES_WANTRETURN or ES_NOHIDESEL
    mov dword ptr [rsp + 20h], 0 ; X
    mov dword ptr [rsp + 28h], 0 ; Y
    mov dword ptr [rsp + 30h], 100 ; width
    mov dword ptr [rsp + 38h], 100 ; height
    mov rax, hWnd
    mov qword ptr [rsp + 40h], rax ; parent
    mov qword ptr [rsp + 48h], 100 ; hMenu (child ID)
    mov rax, hInstance
    mov qword ptr [rsp + 50h], rax
    mov qword ptr [rsp + 58h], 0
    call CreateWindowExA
    mov hEditWnd, rax

    ; Set Edit Font
    mov rcx, hEditWnd
    mov edx, WM_SETFONT
    mov r8, hFont
    mov r9d, 1
    call SendMessageA

    ; 4. Create Status Bar
    xor ecx, ecx
    lea rdx, szStatusClass
    xor r8, r8
    mov r9d, WS_CHILD or WS_VISIBLE
    mov dword ptr [rsp + 20h], 0
    mov dword ptr [rsp + 28h], 0
    mov dword ptr [rsp + 30h], 0
    mov dword ptr [rsp + 38h], 0
    mov rax, hWnd
    mov qword ptr [rsp + 40h], rax
    mov qword ptr [rsp + 48h], 101 ; status ID
    mov rax, hInstance
    mov qword ptr [rsp + 50h], rax
    mov qword ptr [rsp + 58h], 0
    call CreateWindowExA
    mov hStatusWnd, rax

    ; Configure Status Bar Parts
    mov rcx, hStatusWnd
    mov edx, SB_SETPARTS
    mov r8d, 4
    lea r9, sbParts
    call SendMessageA

    ; Set Initial Status Texts
    mov rcx, hStatusWnd
    mov edx, SB_SETTEXTA
    xor r8d, r8d
    lea r9, szStatusReady
    call SendMessageA

    mov rcx, hStatusWnd
    mov edx, SB_SETTEXTA
    mov r8d, 3
    lea r9, szStatusArch
    call SendMessageA

    call UpdateStatusBar
    xor eax, eax
    add rsp, 68h
    ret

OnSize:
    ; Resize Edit Control and Status Bar
    ; lParam contains loword(width) and hiword(height)
    mov r12, r9 ; lParam
    movzx r13d, r12w ; width
    shr r12, 16
    movzx r14d, r12w ; height

    ; Resize Status Bar
    mov rcx, hStatusWnd
    mov edx, WM_SIZE
    xor r8, r8
    xor r9, r9
    call SendMessageA

    ; Get client rect of status bar to know its height
    lea rdx, [rsp + 20h] ; RECT struct
    mov rcx, hStatusWnd
    call GetClientRect
    mov eax, dword ptr [rsp + 2Ch] ; status rect.bottom
    sub r14d, eax ; editHeight = clientHeight - statusHeight

    ; Move and resize Edit control
    mov rcx, hEditWnd
    xor edx, edx ; X=0
    xor r8d, r8d ; Y=0
    mov r9d, r13d ; width
    mov dword ptr [rsp + 20h], r14d ; height
    mov dword ptr [rsp + 28h], 1 ; repaint
    call MoveWindow

    xor eax, eax
    add rsp, 68h
    ret

OnCommand:
    ; wParam: loword = ID, hiword = notification code
    mov r12, r8 ; wParam
    movzx r13d, r12w ; command ID
    shr r12, 16 ; notification code

    ; Check if Edit control changed/updated
    cmp r13d, 100 ; child ID of Edit control
    jne CheckMenu
    cmp r12w, EN_UPDATE
    je HandleEditUpdate
    cmp r12w, EN_CHANGE
    je HandleEditUpdate
    jmp CmdDone

HandleEditUpdate:
    call UpdateStatusBar
    jmp CmdDone

CheckMenu:
    cmp r13d, IDM_FILE_NEW
    je MenuFileNew
    cmp r13d, IDM_FILE_OPEN
    je MenuFileOpen
    cmp r13d, IDM_FILE_SAVE
    je MenuFileSave
    cmp r13d, IDM_FILE_SAVEAS
    je MenuFileSaveAs
    cmp r13d, IDM_FILE_EXIT
    je MenuFileExit
    cmp r13d, IDM_EDIT_UNDO
    je MenuEditUndo
    cmp r13d, IDM_EDIT_CUT
    je MenuEditCut
    cmp r13d, IDM_EDIT_COPY
    je MenuEditCopy
    cmp r13d, IDM_EDIT_PASTE
    je MenuEditPaste
    cmp r13d, IDM_EDIT_SELECTALL
    je MenuEditSelectAll
    cmp r13d, IDM_HELP_ABOUT
    je MenuHelpAbout
    jmp CmdDone

MenuFileNew:
    mov rcx, hEditWnd
    mov edx, WM_SETTEXT
    xor r8, r8
    lea r9, [szStatusReady + 5] ; points to null terminator
    call SendMessageA
    mov byte ptr [szCurrentFile], 0
    mov rcx, hMainWnd
    lea rdx, szAppTitle
    call SetWindowTextA
    call UpdateStatusBar
    jmp CmdDone

MenuFileOpen:
    call DoOpenFile
    jmp CmdDone

MenuFileSave:
    xor ecx, ecx
    call DoSaveFile
    jmp CmdDone

MenuFileSaveAs:
    mov ecx, 1
    call DoSaveFile
    jmp CmdDone

MenuFileExit:
    mov rcx, hWnd
    mov edx, WM_DESTROY
    xor r8, r8
    xor r9, r9
    call SendMessageA
    jmp CmdDone

MenuEditUndo:
    mov rcx, hEditWnd
    mov edx, EM_UNDO
    xor r8, r8
    xor r9, r9
    call SendMessageA
    jmp CmdDone

MenuEditCut:
    mov rcx, hEditWnd
    mov edx, WM_CUT
    xor r8, r8
    xor r9, r9
    call SendMessageA
    jmp CmdDone

MenuEditCopy:
    mov rcx, hEditWnd
    mov edx, WM_COPY
    xor r8, r8
    xor r9, r9
    call SendMessageA
    jmp CmdDone

MenuEditPaste:
    mov rcx, hEditWnd
    mov edx, WM_PASTE
    xor r8, r8
    xor r9, r9
    call SendMessageA
    jmp CmdDone

MenuEditSelectAll:
    mov rcx, hEditWnd
    mov edx, EM_SETSEL
    xor r8, r8
    mov r9, -1
    call SendMessageA
    jmp CmdDone

MenuHelpAbout:
    mov rcx, hWnd
    lea rdx, szAboutText
    lea r8, szAboutTitle
    mov r9d, 40h ; MB_OK | MB_ICONINFORMATION
    call MessageBoxA
    jmp CmdDone

CmdDone:
    xor eax, eax
    add rsp, 68h
    ret

OnSetFocus:
    mov rcx, hEditWnd
    call SetFocus
    xor eax, eax
    add rsp, 68h
    ret

OnCtlColor:
    ; Dark theme for Edit Control
    ; wParam = HDC
    mov rcx, r8 ; hdc
    mov edx, 00E7E4E4h ; text color: light zinc (#e4e4e7 in BGR: 0x00E7E4E4)
    call SetTextColor

    mov rcx, r8 ; hdc
    mov edx, 001B1818h ; bk color: dark zinc (#18181b in BGR: 0x001B1818)
    call SetBkColor

    mov rax, hBrushEdit ; return background brush
    add rsp, 68h
    ret

OnDestroy:
    mov rcx, hBrushEdit
    call DeleteObject
    mov rcx, hBrushBg
    call DeleteObject
    mov rcx, hFont
    call DeleteObject

    xor ecx, ecx
    call PostQuitMessage
    xor eax, eax
    add rsp, 68h
    ret

WndProc endp

; ==============================================================================
; Helper: Build Menu Bar
; ==============================================================================
BuildMenuBar proc
    sub rsp, 48h

    call CreateMenu
    mov rbx, rax ; hMainMenu

    ; 1. File Popup
    call CreatePopupMenu
    mov r12, rax ; hFileMenu

    mov rcx, r12
    xor edx, edx
    mov r8d, IDM_FILE_NEW
    lea r9, szMenuNew
    call AppendMenuA

    mov rcx, r12
    xor edx, edx
    mov r8d, IDM_FILE_OPEN
    lea r9, szMenuOpen
    call AppendMenuA

    mov rcx, r12
    xor edx, edx
    mov r8d, IDM_FILE_SAVE
    lea r9, szMenuSave
    call AppendMenuA

    mov rcx, r12
    xor edx, edx
    mov r8d, IDM_FILE_SAVEAS
    lea r9, szMenuSaveAs
    call AppendMenuA

    mov rcx, r12
    mov edx, MF_SEPARATOR
    xor r8, r8
    xor r9, r9
    call AppendMenuA

    mov rcx, r12
    xor edx, edx
    mov r8d, IDM_FILE_EXIT
    lea r9, szMenuExit
    call AppendMenuA

    mov rcx, rbx
    mov edx, MF_POPUP
    mov r8, r12
    lea r9, szMenuFile
    call AppendMenuA

    ; 2. Edit Popup
    call CreatePopupMenu
    mov r13, rax ; hEditMenu

    mov rcx, r13
    xor edx, edx
    mov r8d, IDM_EDIT_UNDO
    lea r9, szMenuUndo
    call AppendMenuA

    mov rcx, r13
    mov edx, MF_SEPARATOR
    xor r8, r8
    xor r9, r9
    call AppendMenuA

    mov rcx, r13
    xor edx, edx
    mov r8d, IDM_EDIT_CUT
    lea r9, szMenuCut
    call AppendMenuA

    mov rcx, r13
    xor edx, edx
    mov r8d, IDM_EDIT_COPY
    lea r9, szMenuCopy
    call AppendMenuA

    mov rcx, r13
    xor edx, edx
    mov r8d, IDM_EDIT_PASTE
    lea r9, szMenuPaste
    call AppendMenuA

    mov rcx, r13
    mov edx, MF_SEPARATOR
    xor r8, r8
    xor r9, r9
    call AppendMenuA

    mov rcx, r13
    xor edx, edx
    mov r8d, IDM_EDIT_SELECTALL
    lea r9, szMenuSelectAll
    call AppendMenuA

    mov rcx, rbx
    mov edx, MF_POPUP
    mov r8, r13
    lea r9, szMenuEdit
    call AppendMenuA

    ; 3. Help Popup
    call CreatePopupMenu
    mov r14, rax ; hHelpMenu

    mov rcx, r14
    xor edx, edx
    mov r8d, IDM_HELP_ABOUT
    lea r9, szMenuAbout
    call AppendMenuA

    mov rcx, rbx
    mov edx, MF_POPUP
    mov r8, r14
    lea r9, szMenuHelp
    call AppendMenuA

    mov rax, rbx
    add rsp, 48h
    ret
BuildMenuBar endp

; ==============================================================================
; Main Entry Point
; ==============================================================================
main proc
    sub rsp, 98h

    ; Initialize Common Controls (Status Bar)
    lea rdi, [rsp + 20h]
    mov dword ptr [rdi], 8 ; dwSize
    mov dword ptr [rdi + 4], 00000004h ; ICC_BAR_CLASSES
    lea rcx, [rsp + 20h]
    call InitCommonControlsEx

    ; Get HINSTANCE
    xor ecx, ecx
    call GetModuleHandleA
    mov hInstance, rax

    ; Register WNDCLASSEXA (80 bytes)
    lea rdi, [rsp + 20h]
    mov dword ptr [rdi], 80 ; cbSize
    mov dword ptr [rdi + 4], 3 ; CS_HREDRAW | CS_VREDRAW
    lea rax, WndProc
    mov qword ptr [rdi + 8], rax
    mov dword ptr [rdi + 16], 0 ; cbClsExtra
    mov dword ptr [rdi + 20], 0 ; cbWndExtra
    mov rax, hInstance
    mov qword ptr [rdi + 24], rax
    mov qword ptr [rdi + 32], 0 ; hIcon
    xor ecx, ecx
    mov edx, IDC_ARROW
    call LoadCursorA
    mov qword ptr [rdi + 40], rax ; hCursor
    mov qword ptr [rdi + 48], 0 ; hbrBackground (handled in WM_CTLCOLOR)
    mov qword ptr [rdi + 56], 0 ; lpszMenuName
    lea rax, szClassName
    mov qword ptr [rdi + 64], rax
    mov qword ptr [rdi + 72], 0 ; hIconSm

    lea rcx, [rsp + 20h]
    call RegisterClassExA

    ; Build Menu Bar
    call BuildMenuBar
    mov r15, rax ; hMenu

    ; Create Main Window
    xor ecx, ecx ; dwExStyle
    lea rdx, szClassName
    lea r8, szAppTitle
    mov r9d, WS_OVERLAPPEDWINDOW or WS_VISIBLE or WS_CLIPCHILDREN
    mov dword ptr [rsp + 20h], 80000000h ; CW_USEDEFAULT
    mov dword ptr [rsp + 28h], 80000000h ; CW_USEDEFAULT
    mov dword ptr [rsp + 30h], 960 ; nWidth
    mov dword ptr [rsp + 38h], 640 ; nHeight
    mov qword ptr [rsp + 40h], 0 ; hWndParent
    mov qword ptr [rsp + 48h], r15 ; hMenu
    mov rax, hInstance
    mov qword ptr [rsp + 50h], rax
    mov qword ptr [rsp + 58h], 0
    call CreateWindowExA
    mov hMainWnd, rax

    ; Show & Update Window
    mov rcx, hMainWnd
    mov edx, 5 ; SW_SHOW
    call ShowWindow

    mov rcx, hMainWnd
    call UpdateWindow

    ; Set initial focus to Edit control
    mov rcx, hEditWnd
    call SetFocus

    ; Message Loop
MsgLoop:
    lea rcx, [rsp + 20h]
    xor edx, edx
    xor r8d, r8d
    xor r9d, r9d
    call GetMessageA
    test eax, eax
    jle ExitLoop

    lea rcx, [rsp + 20h]
    call TranslateMessage
    lea rcx, [rsp + 20h]
    call DispatchMessageA
    jmp MsgLoop

ExitLoop:
    xor ecx, ecx
    call ExitProcess
main endp
end
