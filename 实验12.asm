
assume cs:code

data segment
		db 'Divide error!',0
data ends

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:

		call _newInt0

		mov ax,0ffffh
		mov bl,2
		div bl

		mov ax,4c00h
		int 21h
;========================================
do0:		jmp do0Start
		db 'divide error!',0

do0Start:	mov ax,cs
		mov ds,ax
		mov ax,0b800h
		mov es,ax
		mov si,07e00h + 3
		mov di,160*20+2*10

		mov ah,07
do0Loop:	mov al,ds:[si]
		cmp al,0
		je do0Ret
		mov es:[di],ax
		inc si
		add di,2
		jmp do0Loop

do0Ret:		mov ax,4c00h
		int 21h

do0End:		nop
;========================================
_cpyDo0:
		mov ax,cs
		mov ds,ax
		mov ax,0
		mov es,ax
		mov si,offset do0
		mov di,07e00h

		cld
		mov cx,offset do0End - offset do0
		rep movsb

		ret
;========================================
_newInt0:
		call _cpyDo0

		mov ax,0
		mov es,ax

		mov word ptr es:[0*4],07e00h
		mov word ptr es:[0*4+2],0

		ret
code ends

end start