assume cs:code,ds:data

data segment
		db 'welcome to masm'
		db 00000010b
		db 00100100b
		db 01110001b
data ends

code segment
start:		mov ax,data
		mov ds,ax
		mov ax,0b800h
		mov es,ax
		call show_masm

		mov ax,4c00h
		int 21h
;========================================================
show_masm:	mov ax,0
		mov si,0
		mov di,160*22+2*30 ;22，代表从23行首开始，30，代表31列开始
		mov cx,15
inputData:	mov al,ds:[si]
		mov ah,ds:[0fh]
		mov es:[di],ax
		mov ah,ds:[10h]
		mov es:[di+0a0h],ax ;+0a0h，正好加一行
		mov ah,ds:[11h]
		mov es:[di+140h],ax ;+140h，正好加二行
		inc si
		add di,2
		loop inputData

		ret
code ends

end start