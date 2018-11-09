;模拟屏幕输入(还能更优吗?)
assume cs:code

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:
		call _regInit
testA:		call _showStr
		nop
		jmp testA

		mov ax,4c00h
		int 21h
;==================================================
;整体处理,从中往下细分
_showStr:
		mov ah,0
		int 16h

		cmp al,20h
		jb noChar
		cmp cx,127
		je showStrRet
		mov es:[bx+160*20],al
		inc cx
		mov bx,cx
		add bx,bx

showStrRet:		ret
;--------------------------------------------------
;如果输入的不是字符
noChar:		cmp ah,0eh
		je backSpace
		cmp ah,1ch
		je enter

		jmp showStrRet
;--------------------------------------------------
;退格键处理
backSpace:	cmp cx,0
		je showStrRet

		dec cx
		mov bx,cx
		add bx,bx
		mov byte ptr es:[bx+160*20],0

		jmp showStrRet
;--------------------------------------------------
;enter键处理
enter:		mov byte ptr es:[bx+160*20],0
		inc cx
		mov bx,cx
		add bx,bx

		jmp showStrRet
;==================================================
_regInit:
		mov bx,0b800h
		mov es,bx

		mov cx,0
		mov bx,cx

		ret
code ends

end start