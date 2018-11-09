;小写变大写并打印(难点:符号问题)
assume cs:code

data segment
		db "Beginer's All - purpose Symboltic Instruction code.",0
data ends

stack segment stack
		db 128 dup (0)
stack ends

code segment
start:
		mov ax,data
		mov ds,ax
		mov ax,0b800h
		mov es,ax

		call _showStr

		mov ax,4c00h
		int 21h
;================================================
_showStr:
		mov si,0
		mov di,160*10+2*10

showStr:	mov dl,ds:[si]
		cmp dl,0
		je showStrRet
		cmp dl,'a'
		jb skipAnd ;比 a ASCII码小就舍去
		cmp dl,'z'
		ja skipAnd ;比 z ASCII码大也舍去
		and dl,11011111b
skipAnd:	mov es:[di],dl
		inc si
		add di,2
		jmp showStr

showStrRet:	ret
code ends

end start