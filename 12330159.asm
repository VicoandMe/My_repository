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
             DB " (Press space to continue)", 0ah, 0dh, '$' ;设置要显示的提示信息
    column DB 07h, 06h, 05h, 04h, 03h, 02h, 01h, 00h
    beginCount DW 0    ;保存一个队名开始的位置
    currentCount DW 0  ;保存一个队名结束的位置
    endCount DW 0      ;当前显示在点阵上的最左边那一列的位置
    which DW 0         ;保存第几个队被选中
    count dw 0
    led DB 3fh,06h,5bh,4fh,66h,6dh,7dh,07h   ;LED七段显示管的数码表
    huadeng DB 01h,02h,04h,08h,10h,20h,40h,80h
    ;设置每个队名，共8个，每行一个队名，前后加8个空行码实现从最右边出现全部从左边消失的效果
    TeamName DB 0h,0h,0h,0h,0h,0h,0h,0h,38h,28h,0ffh, 28h, 38h, 0h
             DB 1fh, 1h,0ffh,  1h,1fh,  0h, 11h, 12h,0fch, 12h, 11h,  0h
             DB 60h,0c4h, 54h,0d5h, 5fh,0d4h, 64h,  0h,  0h,  0h, 0h, 0h, 0h,0h,0h     ;中山大学
             DB 0h,0h,0h,0h,0h,0h,0h,0h,22h,24h,0ffh,  0h,0ffh,11h,23h, 0h
             DB 40h, 41h,7ah,0efh, 7ah, 41h, 40h,  0h, 11h, 12h,0fch, 12h, 11h,  0h
             DB 60h,0c4h, 54h,0d5h, 5fh,0d4h,64h, 0h, 0h,0h,0h,0h,0h,0h,0h             ;北京大学
             DB 0h,0h,0h,0h,0h,0h,0h,0h,24h,74h, 84h, 2fh,0f4h,54h, 4h, 0h
             DB 1fh, 52h,5eh,0f7h, 5eh, 52h, 1fh,  0h, 91h,0feh, 94h,0f1h,0b5h,0ffh
             DB 0b5h,0f1h,  0h,2h, 42h, 42h,7eh,42h,42h,2h,0h,0h,0h,0h,0h,0h,0h,0h     ;华南理工
             DB 0h,0h,0h,0h,0h,0h,0h,0h,24h,7ch, 84h, 2fh,0f4h,54h, 4h, 0h
             DB 39h,0feh,3ch,0a0h,0ffh,0a0h, 3ch,  0h, 11h, 12h,0fch, 12h, 11h,  0h
             DB 60h,0c4h, 54h,0d5h, 5fh,0d4h,64h, 0h, 0h,0h,0h,0h,0h,0h,0h             ;华师大学
             DB 0h,0h,0h,0h,0h,0h,0h,0h,49h,5ah, 6dh,0dfh, 4ch,4ah, 1h,24h, 28h,0ffh, 0h
             DB 0ffh,  9h, 13h,  0h, 11h, 12h,0fch, 12h, 11h,  0h
             DB 60h,0c4h, 54h,0d5h, 5fh,0d4h, 64h, 0h, 0h, 0h,0h,0h,0h,0h,0h           ;东北大学
             DB 0h,0h,0h,0h,0h,0h,0h,0h,3fh,20h,0e0h, 20h, 20h, 1h,41h,41h
             DB 7fh, 41h,41h,  1h,  0h, 11h, 12h,0fch, 12h, 11h,  0h
             DB 60h,0c4h, 54h,0d5h, 5fh,0d4h, 64h,  0h,  0h, 0h, 0h, 0h,0h,0h,0h       ;广工大学
             DB 0h,0h,0h,0h,0h,0h,0h,0h,7fh,49h, 79h, 41h, 79h,49h,7fh, 0h
             DB 3eh,  0h,3eh,  0h, 7fh,  0h, 11h, 12h,0fch, 12h, 11h,  0h
             DB 60h,0c4h, 54h,0d5h, 5fh,0d4h, 64h,  0h, 0h, 0h, 0h,0h,0h,0h,0h         ;四川大学
             DB 0h,0h,0h,0h,0h,0h,0h,0h,1fh,52h, 5eh,0f7h, 5eh,52h,1fh, 0h
             DB 40h, 41h,7ah,0efh, 7ah, 41h, 40h,  0h, 11h, 12h,0fch, 12h, 11h
             DB 0h, 60h,0c4h, 54h,0d5h, 5fh,0d4h,64h, 0h, 0h,0h,0h,0h,0h,0h,0h         ;南京大学
data ENDS

;定义堆栈段
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
    INT 21h             ;显示提示信息
    
    ; add your code here
    MOV DX, io8255d     ;设置8255d口地址
    MOV AX, 89h         ;初始化8255，设置工作模式为方式0，C口作为输入，A口作为输出
    OUT DX, AL          ;把控制字送到8255D口完成初始化
input:
    MOV DX, io8255c
    IN AL, DX           ;读取8255C口的数据，也就是8个开关所组成的数
    CMP AL, 0           ;比较这个数是不是0，如果是0，代表还没有开关被按下
    JZ input            ;继续等待开关被按下
    
    MOV CL, 0ffh        ;终于有开关按下，现在判断第几个开关被按下
judge:
    SHR AL, 1           ;右移一位，最低位移出到符号位CF
    INC CL              ;计数器+1
    JNC judge           ;如果符号位的数是1，那么就找到了第几个开关被按下
                        ;否则继续右移计数器继续+1，直到找到第几个开关被按下
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
    MOV AL, CL          ;CL中所存的数，就是代表了第几组抢答成功
    MOV which, CX
    MOV BX, OFFSET led  ;查表找出这个数在数码管中显示的代码
    XLAT                ;得到数码管中显示这个数的abcdefg的序列
    MOV DX, io8255a
    OUT DX, AL          ;把这个序列输出到8255芯片A口
    MOV AX,0                   ;通过A口连接数码管显示出数字
                       
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
    MOV BX, which       ;把第几个组抢答成功的信息送到BX
    CALL DISPLAYS       ;调用点阵滚动循环显示组名的子程序，BX相当于传递参数
                        ;下面进入子程序，完成滚动循环显示组名的功能
   
    MOV DX, OFFSET MESSEXIT
    MOV AH, 09h
    INT 21h             ;当用户输入空格停止当前显示时，输出提示信息
                        ;询问用户是否继续
    JMP input           ;否则继续等待下一次开关被按下
        
exit:
    MOV AH, 4ch ; exit to operating system.
    INT 21h    

;------------8*8点阵显示小组名称子程序--------------------
DISPLAYS PROC near
    PUSH AX
    PUSH CX
    PUSH DX             ;保护主程序中的寄存器值
    
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
    JZ NO8              ;判断BX的值是多少，也就是哪个组抢答成功，
                        ;然后跳转到相应的处理程序，初始化变量开始的计数器以及结束的计数器的值
    
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
    JMP init            ;根据TeamName的数据，统计出每个组名的开始的计数器的值以及结束计数器的值
                        ;然后跳转至初始化命令
    
init:
    MOV AX, beginCount  
    MOV currentCount, AX    ;把开始的指针的位置赋给当前的指针
displayAllAgain:
    MOV  DX,io0809a
    OUT  DX,AL
    IN   AL,DX
    MOV AH, 0
    ADD AX, 01h
    MOV BL, 07h
    DIV BL
    ADD AL, 04h
    MOV CL, AL              ;设置一个状态显示的次数，
                            ;这个数越大滚动越慢，这个数越小滚动越快，闪得也越快
displayAll:
    MOV AH, 01h             ;设置ah为01h，即从最右边一列开始扫描
    PUSH CX                 ;保存外层循环的计数器CX
    MOV CX , 08h            ;设置CX为08h,因为扫描一次需要扫描8列,第一层循环
    MOV SI, OFFSET column   ;设置SI为column表的首地址
next:
    MOV AL, [SI]
    MOV BX, OFFSET TeamName    
    ADD BX, currentCount
    XLAT                    ;通过查表并且加上当前的偏移量currentCount
                            ;得到接下来要显示在相应列的行码
    MOV DX, proth 
    OUT DX, AL              ;设置端口，向点阵输出行码
    MOV AL, AH              ;把列码赋值给AL
    MOV DX, protlr
    OUT DX, AL              ;设置端口，向点阵输出列码
    MOV AL, 0               
    OUT DX, AL
    SHL AH, 01              ;列码向左移一位，实现从右到左扫描
    INC SI                  ;偏移量+1，得到要显示在相应列的行号
    
    LOOP next               ;继续扫描显示下一列
    POP CX                  ;扫描一遍8列完成，外层循环的CX出栈

    MOV AH, 01h            
    INT 16h
    JNZ displayExit         ;如果键盘有按键，那么跳转到按键处理的代码中
    
continue:
    LOOP displayAll         ;如果没有按键被按下，那么继续循环，重复显示一定次数这一帧
    INC currentCount        ;当前显示的最左边的那一列的指针向前移动一位,第二层循环
    

    
    
    
    
    MOV AX ,endCount
    SUB AX, 8
    CMP currentCount, AX
    JNZ loopAgain
    MOV AX, beginCount
    MOV currentCount, AX    ;如果当前的指针等于结尾指针减8，那么就完成了完整的一个组名的输入
                            ;要实现循环滚动，那当前指针重新赋值为开始的指针位置
                            ;否则当前指针继续自增，实现滚动显示
loopAgain:

    JMP displayAllAgain     ;处理完成后继续进行下一帧显示
    
displayExit:
    MOV AH, 00H 
    INT 16H                
    CMP AL, ' '             ;检查键盘的按键是不是空格
    JNZ continue            ;如果不是，重新调回循环中继续点阵显示
    MOV DX, io8255a         ;如果是空格，那么要结束当前的显示
    MOV AL, 0               ;得到向8255的a口输出0，把数码管灭灯
    OUT DX, AL
    MOV DX, protlr          ;向点阵的列码输出0，使得点阵不显示任何东西
    OUT DX, AL              ;为下一次的输入做准备
    MOV DX, ls273
    OUT DX, AL
    mov al,20h
    out 20h,al
    jmp input
    POP DX
    POP CX
    POP AX                  ;回复主程序寄存器
    RET                     ;返回主程序
DISPLAYS ENDP               ;子程序结束

code ENDS                   ;结束代码段

end start ; set entry point and stop the assembler.
