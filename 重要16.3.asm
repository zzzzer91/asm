;通过直接定址表 显示16进制数字 (思考使用的方法,和数组联系起来)
assume cs:code,ds:data

data segment
		db 0eh,0ffh,88h,33h
data ends

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:
		call _regInit
		call _showNum

		mov ax,4c00h
		int 21h
;=================================================
_showNum:
		mov cx,4
goLoop:		mov al,ds:[si]
		call _showHex
		inc si
		add di,6
		loop goLoop

		ret
;=================================================
_showHex:
		jmp show
table		db '0123456789ABCDEF'
show:		mov ah,al
		and al,00001111b
		shr ah,1
		shr ah,1
		shr ah,1
		shr ah,1

		mov bx,0
		mov bl,ah
		mov ah,table[bx]
		mov es:[di],ah
		mov bl,al
		mov al,table[bx]
		mov es:[di+2],al

		ret
;=================================================
_regInit:
		mov bx,data
		mov ds,bx
		mov si,0
		mov bx,0b800h
		mov es,bx
		mov di,160*20+2*10

		ret
code ends

end start