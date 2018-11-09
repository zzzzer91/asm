assume cs:code

data segment
		db 128 dup (0)
data ends

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:
		mov ax,0b800h
		mov ds,ax
		mov es,ax

		call _cpyScreen

		mov ax,4c00h
		int 21h
;===============================================
_cpyScreenRow:
		push si
		push di
		push cx

		mov cx,80
		cld
		rep movsw

		pop cx
		pop di
		pop si
		ret
;===============================================
_cpyScreen:
		mov si,160
		mov di,0

		mov cx,24
cpyScreen:	call _cpyScreenRow
		add si,160
		add di,160
		loop cpyScreen

		ret
code ends

end start