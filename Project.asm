ORG 0000h 
LJMP START 
ORG 0100h 
START: NOP 
RS EQU P3.2         
    RW EQU P3.3         
    EN EQU P3.4 
    Dat EQU P2  
 CLR EN 
 ACALL INITDISP 
    MOV R1, #'P' 
    ACALL DISPCHAR 
    MOV R1, #'U' 
    ACALL DISPCHAR 
    MOV R1, #'T' 
    ACALL DISPCHAR 
    MOV R1, #' ' 
    ACALL DISPCHAR 
    MOV R1, #'Y' 
    ACALL DISPCHAR 
    MOV R1, #'O' 
    ACALL DISPCHAR 
    MOV R1, #'U' 
    ACALL DISPCHAR 
    MOV R1, #'R' 
    ACALL DISPCHAR 
    MOV R1, #' ' 
    ACALL DISPCHAR 
    MOV R1, #'H' 
    ACALL DISPCHAR 
    MOV R1, #'A' 
    ACALL DISPCHAR 
    MOV R1, #'N' 
    ACALL DISPCHAR 
    MOV R1, #'D' 
    ACALL DISPCHAR  
CHECK:   
    MOV A, P1           ; Read the input from port P1 
    JZ MOTOR_ON         ; If any bit in P1 is 0, turn on the motor   
ACALL MOTOR_OFF     ; If any bit in P1 is 1, turn off the motor 
MOTOR_ON:  
    SETB P0.0 ; Set terminal 1 to high 
    CLR P0.1 ; Clear terminal 12 to low 
    SETB P0.2 ; Set enable terminal to high 
    ACALL INITDISP 
 MOV R1, #'T' 
    ACALL DISPCHAR 
    MOV R1, #'A' 
    ACALL DISPCHAR 
    MOV R1, #'P' 
    ACALL DISPCHAR 
    MOV R1, #' ' 
    ACALL DISPCHAR 
    MOV R1, #'I' 
    ACALL DISPCHAR 
    MOV R1, #'S' 
    ACALL DISPCHAR 
    MOV R1, #' ' 
    ACALL DISPCHAR 
    MOV R1, #'O' 
    ACALL DISPCHAR 
    MOV R1, #'N' 
    ACALL DISPCHAR 
 ACALL DELAY_1S ; Run the motor for 1 second (adjust as needed) 
    MOV P0, #0; Disable the motor 
 ;ACALL INITDISP 
    
    JMP CHECK ; Run the motor continuously 
  
MOTOR_OFF: 
    MOV P0, #0 ; Disable the motor 
    JMP START ; Run the motor continuously 
 
; LCD initialize (to line 1) 
INITDISP: NOP 
    MOV R1, #38H ; 00111000 
    ACALL SENDCMD 
    MOV R1, #0EH ; 0000 1110 
    ACALL SENDCMD 
    MOV R1, #06H ; 0000 0110 
    ACALL SENDCMD 
    MOV R1, #01H ; 0000 0001 
    ACALL SENDCMD 
    MOV R1, #80H ; 1000 0000 
    ACALL SENDCMD 
    RET 
 
; Useful subroutines... 
DISPCHAR: ACALL DELAY_50MS ; BusyCheck ; The letter to be displayed should 
be placed in R1 
    SETB EN 
    SETB RS 
    CLR RW 
    MOV Dat, R1 
    ACALL CLEAREN 
    RET 
 
SENDCMD: ACALL DELAY_50MS ; BusyCheck ; The letter to be displayed should 
be placed in R1 
    SETB EN 
    CLR RS 
    CLR RW 
    MOV Dat, R1 
    ACALL CLEAREN 
    RET 
 
BUSYCHECK: CLR RS 
    SETB RW 
    JBC Dat.7, BUSYCHECK 
    RET 
CLEAREN: ACALL DELAY_50MS 
    CLR EN 
    RET 
DELAY: NOP 
    RET 
 
DELAY_CJNE: INC R0 
    MOV 51H, @R0 
    MOV R2, #00H 
    LOOP_H: MOV A, #00H 
        LOOP_L: INC A 
            CJNE A, #0FFH, LOOP_L 
            INC R2 
            MOV A, R2 
            CJNE A, 51H, LOOP_H 
            DEC R0 
            MOV 51H, @R0 
            MOV A, #00H 
            LAST_LOOP: INC A 
                CJNE A, 51H, LAST_LOOP 
    RET 
 
DELAY_50MS: MOV R0, #40H 
    MOV @R0, #012H 
    INC R0 
    MOV @R0, #058H 
    DEC R0 
    ACALL DELAY_CJNE 
    RET 
 
DELAY_1S: MOV 60H, #14H 
    LOOP: ACALL DELAY_50MS 
        DJNZ 60H, LOOP 
  RET 
 
 END 