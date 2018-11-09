
assume cs:code

data segment
		dw 8 dup (0)
data ends

code segment
start:		mov ax,data
		mov ss,ax
		mov sp,16
		mov word ptr ss:[0],offset s
		mov ss:[2],cs
		call dword ptr ss:[0]
		nop
s:		mov ax,offset s
		sub ax,ss:[0ch] ;ax=1
		mov bx,cs
		sub bx,ss:[0eh] ;bx=0

		mov ax,4c00h
		int 21h
code ends

end start