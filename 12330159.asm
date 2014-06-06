; multi-segment executable file template.

proth EQU 288h
protlr EQU 290h
io8255a EQU 280h
io8255c EQU 282h
io8255d EQU 283h
io0809a EQU 298h
ls273 EQU 2A0h

data SEGMENT
    ; add your data here!
    MESS DB "Begin!", 0ah, 0dh, '$'
    MESSEXIT DB "Continue",03fh
             DB " (Press space to continue)", 0ah, 0dh, '$' ;����Ҫ��ʾ����ʾ��Ϣ
    column DB 07h, 06h, 05h, 04h, 03h, 02h, 01h, 00h
    beginCount DW 0    ;����һ��������ʼ��λ��
    currentCount DW 0  ;����һ������������λ��
    endCount DW 0      ;��ǰ��ʾ�ڵ����ϵ��������һ�е�λ��
    which DW 0         ;����ڼ����ӱ�ѡ��
    count dw 0
    led DB 3fh,06h,5bh,4fh,66h,6dh,7dh,07h   ;LED�߶���ʾ�ܵ������
    huadeng DB 01h,02h,04h,08h,10h,20h,40h,80h
    ;����ÿ����������8����ÿ��һ��������ǰ���8��������ʵ�ִ����ұ߳���ȫ���������ʧ��Ч��
    TeamName DB 0h,0h,0h,0h,0h,0h,0h,0h,38h,28h,0ffh, 28h, 38h, 0h
             DB 1fh, 1h,0ffh,  1h,1fh,  0h, 11h, 12h,0fch, 12h, 11h,  0h
             DB 60h,0c4h, 54h,0d5h, 5fh,0d4h, 64h,  0h,  0h,  0h, 0h, 0h, 0h,0h,0h     ;��ɽ��ѧ
             DB 0h,0h,0h,0h,0h,0h,0h,0h,22h,24h,0ffh,  0h,0ffh,11h,23h, 0h
             DB 40h, 41h,7ah,0efh, 7ah, 41h, 40h,  0h, 11h, 12h,0fch, 12h, 11h,  0h
             DB 60h,0c4h, 54h,0d5h, 5fh,0d4h,64h, 0h, 0h,0h,0h,0h,0h,0h,0h             ;������ѧ
             DB 0h,0h,0h,0h,0h,0h,0h,0h,24h,74h, 84h, 2fh,0f4h,54h, 4h, 0h
             DB 1fh, 52h,5eh,0f7h, 5eh, 52h, 1fh,  0h, 91h,0feh, 94h,0f1h,0b5h,0ffh
             DB 0b5h,0f1h,  0h,2h, 42h, 42h,7eh,42h,42h,2h,0h,0h,0h,0h,0h,0h,0h,0h     ;������
             DB 0h,0h,0h,0h,0h,0h,0h,0h,24h,7ch, 84h, 2fh,0f4h,54h, 4h, 0h
             DB 39h,0feh,3ch,0a0h,0ffh,0a0h, 3ch,  0h, 11h, 12h,0fch, 12h, 11h,  0h
             DB 60h,0c4h, 54h,0d5h, 5fh,0d4h,64h, 0h, 0h,0h,0h,0h,0h,0h,0h             ;��ʦ��ѧ
             DB 0h,0h,0h,0h,0h,0h,0h,0h,49h,5ah, 6dh,0dfh, 4ch,4ah, 1h,24h, 28h,0ffh, 0h
             DB 0ffh,  9h, 13h,  0h, 11h, 12h,0fch, 12h, 11h,  0h
             DB 60h,0c4h, 54h,0d5h, 5fh,0d4h, 64h, 0h, 0h, 0h,0h,0h,0h,0h,0h           ;������ѧ
             DB 0h,0h,0h,0h,0h,0h,0h,0h,3fh,20h,0e0h, 20h, 20h, 1h,41h,41h
             DB 7fh, 41h,41h,  1h,  0h, 11h, 12h,0fch, 12h, 11h,  0h
             DB 60h,0c4h, 54h,0d5h, 5fh,0d4h, 64h,  0h,  0h, 0h, 0h, 0h,0h,0h,0h       ;�㹤��ѧ
             DB 0h,0h,0h,0h,0h,0h,0h,0h,7fh,49h, 79h, 41h, 79h,49h,7fh, 0h
             DB 3eh,  0h,3eh,  0h, 7fh,  0h, 11h, 12h,0fch, 12h, 11h,  0h
             DB 60h,0c4h, 54h,0d5h, 5fh,0d4h, 64h,  0h, 0h, 0h, 0h,0h,0h,0h,0h         ;�Ĵ���ѧ
             DB 0h,0h,0h,0h,0h,0h,0h,0h,1fh,52h, 5eh,0f7h, 5eh,52h,1fh, 0h
             DB 40h, 41h,7ah,0efh, 7ah, 41h, 40h,  0h, 11h, 12h,0fch, 12h, 11h
             DB 0h, 60h,0c4h, 54h,0d5h, 5fh,0d4h,64h, 0h, 0h,0h,0h,0h,0h,0h,0h         ;�Ͼ���ѧ
data ENDS

;�����ջ��
stacks SEGMENT
    DW   128  dup(0)
stacks ENDS

code SEGMENT
    ASSUME CS:code, DS:data, SS:stacks
start:
; set segment registers:
    MOV AX, data
    MOV DS, AX
    MOV ES, AX
    
    MOV DX, OFFSET MESS
    MOV AH, 09h
    INT 21h             ;��ʾ��ʾ��Ϣ
    
    ; add your code here
    MOV DX, io8255d     ;����8255d�ڵ�ַ
    MOV AX, 89h         ;��ʼ��8255�����ù���ģʽΪ��ʽ0��C����Ϊ���룬A����Ϊ���
    OUT DX, AL          ;�ѿ������͵�8255D����ɳ�ʼ��
input:
    MOV DX, io8255c
    IN AL, DX           ;��ȡ8255C�ڵ����ݣ�Ҳ����8����������ɵ���
    CMP AL, 0           ;�Ƚ�������ǲ���0�������0������û�п��ر�����
    JZ input            ;�����ȴ����ر�����
    
    MOV CL, 0ffh        ;�����п��ذ��£������жϵڼ������ر�����
judge:
    SHR AL, 1           ;����һλ�����λ�Ƴ�������λCF
    INC CL              ;������+1
    JNC judge           ;�������λ������1����ô���ҵ��˵ڼ������ر�����
                        ;����������Ƽ���������+1��ֱ���ҵ��ڼ������ر�����
 interrupt:
    mov ax,cs
    mov ds,ax
    mov dx,offset int3
    mov ax,250bh
    int 21h
    
    in al,21h
    and al,0f7h
    out 21h,al
    sti
ll:    jmp ll
int3:
        
    mov ax,data
    mov ds,ax
    MOV AL, CL          ;CL��������������Ǵ����˵ڼ�������ɹ�
    MOV which, CX
    MOV BX, OFFSET led  ;����ҳ�����������������ʾ�Ĵ���
    XLAT                ;�õ����������ʾ�������abcdefg������
    MOV DX, io8255a
    OUT DX, AL          ;��������������8255оƬA��
    MOV AX,0                   ;ͨ��A�������������ʾ������
                       
shan:
      PUSH AX 
      MOV BX, OFFSET huadeng
      XLAT
      MOV DX, ls273
      OUT DX,AL
      POP AX
      CMP CL,AL
      JZ GUNEND
      INC AL
      MOV BX,30
      JMP GUN1
      JMP shan
 
GUN1:  DEC BX
      PUSH BX
      MOV BX,60000
GUN2:
      DEC BX
      CMP BX,0
      JNE GUN2
      POP BX
      CMP BX,0
      JNE GUN1
      JMP shan

GUNEND:
    MOV BX, which       ;�ѵڼ���������ɹ�����Ϣ�͵�BX
    CALL DISPLAYS       ;���õ������ѭ����ʾ�������ӳ���BX�൱�ڴ��ݲ���
                        ;��������ӳ�����ɹ���ѭ����ʾ�����Ĺ���
   
    MOV DX, OFFSET MESSEXIT
    MOV AH, 09h
    INT 21h             ;���û�����ո�ֹͣ��ǰ��ʾʱ�������ʾ��Ϣ
                        ;ѯ���û��Ƿ����
    JMP input           ;��������ȴ���һ�ο��ر�����
        
exit:
    MOV AH, 4ch ; exit to operating system.
    INT 21h    

;------------8*8������ʾС�������ӳ���--------------------
DISPLAYS PROC near
    PUSH AX
    PUSH CX
    PUSH DX             ;�����������еļĴ���ֵ
    
    CMP BX, 00h         
    JZ NO1
    CMP BX, 01h
    JZ NO2
    CMP BX, 02h
    JZ NO3
    CMP BX, 03h
    JZ NO4
    CMP BX, 04h
    JZ NO5
    CMP BX, 05h
    JZ NO6
    CMP BX, 06h
    JZ NO7
    CMP BX, 07h
    JZ NO8              ;�ж�BX��ֵ�Ƕ��٣�Ҳ�����ĸ�������ɹ���
                        ;Ȼ����ת����Ӧ�Ĵ�����򣬳�ʼ��������ʼ�ļ������Լ������ļ�������ֵ
    
NO1:MOV beginCount, 0
    MOV endCount, 40
    JMP init
    
NO2:MOV beginCount, 41
    MOV endCount, 85
    JMP init    
    
NO3:MOV beginCount, 86
    MOV endCount, 133
    JMP init 
    
NO4:MOV beginCount, 134
    MOV endCount, 178
    JMP init  
    
NO5:MOV beginCount, 179
    MOV endCount, 222
    JMP init
    
NO6:MOV beginCount, 223
    MOV endCount, 264    
    JMP init
    
NO7:MOV beginCount, 265
    MOV endCount, 307
    JMP init
    
NO8:MOV beginCount, 308
    MOV endCount, 352
    JMP init            ;����TeamName�����ݣ�ͳ�Ƴ�ÿ�������Ŀ�ʼ�ļ�������ֵ�Լ�������������ֵ
                        ;Ȼ����ת����ʼ������
    
init:
    MOV AX, beginCount  
    MOV currentCount, AX    ;�ѿ�ʼ��ָ���λ�ø�����ǰ��ָ��
displayAllAgain:
    MOV  DX,io0809a
    OUT  DX,AL
    IN   AL,DX
    MOV AH, 0
    ADD AX, 01h
    MOV BL, 07h
    DIV BL
    ADD AL, 04h
    MOV CL, AL              ;����һ��״̬��ʾ�Ĵ�����
                            ;�����Խ�����Խ���������ԽС����Խ�죬����ҲԽ��
displayAll:
    MOV AH, 01h             ;����ahΪ01h���������ұ�һ�п�ʼɨ��
    PUSH CX                 ;�������ѭ���ļ�����CX
    MOV CX , 08h            ;����CXΪ08h,��Ϊɨ��һ����Ҫɨ��8��,��һ��ѭ��
    MOV SI, OFFSET column   ;����SIΪcolumn����׵�ַ
next:
    MOV AL, [SI]
    MOV BX, OFFSET TeamName    
    ADD BX, currentCount
    XLAT                    ;ͨ������Ҽ��ϵ�ǰ��ƫ����currentCount
                            ;�õ�������Ҫ��ʾ����Ӧ�е�����
    MOV DX, proth 
    OUT DX, AL              ;���ö˿ڣ�������������
    MOV AL, AH              ;�����븳ֵ��AL
    MOV DX, protlr
    OUT DX, AL              ;���ö˿ڣ�������������
    MOV AL, 0               
    OUT DX, AL
    SHL AH, 01              ;����������һλ��ʵ�ִ��ҵ���ɨ��
    INC SI                  ;ƫ����+1���õ�Ҫ��ʾ����Ӧ�е��к�
    
    LOOP next               ;����ɨ����ʾ��һ��
    POP CX                  ;ɨ��һ��8����ɣ����ѭ����CX��ջ

    MOV AH, 01h            
    INT 16h
    JNZ displayExit         ;��������а�������ô��ת����������Ĵ�����
    
continue:
    LOOP displayAll         ;���û�а��������£���ô����ѭ�����ظ���ʾһ��������һ֡
    INC currentCount        ;��ǰ��ʾ������ߵ���һ�е�ָ����ǰ�ƶ�һλ,�ڶ���ѭ��
    

    
    
    
    
    MOV AX ,endCount
    SUB AX, 8
    CMP currentCount, AX
    JNZ loopAgain
    MOV AX, beginCount
    MOV currentCount, AX    ;�����ǰ��ָ����ڽ�βָ���8����ô�������������һ������������
                            ;Ҫʵ��ѭ���������ǵ�ǰָ�����¸�ֵΪ��ʼ��ָ��λ��
                            ;����ǰָ�����������ʵ�ֹ�����ʾ
loopAgain:

    JMP displayAllAgain     ;������ɺ����������һ֡��ʾ
    
displayExit:
    MOV AH, 00H 
    INT 16H                
    CMP AL, ' '             ;�����̵İ����ǲ��ǿո�
    JNZ continue            ;������ǣ����µ���ѭ���м���������ʾ
    MOV DX, io8255a         ;����ǿո���ôҪ������ǰ����ʾ
    MOV AL, 0               ;�õ���8255��a�����0������������
    OUT DX, AL
    MOV DX, protlr          ;�������������0��ʹ�õ�����ʾ�κζ���
    OUT DX, AL              ;Ϊ��һ�ε�������׼��
    MOV DX, ls273
    OUT DX, AL
    mov al,20h
    out 20h,al
    jmp input
    POP DX
    POP CX
    POP AX                  ;�ظ�������Ĵ���
    RET                     ;����������
DISPLAYS ENDP               ;�ӳ������

code ENDS                   ;���������

end start ; set entry point and stop the assembler.
