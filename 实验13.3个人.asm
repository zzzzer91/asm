assume cs:code

stack segment stack
		db 128 dup (0)
stack ends

code segment
str1:		db 'Good,better,best,',0
str2:		db 'Never let it rest,',0
str3:		db 'Till good is better,',0
str4:		db 'And better,best.',0

strAdd:		dw offset str1
		dw offset str2
		dw offset str3
		dw offset str4
;================================================
start:
		call _newInt21h

		mov ax,cs
		mov ds,ax
		mov bx,offset strAdd
		mov si,offset row
		mov cx,4
ok:		mov bh,0	;第0页
		mov dh,ds:[si]	;dh中放行号
		mov dl,0	;dl中放列号
		mov ah,2	;ah=2,代表设置光标
		int 10h

		mov dx,ds:[bx]
		mov ah,9	;代表在光标处显示字符串
		int 21h
		add bx,2
		inc si
		loop ok

		mov ax,4c00h
		int 21h
;================================================
doStart:	cmp byte ptr ds:[dx],0
		je doRet
		mov cl,ds:[dx]
		mov ch,

doRet:		iret
doEnd:		nop
;================================================
_copyInt21h:
		mov ax,cs
		mov ds,ax
		mov si,offset doStart
		mov ax,0
		mov es,ax
		mov di,7e00h

		mov cx,offset doEnd - offset doStart
		cld
		rep movsb

		ret
;================================================
_newInt21h:
		call _copyInt21h

		mov ax,0
		mov es,ax
		mov word ptr es:[21h*4],7e00h
		mov word ptr es:[21h*4+2],0

		ret
code ends

end start