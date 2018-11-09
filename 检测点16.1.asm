
assume cs:code,ds:data

stack segment stack
		db 128 dup (0)
stack ends

data segment
a		dw 1,2,3,4,5,6,7,32767
b		dd 0
data ends

code segment
start:
		mov bx,data
		mov ds,bx
		mov si,0

		mov cx,8
s:		mov ax,a[si]
		add word ptr b[0],ax
		adc word ptr b[2],0
		add si,2
		loop s

		mov ax,4c00h
		int 21h
code ends

end start