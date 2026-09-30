; ==============================================================================
; EditPad Pro Native — x64 Assembly Windows Code Editor
; Built with Microsoft Macro Assembler (ML64) & Win32 API
; Strictly 16-byte stack aligned across all procedures and calls
; Callee-saved registers strictly preserved across all callbacks
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
extrn GetOpenFileNameA     : proc
extrn GetSaveFileNameA     : proc
extrn CreateFileA          : proc
extrn ReadFile             : proc
extrn WriteFile            : proc
extrn CloseHandle          : proc
extrn MessageBoxA          : proc
extrn SetWindowTextA       : proc
extrn GetWindowTextA       : proc
extrn GetWindowTextLengthA : proc
extrn wsprintfA            : proc
extrn lstrlenA             : proc
extrn InitCommonControlsEx : proc

; --- Win32 Constants ---
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
align 16
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

szAboutTitle        db "About EditPad Pro Native", 0
szAboutText         db "EditPad Pro Native — 64-bit Assembly Code Editor", 13, 10
                    db "100% pure x64 MASM assembly compiled locally on Windows.", 13, 10
                    db "Features dark-theme editing, status telemetry, and full file I/O.", 13, 10, 13, 10
                    db "Developed under Professional Software Engineering Standards.", 0

szStatusReady       db "Ready", 0
szStatusSaved       db "File saved successfully", 0
szStatusOpened      db "File opened", 0
szStatusArch        db "x64 MASM Native", 0

fmtCursor           db "Ln %d, Col %d", 0
fmtChars            db "%d chars", 0
fmtTitleFile        db "EditPad Pro - [%s]", 0

; Status bar part boundaries
sbParts             dd 240, 390, 530, -1

.data?
align 16
hInstance           dq ?
hMainWnd            dq ?
hEditWnd            dq ?
hStatusWnd          dq ?
hFont               dq ?
hBrushEdit          dq ?
hMainMenu           dq ?

dwBytesRead         dd ?
dwBytesWritten      dd ?
dwSelStart          dd ?
dwSelEnd            dd ?

align 16
szCurrentFile       db 260 dup(?)
szBufferTemp        db 512 dup(?)
szCursorBuf         db 64 dup(?)
szCharsBuf          db 64 dup(?)

; Static memory structures to prevent shadow space clobbering
align 16
wndClass            db 80 dup(?)
msg                 db 48 dup(?)
iccex               db 8 dup(?)
rcClient            db 16 dup(?)
rcStatus            db 16 dup(?)
ofn                 db 152 dup(?)

align 16
szFileBuffer        db 4194304 dup(?)

.code

; ==============================================================================
; Helper: Update Status Bar telemetry (Line, Column, Characters)
; N = 4 pushes (32 bytes) -> sub rsp, 28h (40 bytes) -> (8 - 72) = -64 = 0 mod 16
; ==============================================================================
UpdateStatusBar proc
    push rbx
    push r12
    push r13
    push r14
    sub rsp, 28h

    cmp qword ptr [hEditWnd], 0
    je UpdateDone
    cmp qword ptr [hStatusWnd], 0
    je UpdateDone

    ; 1. Selection position: EM_GETSEL
    mov rcx, hEditWnd
    mov edx, EM_GETSEL
    lea r8, dwSelStart
    lea r9, dwSelEnd
    call SendMessageA

    ; 2. Line number from char index: EM_LINEFROMCHAR
    mov rcx, hEditWnd
    mov edx, EM_LINEFROMCHAR
    mov r8d, dword ptr [dwSelStart]
    xor r9, r9
    call SendMessageA
    mov r12d, eax
    inc r12d ; 1-based line

    ; 3. Line start char index: EM_LINEINDEX
    mov rcx, hEditWnd
    mov edx, EM_LINEINDEX
    mov r8d, -1
    xor r9, r9
    call SendMessageA
    mov r13d, dword ptr [dwSelStart]
    sub r13d, eax
    inc r13d ; 1-based column

    ; Format: "Ln %d, Col %d"
    lea rcx, szCursorBuf
    lea rdx, fmtCursor
    mov r8d, r12d
    mov r9d, r13d
    call wsprintfA

    mov rcx, hStatusWnd
    mov edx, SB_SETTEXTA
    mov r8d, 1
    lea r9, szCursorBuf
    call SendMessageA

    ; 4. Total characters: WM_GETTEXTLENGTH
    mov rcx, hEditWnd
    mov edx, WM_GETTEXTLENGTH
    xor r8, r8
    xor r9, r9
    call SendMessageA

    ; Format: "%d chars"
    lea rcx, szCharsBuf
    lea rdx, fmtChars
    mov r8d, eax
    call wsprintfA

    mov rcx, hStatusWnd
    mov edx, SB_SETTEXTA
    mov r8d, 2
    lea r9, szCharsBuf
    call SendMessageA

UpdateDone:
    add rsp, 28h
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
UpdateStatusBar endp

; ==============================================================================
; Helper: Open File via Win32 Common Dialog
; N = 3 pushes (24 bytes) -> (8 - 24) = -16 = 0 mod 16
; sub rsp, 50h (80 bytes = 5 * 16) -> (0 - 80) = -80 = 0 mod 16
; ==============================================================================
DoOpenFile proc
    push rbx
    push rsi
    push rdi
    sub rsp, 50h

    ; Zero out ofn struct
    lea rdi, ofn
    mov ecx, 152
    xor al, al
    rep stosb

    ; Setup OPENFILENAMEA
    lea rdi, ofn
    mov dword ptr [rdi], 152
    mov rax, hMainWnd
    mov qword ptr [rdi + 8], rax
    mov rax, hInstance
    mov qword ptr [rdi + 16], rax
    lea rax, szFilter
    mov qword ptr [rdi + 24], rax
    lea rax, szCurrentFile
    mov qword ptr [rdi + 48], rax
    mov dword ptr [rdi + 56], 260
    lea rax, szOpenTitle
    mov qword ptr [rdi + 88], rax
    mov dword ptr [rdi + 96], OFN_FILEMUSTEXIST or OFN_PATHMUSTEXIST
    lea rax, szDefExt
    mov qword ptr [rdi + 104], rax

    lea rcx, ofn
    call GetOpenFileNameA
    test eax, eax
    jz OpenDone

    ; Open File
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
    mov rbx, rax

    ; Read content
    mov rcx, rbx
    lea rdx, szFileBuffer
    mov r8d, 4194300
    lea r9, dwBytesRead
    mov qword ptr [rsp + 20h], 0
    call ReadFile

    ; Null-terminate
    mov eax, dword ptr [dwBytesRead]
    lea rdx, szFileBuffer
    mov byte ptr [rdx + rax], 0

    ; Close handle
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
    cmp qword ptr [hStatusWnd], 0
    je SkipStatusOpened
    mov rcx, hStatusWnd
    mov edx, SB_SETTEXTA
    xor r8d, r8d
    lea r9, szStatusOpened
    call SendMessageA

SkipStatusOpened:
    call UpdateStatusBar

OpenDone:
    add rsp, 50h
    pop rdi
    pop rsi
    pop rbx
    ret
DoOpenFile endp

; ==============================================================================
; Helper: Save File
; ecx = bPromptSaveAs (1 = Save As, 0 = Save)
; N = 4 pushes (32 bytes) -> (8 - 32) = -24 = 8 mod 16
; sub rsp, 48h (72 bytes) -> (8 - 32 - 72) = -96 = 0 mod 16
; ==============================================================================
DoSaveFile proc
    push rbx
    push rsi
    push rdi
    push r12
    sub rsp, 48h

    mov r12d, ecx ; bPromptSaveAs

    cmp r12d, 1
    je PromptSave
    lea rcx, szCurrentFile
    call lstrlenA
    test eax, eax
    jnz WriteCurrentFile

PromptSave:
    lea rdi, ofn
    mov ecx, 152
    xor al, al
    rep stosb

    lea rdi, ofn
    mov dword ptr [rdi], 152
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

    lea rcx, ofn
    call GetSaveFileNameA
    test eax, eax
    jz SaveDone

WriteCurrentFile:
    mov rcx, hEditWnd
    mov edx, WM_GETTEXTLENGTH
    xor r8, r8
    xor r9, r9
    call SendMessageA
    mov esi, eax ; length of text in chars

    mov rcx, hEditWnd
    mov edx, WM_GETTEXT
    lea r8d, [rsi + 1]
    lea r9, szFileBuffer
    call SendMessageA

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
    mov rbx, rax

    mov rcx, rbx
    lea rdx, szFileBuffer
    mov r8d, esi
    lea r9, dwBytesWritten
    mov qword ptr [rsp + 20h], 0
    call WriteFile

    mov rcx, rbx
    call CloseHandle

    lea rcx, szBufferTemp
    lea rdx, fmtTitleFile
    lea r8, szCurrentFile
    call wsprintfA

    mov rcx, hMainWnd
    lea rdx, szBufferTemp
    call SetWindowTextA

    cmp qword ptr [hStatusWnd], 0
    je SaveDone
    mov rcx, hStatusWnd
    mov edx, SB_SETTEXTA
    xor r8d, r8d
    lea r9, szStatusSaved
    call SendMessageA

SaveDone:
    add rsp, 48h
    pop r12
    pop rdi
    pop rsi
    pop rbx
    ret
DoSaveFile endp

; ==============================================================================
; Helper: Build Menu Bar
; N = 4 pushes (32 bytes) -> (8 - 32) = -24 = 8 mod 16
; sub rsp, 28h (40 bytes) -> (8 - 32 - 40) = -64 = 0 mod 16
; ==============================================================================
BuildMenuBar proc
    push rbx
    push r12
    push r13
    push r14
    sub rsp, 28h

    call CreateMenu
    mov rbx, rax ; Main menu

    ; 1. File Popup
    call CreatePopupMenu
    mov r12, rax

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
    mov r13, rax

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
    mov r14, rax

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
    add rsp, 28h
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
BuildMenuBar endp

; ==============================================================================
; Window Procedure (100% Callee-Saved Register Adherence & 16-byte Alignment)
; rcx = hWnd, edx = uMsg, r8 = wParam, r9 = lParam
; N = 7 pushes (56 bytes) -> (8 - 56) = -48 = 0 mod 16
; sub rsp, 80h (128 bytes = 8 * 16) -> (0 - 128) = -128 = 0 mod 16
; ==============================================================================
WndProc proc
    push rbx
    push rsi
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 80h

    mov r12, rcx  ; hWnd
    mov r13d, edx ; uMsg
    mov r14, r8   ; wParam
    mov r15, r9   ; lParam

    cmp r13d, WM_CREATE
    je OnCreate
    cmp r13d, WM_SIZE
    je OnSize
    cmp r13d, WM_COMMAND
    je OnCommand
    cmp r13d, WM_SETFOCUS
    je OnSetFocus
    cmp r13d, WM_CTLCOLOREDIT
    je OnCtlColor
    cmp r13d, WM_CTLCOLORSTATIC
    je OnCtlColor
    cmp r13d, WM_DESTROY
    je OnDestroy

    ; Default handler with preserved arguments
    mov rcx, r12
    mov edx, r13d
    mov r8, r14
    mov r9, r15
    call DefWindowProcA
    jmp ProcReturn

OnCreate:
    ; 1. Create Monospace Font ("Consolas", height 19)
    mov ecx, 19
    xor edx, edx
    xor r8d, r8d
    xor r9d, r9d
    mov qword ptr [rsp + 20h], 400
    mov qword ptr [rsp + 28h], 0
    mov qword ptr [rsp + 30h], 0
    mov qword ptr [rsp + 38h], 0
    mov qword ptr [rsp + 40h], 0
    mov qword ptr [rsp + 48h], 0
    mov qword ptr [rsp + 50h], 0
    mov qword ptr [rsp + 58h], 0
    mov qword ptr [rsp + 60h], 0
    lea rax, szFontName
    mov qword ptr [rsp + 68h], rax
    call CreateFontA
    mov hFont, rax

    ; 2. Create Dark Theme Brush (#18181b in BGR = 0x001B1818)
    mov ecx, 001B1818h
    call CreateSolidBrush
    mov hBrushEdit, rax

    ; 3. Create Multi-line EDIT Control
    xor ecx, ecx
    lea rdx, szEditClass
    xor r8, r8
    mov r9d, WS_CHILD or WS_VISIBLE or WS_VSCROLL or WS_HSCROLL or ES_MULTILINE or ES_AUTOVSCROLL or ES_AUTOHSCROLL or ES_WANTRETURN or ES_NOHIDESEL
    mov qword ptr [rsp + 20h], 0
    mov qword ptr [rsp + 28h], 0
    mov qword ptr [rsp + 30h], 100
    mov qword ptr [rsp + 38h], 100
    mov rax, r12
    mov qword ptr [rsp + 40h], rax
    mov qword ptr [rsp + 48h], 100 ; child ID
    mov rax, hInstance
    mov qword ptr [rsp + 50h], rax
    mov qword ptr [rsp + 58h], 0
    call CreateWindowExA
    mov hEditWnd, rax

    ; Apply Font to Edit Control
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
    mov qword ptr [rsp + 20h], 0
    mov qword ptr [rsp + 28h], 0
    mov qword ptr [rsp + 30h], 0
    mov qword ptr [rsp + 38h], 0
    mov rax, r12
    mov qword ptr [rsp + 40h], rax
    mov qword ptr [rsp + 48h], 101 ; status ID
    mov rax, hInstance
    mov qword ptr [rsp + 50h], rax
    mov qword ptr [rsp + 58h], 0
    call CreateWindowExA
    mov hStatusWnd, rax

    cmp qword ptr [hStatusWnd], 0
    je CreateDone

    mov rcx, hStatusWnd
    mov edx, SB_SETPARTS
    mov r8d, 4
    lea r9, sbParts
    call SendMessageA

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

CreateDone:
    xor eax, eax
    jmp ProcReturn

OnSize:
    cmp qword ptr [hEditWnd], 0
    je SizeDone

    ; Resize Status Bar if it exists
    cmp qword ptr [hStatusWnd], 0
    je ResizeEditOnly

    mov rcx, hStatusWnd
    mov edx, WM_SIZE
    xor r8, r8
    xor r9, r9
    call SendMessageA

    ; Get status bar height
    mov rcx, hStatusWnd
    lea rdx, rcStatus
    call GetClientRect

ResizeEditOnly:
    ; Get client rect of main window
    mov rcx, r12
    lea rdx, rcClient
    call GetClientRect

    mov r14d, dword ptr [rcClient + 8]   ; total client width
    mov r15d, dword ptr [rcClient + 12]  ; total client height

    cmp qword ptr [hStatusWnd], 0
    je DoMoveEdit
    sub r15d, dword ptr [rcStatus + 12]  ; editHeight = clientHeight - statusHeight

DoMoveEdit:
    ; MoveWindow(hEditWnd, 0, 0, width, height, TRUE)
    mov rcx, hEditWnd
    xor edx, edx                        ; X = 0
    xor r8d, r8d                        ; Y = 0
    mov r9d, r14d                       ; nWidth
    movsxd rax, r15d
    mov qword ptr [rsp + 20h], rax     ; nHeight
    mov qword ptr [rsp + 28h], 1        ; bRepaint = TRUE
    call MoveWindow

SizeDone:
    xor eax, eax
    jmp ProcReturn

OnCommand:
    mov rbx, r14
    movzx edi, bx ; command ID
    shr rbx, 16   ; notification code

    cmp edi, 100  ; Edit control notification
    jne CheckMenuCmd
    cmp bx, EN_UPDATE
    je HandleEditChange
    cmp bx, EN_CHANGE
    je HandleEditChange
    jmp CmdDone

HandleEditChange:
    call UpdateStatusBar
    jmp CmdDone

CheckMenuCmd:
    cmp edi, IDM_FILE_NEW
    je MenuFileNew
    cmp edi, IDM_FILE_OPEN
    je MenuFileOpen
    cmp edi, IDM_FILE_SAVE
    je MenuFileSave
    cmp edi, IDM_FILE_SAVEAS
    je MenuFileSaveAs
    cmp edi, IDM_FILE_EXIT
    je MenuFileExit
    cmp edi, IDM_EDIT_UNDO
    je MenuEditUndo
    cmp edi, IDM_EDIT_CUT
    je MenuEditCut
    cmp edi, IDM_EDIT_COPY
    je MenuEditCopy
    cmp edi, IDM_EDIT_PASTE
    je MenuEditPaste
    cmp edi, IDM_EDIT_SELECTALL
    je MenuEditSelectAll
    cmp edi, IDM_HELP_ABOUT
    je MenuHelpAbout
    jmp CmdDone

MenuFileNew:
    mov rcx, hEditWnd
    mov edx, WM_SETTEXT
    xor r8, r8
    lea r9, [szStatusReady + 5] ; null string
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
    mov rcx, r12
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
    mov rcx, r12
    lea rdx, szAboutText
    lea r8, szAboutTitle
    mov r9d, 40h ; MB_OK | MB_ICONINFORMATION
    call MessageBoxA
    jmp CmdDone

CmdDone:
    xor eax, eax
    jmp ProcReturn

OnSetFocus:
    cmp qword ptr [hEditWnd], 0
    je FocusDone
    mov rcx, hEditWnd
    call SetFocus
FocusDone:
    xor eax, eax
    jmp ProcReturn

OnCtlColor:
    ; Custom dark theme for Edit control
    mov rcx, r14 ; HDC
    mov edx, 00E7E4E4h ; text color: #e4e4e7
    call SetTextColor

    mov rcx, r14
    mov edx, 001B1818h ; bk color: #18181b
    call SetBkColor

    mov rax, hBrushEdit
    jmp ProcReturn

OnDestroy:
    mov rcx, hBrushEdit
    call DeleteObject
    mov rcx, hFont
    call DeleteObject

    xor ecx, ecx
    call PostQuitMessage
    xor eax, eax

ProcReturn:
    add rsp, 80h
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rsi
    pop rbx
    ret
WndProc endp

; ==============================================================================
; Application Entry Point
; Entry from OS loader: RSP % 16 == 8
; sub rsp, 78h (120 bytes) -> (8 - 120) = -112 = 0 mod 16
; ==============================================================================
main proc
    sub rsp, 78h

    ; Initialize Common Controls (Status Bar)
    lea rdi, iccex
    mov dword ptr [rdi], 8
    mov dword ptr [rdi + 4], 4 ; ICC_BAR_CLASSES
    lea rcx, iccex
    call InitCommonControlsEx

    ; Obtain Module Handle
    xor ecx, ecx
    call GetModuleHandleA
    mov hInstance, rax

    ; Setup WNDCLASSEX in static memory
    lea rdi, wndClass
    mov dword ptr [rdi], 80 ; cbSize
    mov dword ptr [rdi + 4], 3 ; CS_HREDRAW | CS_VREDRAW
    lea rax, WndProc
    mov qword ptr [rdi + 8], rax
    mov dword ptr [rdi + 16], 0
    mov dword ptr [rdi + 20], 0
    mov rax, hInstance
    mov qword ptr [rdi + 24], rax
    mov qword ptr [rdi + 32], 0
    xor ecx, ecx
    mov edx, IDC_ARROW
    call LoadCursorA
    mov qword ptr [wndClass + 40], rax
    mov qword ptr [wndClass + 48], 0
    mov qword ptr [wndClass + 56], 0
    lea rax, szClassName
    mov qword ptr [wndClass + 64], rax
    mov qword ptr [wndClass + 72], 0

    lea rcx, wndClass
    call RegisterClassExA

    ; Build Native Menu Bar
    call BuildMenuBar
    mov hMainMenu, rax

    ; Create Main Window
    xor ecx, ecx
    lea rdx, szClassName
    lea r8, szAppTitle
    mov r9d, WS_OVERLAPPEDWINDOW or WS_VISIBLE or WS_CLIPCHILDREN
    mov qword ptr [rsp + 20h], 80000000h ; CW_USEDEFAULT
    mov qword ptr [rsp + 28h], 80000000h ; CW_USEDEFAULT
    mov qword ptr [rsp + 30h], 960         ; nWidth
    mov qword ptr [rsp + 38h], 640         ; nHeight
    mov qword ptr [rsp + 40h], 0           ; hWndParent
    mov rax, hMainMenu
    mov qword ptr [rsp + 48h], rax         ; hMenu
    mov rax, hInstance
    mov qword ptr [rsp + 50h], rax         ; hInstance
    mov qword ptr [rsp + 58h], 0           ; lpParam
    call CreateWindowExA
    mov hMainWnd, rax

    ; Display & Update Window
    mov rcx, hMainWnd
    mov edx, 5 ; SW_SHOW
    call ShowWindow

    mov rcx, hMainWnd
    call UpdateWindow

    mov rcx, hEditWnd
    call SetFocus

    ; Standard Win32 Message Loop
MsgLoop:
    lea rcx, msg
    xor edx, edx
    xor r8d, r8d
    xor r9d, r9d
    call GetMessageA
    test eax, eax
    jle ExitLoop

    lea rcx, msg
    call TranslateMessage
    lea rcx, msg
    call DispatchMessageA
    jmp MsgLoop

ExitLoop:
    xor ecx, ecx
    call ExitProcess
main endp
end
