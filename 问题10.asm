
assume cs:code,ds:data,ss:stack

data segment
		db 'conversation',0
data ends

stack segment
		dw 28 dup (0)
stack ends

code segment
start:		mov ax,stack
		mov ss,ax
		mov sp,128

		call _initReg
		call _clearScreen
		call _showStr1
		call _Capital
		call _showStr2

		mov ax,4c00h
		int 21h
;===============================================
_Capital:
		mov si,0
		mov cx,0

Capital:	mov cl,ds:[si]
		jcxz CapitalRet
		and byte ptr ds:[si],11011111b
		inc si
		jmp Capital

CapitalRet:	ret
;===============================================
_showStr2:	mov si,0
		mov di,160*11+2*30

		call _showstr

		ret
;===============================================
_showStr1:	mov si,0
		mov di,160*10+2*30

		call _showstr

		ret
;===============================================
_showStr:
		mov cx,0

showStr:	mov cl,ds:[si]
		jcxz showStrRet
		mov es:[di],cl
		inc si
		add di,2
		jmp showStr

showStrRet:	ret
;===============================================
_clearScreen:
		mov bx,0
		mov dx,0700h
		mov cx,2000
clearScreen:	mov es:[bx],dx
		add bx,2
		loop clearScreen

		ret
;===============================================
_initReg:	mov ax,data
		mov ds,ax
		mov ax,0b800h
		mov es,ax

		ret
code ends

end start