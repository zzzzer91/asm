;显示存储键盘状态字节(0040:17h)的状态(思考采用的方法)
assume cs:code

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:
		call _regInit
		call _showKB

		mov ax,4c00h
		int 21h
;==========================================
_showKB:
		mov si,17h


testA:		mov di,160*20+2*10
		mov al,ds:[si]

		mov cx,8
showKBLoop:	mov dx,0
		shl al,1
		adc dx,30h
		mov es:[di],dl
		add di,2
		loop showKBLoop
		jmp testA

		ret
;==========================================
_regInit:
		mov ax,0040h
		mov ds,ax
		mov ax,0b800h
		mov es,ax

		ret
code ends

end start