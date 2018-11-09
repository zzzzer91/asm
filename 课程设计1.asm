;课程设计1
assume cs:code

data segment
;年份
		db '1975','1976','1977','1978'
		db '1979','1980','1981','1982'
		db '1983','1984','1985','1986'
		db '1987','1988','1989','1990'
		db '1991','1992','1993','1994'
		db '1995'
;年总收入
		dd 16,22,382,1356
		dd 2390,8000,16000,24486
		dd 50065,97479,140417,197514
		dd 345980,590827,803530,1183000
		dd 1843000,2759000,3753000,4649000
		dd 5937000
;雇员数
		dw 3,7,9,13,28,38,130,220
		dw 476,778,1001,1442,2250,2793,4037,5635
		dw 8226,11542,14430,15257,17800
data ends

stack segment stack
		dw 128 dup (0)
stack ends

code segment
start:
		mov ax,data
		mov ds,ax
		mov ax,0b800h
		mov es,ax

		call _clearScreen
		call _showInfo

		mov ax,4c00h
		int 21h
;===============================================
_showAvg:
		push si
		push di
		push bx
		push cx

		mov ax,ds:[si+84]
		mov dx,ds:[si+84+2]
		mov bx,ds:[bx+168]
		call _divNumber
		mov bx,10

		mov cx,0
		push cx

pushAvg:	call _divNumber
		add cx,48
		push cx
		mov cx,ax
		jcxz showAvgStr
		jmp pushAvg

showAvgStr:	pop cx
		jcxz showAvgRet
		mov ch,07
		mov es:[di+2*36],cx
		add di,2
		jmp showAvgStr

showAvgRet:	pop cx
		pop bx
		pop di
		pop si
		ret
;===============================================
_showPeople:
		push si
		push di
		push bx
		push cx

		mov ax,ds:[bx+168]
		mov bx,10

		mov cx,0
		push cx

pushPeople:	call _divNumber
		add cx,48
		push cx
		mov cx,ax
		jcxz showPeopleStr
		jmp pushPeople

showPeopleStr:	pop cx
		jcxz showPeopleRet
		mov ch,07
		mov es:[di+2*24],cx
		add di,2
		jmp showPeopleStr

showPeopleRet:	pop cx
		pop bx
		pop di
		pop si
		ret
;===============================================
_divNumber:
		mov cx,dx
		jcxz shortDiv
		mov cx,ax
		mov ax,dx
		mov dx,0
		div bx
		push ax
		mov ax,cx
		div bx
		mov cx,dx
		pop dx
		ret

shortDiv:	div bx
		mov cx,dx
		mov dx,0
		ret
;===============================================
_showSum:
		push si
		push di
		push bx
		push cx

		mov ax,ds:[si+84]
		mov dx,ds:[si+84+2]
		mov bx,10

		mov cx,0
		push cx

pushSum:	call _divNumber
		add cx,48
		push cx
		mov cx,ax
		jcxz showSumStr
		jmp pushSum

showSumStr:	pop cx
		jcxz showSumRet
		mov ch,07
		mov es:[di+2*12],cx
		add di,2
		jmp showSumStr

showSumRet:	pop cx
		pop bx
		pop di
		pop si
		ret
;===============================================
_showYear:
		push si
		push di
		push cx

		mov cx,4
showYearStr:	mov al,ds:[si]
		mov es:[di+2*2],al
		inc si
		add di,2
		loop showYearStr

		pop cx
		pop di
		pop si
		ret
;===============================================
_showInfo:
		mov si,0
		mov di,160*1
		mov bx,0

		mov cx,21
showInfo:	call _showYear
		call _showSum
		call _showPeople
		call _showAvg
		add si,4
		add di,160
		add bx,2
		loop showInfo

		ret
;===============================================
_clearScreen:
		mov bx,0700h
		mov di,0

		mov cx,1999
clearScreen:	mov es:[di],bx
		add di,2
		loop clearScreen

		ret
code ends

end start