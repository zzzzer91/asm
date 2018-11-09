;按下R,G,B 改成相应背景色(思考这里代码用的巧妙的技巧)
assume cs:code

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:
testA:		call _changeColor
		nop
		jmp testA

		mov ax,4c00h
		int 21h
;===============================================
_changeColor:
		mov ah,0
		int 16h

		mov ah,1
		cmp al,'r'
		je red
		cmp al,'g'
		je green
		cmp al,'b'
		je blue

changColorRet:	ret
;===============================================
red:		shl ah,1

green:		shl ah,1

blue:		mov bx,0b800h
		mov es,bx
		mov bx,1

		mov cx,2000
s:		and byte ptr es:[bx],11111000b
		or es:[bx],ah
		add bx,2
		loop s

		jmp changColorRet
code ends

end start