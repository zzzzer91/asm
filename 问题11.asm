;16字节相加
assume cs:code

data segment
		dw 2222H,3333H,4444H,5555H,6666H,7777H,8888H,99H
		dw 0ffffh,0ffffh,0ffffh,0ffffh,0ffffh,0ffffh,0ffffh,0
		dw 128 dup (0)
data ends

stack segment stack
	dw	128 dup (0)
stack ends

code segment
start:
		mov ax,data
		mov ds,ax
		mov es,ax

		call _addNumber

		mov ax,4c00h
		int 21h
;=====================================================
_addNumber:
		mov di,0
		mov si,32

		sub ax,ax

		mov cx,8
addNumber:	mov ax,ds:[di]
		mov bx,ds:[di+16]
		adc ax,bx
		mov es:[si],ax
		inc di ;用inc的原因是防止改变cf位(inc不会改变cf)
		inc di
		inc si
		inc si
		loop addNumber

		ret
code ends

end start