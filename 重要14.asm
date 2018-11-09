;显示时间
assume cs:code

stack segment stack
		db 128 dup (0)
stack ends

code segment
Time_STYLE:	db 'YY/MM/DD HH:MM:SS',0
Time_COMS:	db 9,8,7,4,2,0
;===============================================
start:
		call _regInit
		call _showStr
		call _showTime

		mov ax,4c00h
		int 21h
;===============================================
_showTime:
testA:		mov si,offset Time_COMS
		mov di,160*20+2*10

		mov cx,6
showTimeLoop:	mov al,ds:[si]
		out 70h,al
		in al,71h
		mov ah,al
		shr ah,1
		shr ah,1
		shr ah,1
		shr ah,1
		and al,00001111b
		add ah,30h
		add al,30h
		mov es:[di],ah
		mov es:[di+2],al
		inc si
		add di,6
		loop showTimeLoop

		jmp testA

		ret
;===============================================
_showStr:
		push di

showStrLoop:	cmp byte ptr ds:[si],0
		je showStrRet
		mov al,ds:[si]
		mov es:[di],al
		inc si
		add di,2
		jmp showStrLoop

showStrRet:	pop di
		ret
;===============================================
_regInit:
		mov ax,cs
		mov ds,ax
		mov si,offset Time_STYLE
		mov ax,0b800h
		mov es,ax
		mov di,160*20+2*10

		ret
code ends

end start