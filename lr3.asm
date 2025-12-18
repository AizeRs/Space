.MODEL SMALL
.STACK 100h

.DATA
a    DW 1
b    DW 2
i    DW 3
k    DW 4
i1   DW -10
i2   DW 8
res  DW 4

.CODE
START:
    mov ax, @data
    mov ds, ax
    ; ввод данных через afd

; -------Начало главной части------- (суммарно 29 комманд, не считая метки.)
COMPUTE_I1_I2:
PREPARE_SI:            ; подготовим si = 4*i
	mov cx, [i]        ; записать [i] в cx
    shl cx, 1          ; cx = 2*i
    mov si, cx 	       ; si = 2*i
    shl si, 1          ; si = 4*i
	mov ax, [a]        ; записать [a] в ax
    cmp ax, [b]        ; сравнить ax и [b]
    jg  A_GREATER_B    ; если a > b - выполнить переход в ветвь A_GREATER_B

A_LESS_OR_EQUAL_B:
    ; ветвь a <= b : i1 = 6*i-10,  i2 = (8-6*i)
	add cx, si         ; cx = 6*i
	add [i1], cx       ; [i1] = 6*i-10
    sub [i2], cx       ; [i2] = 8-6*i
    jmp COMPUTE_ABS_I2 ; вычисление i1 и i2 завершено, выполнить переход к вычислению |i2|
    
A_GREATER_B:
    ; ветвь a > b  : i1 = -(4*i+3),  i2 = 7-4*i
    mov [i1], -3       ; [i1] = -3 
	sub [i1], si       ; [i1] = -4*i-3
    mov [i2], 7        ; [i2] = 7
    sub [i2], si       ; [i2] = 7-4*i

COMPUTE_ABS_I2:        ; результат - [i2] = |i2|
    neg [i2]           ; сменить знак [i2]. [i2] = -[i2]
	js COMPUTE_ABS_I2  ; если стало отрицательным - повторить neg

COMPUTE_RES:
    cmp [k], 0           ; сравнить k и 0
    jl  K_NEGATIVE     ; если k < 0 - выполнить переход в ветвь K_NEGATIVE
    ; ветвь k >= 0 : res = max(4, |i2|-3)
    cmp [i2], 7        ; сравнить [i2] и 7 ( аналогично сравнению [i2]-3 и 4)
    jle END_PROGRAM    ; т.к. res изначально хранит в себе 4
	mov cx, [i2]       ; записать [i2] = |i2| в cx
	sub cx, 3          ; вычести 3 из cx
    jmp WRITE_CX_TO_RES; выполнить переход к записи ответа
    
K_NEGATIVE:
    ; ветвь k < 0 : res = |i2| - |i1|
COMPUTE_ABS_I1:        ; результат [i1] = |i1|
	neg [i1]           ; сменить знак [i1]. [i1] = -[i1]
	js COMPUTE_ABS_I1  ; если стало отрицательным - повторить neg
	
	mov cx, [i2]       ; cx = |i2|
    sub cx, [i1]       ; cx = |i2| - |i1|

WRITE_CX_TO_RES:
    mov res, cx        ; записать результат из cx
; -------Конец главной части-------
END_PROGRAM:
    mov ah, 4Ch
    int 21h
END START
