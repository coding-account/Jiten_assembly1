.global main
.func main

main:
        BL _getOperand          @ branch to _getOperand
        MOV R6, R0              @ move return value from R0 to R6
        BL _getOperand          @ branch to _getOperand
        MOV R7, R0              @ move return value from R0 to R7
        MOV R1, R6              @ move from R6 to R1
        MOV R2, R7              @ move from R7 to R2
        BL GCD_EUCLID           @ branch to GCD_ITERATIVE
        MOV R1, R0              @ move return value from R0 to R1
        BL _displayPromptCompt  @ branch to _displayPromptCompt
        B main                  @ branch to main so that it works as loop

_getOperand:
        MOV R4, LR              @ store LR since printf call ourselves
        SUB SP, SP, #4          @ make room in the stack
        LDR R0, =prompt_operand @ R0 contains the address of format string
        BL printf               @ call printf
        LDR R0, = user_input    @ R0 contains address of format string
        MOV R1, SP              @ move SP to R1 to store entry of stack
        BL scanf                @ call scanf
        LDR R0, [SP]            @ load value at SP into R0
        ADD SP, SP, #4          @ restore the stack pointer
        MOV PC, R4              @ return

GCD_EUCLID:
        PUSH {LR}              @ stores register on the stack
        CMP R2, #0             @ compare R2 to 0
        MOVEQ R0, R1           @ move if R0 and R1 equals
        POPEQ {PC}             @ load equals PC from the stack

        CMP R1, R2            @ compare R1 and R2  
        MOVHS R3, #1          @ move 1 to R3
        CMP R2, #0            @ compare R2 with 0
        MOVGT R4, #1          @ move if R4 is greater than 1 
        B _switchTestIterate  @ branch to _switchTestIterate
        
        _switchIterate:
                SUB R1, R1, R2 @ Substract R1 t0 R2 and store in R1
        
        _switchTestIterate:
                CMP R1, R2     @ compare R1 to R2
                BHS _switchIterate  @ branch higher or same to _switchIterate
                MOV R0, R1     @ move R1 to R0
        MOV R1, R2             @ move R2 to R1
        MOV R2, R0             @ move R0 to R2
        CMP R3, R4             @ compare R3 to R4
        MOV R3, R4             @ move R4 to R3 
        MOV R3, #0             @ move 0 to R3
        MOV R4, #0             @ move 0 to R4  
        BEQ GCD_EUCLID         @ branch equals GCD_EUCLID
        POP {PC}               @ loads program counter from the stack

_displayPromptCompt:
        MOV R4, LR               @ store LR since printf call ourselves
        LDR R0, =display_format  @ R0 contains address of format string
        BL printf                @ branch with link to printf
        MOV PC, R4               @ return
        
.data
prompt_operand:
        .asciz "Please enter the positive Integer: "
user_input:
        .asciz "%d"
display_format:
        .asciz "The gcd of two integers is:  %d \n"
