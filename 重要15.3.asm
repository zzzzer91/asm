;松开A键,全屏显示'A'(call dword ptr cs:[200h]中,也执行了in al,60h 只不过al的值pop回来了)
assume cs:code

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:
		call _newInt9h

testA:		mov ax,1000h
		jmp testA

		call _setOldInt

		mov ax,4c00h
		int 21h
;==================================================
doStart:	push ax
		push bx
		push cx
		push es

		pushf
		call dword ptr cs:[200h];int9h中断例程的最后一句必然是iret(pop ip,pop cs,popf),所以前面要补上pushf,call dword ptr会自动push cs和ip
		in al,60h		;这条指令放在这里程序也能执行,说明上面一条指令中也存在in al,60h ,只不过al的值又pop回来了
		cmp al,1eh+80h
		je showA

doRet:		pop es
		pop cx
		pop bx
		pop ax
		iret
;==================================================
showA:		mov bx,0b800h
		mov es,bx
		mov bx,0

		mov cx,2000
doLoop:		mov byte ptr es:[bx],'A'
		add bx,2
		loop doLoop

		jmp doRet
doEnd:		nop
;==================================================
_setOldInt:
		mov bx,0
		mov es,bx

		cli
		push es:[200h]
		pop es:[9h*4]
		push es:[202h]
		pop es:[9h*4+2]
		sti

		ret
;==================================================
_setNewInt:
		mov bx,0
		mov es,bx

		cli
		mov word ptr es:[9h*4],7e00h
		mov word ptr es:[9h*4+2],0
		sti

		ret
;==================================================
_savOldInt:
		mov bx,0
		mov es,bx

		cli
		push es:[9h*4]
		pop es:[200h]
		push es:[9h*4+2]
		pop es:[202h]
		sti

		ret
;==================================================
_cpyNewInt:
		mov bx,cs
		mov ds,bx
		mov si,offset doStart
		mov bx,0
		mov es,bx
		mov di,7e00h

		mov cx,offset doEnd - offset doStart
		cld
		rep movsb

		ret
;==================================================
_newInt9h:
		call _cpyNewInt
		call _savOldInt
		call _setNewInt

		ret
code ends

end start