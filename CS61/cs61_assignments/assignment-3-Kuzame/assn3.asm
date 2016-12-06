;=================================================
; Name: Adrian Harminto
; Email: aharm002@ucr.edu
; 
; Assignment name: Assignment 3
; Lab section: 24
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team.
;
;=================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
LD R6, Convert_addr		; R6 <-- Address pointer for Convert
LDR R1, R6, #0			; R1 <-- VARIABLE Convert
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
ADD R4, R4, #4	;we want to separate them to have space every 4 bits
ADD R3, R3, #15	;there will be 16 (0-15) bits to print. this is like "int i" in for loops

;---------------
;ADD R1, R1, #0
;---------------
ADD R1, R1, #0;checking the value of R1
BRn print_one ;print 1 if it's negative

;~~~~~conditional: if it's 0~~~~~
print_zero
LEA R0, zero
BRnzp DOES_HAS_SPACE 
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~~conditional: if it's 1~~~~~~
print_one
LEA R0, one
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;~~~~ either 1 of above go here~~~
DOES_HAS_SPACE ; does it has space?
PUTS
ADD R1, R1, R1 ; we can do the left-shifting here
ADD R3, R3, #-1	;program will exit here before adding space if 16 bits had been printed
BRn EXIT
ADD R4, R4, #-1; is this the 4th bit?
BRp CONTINUE	;if it isn't the 4th bit, skip and continue
;if it is, then don't skip and print space

LEA R0, space
PUTS
ADD R4,R4, #4 ;reset it to #4 


CONTINUE
ADD R1, R1, #0 ;bringing R1 to be read
BRn print_one
BRzp print_zero



EXIT
LEA R0, NEWLINE ; finalize with a newline
PUTS

HALT
;---------------	
;Data
;---------------
NEWLINE	.STRINGZ	"\n"
one	.STRINGZ	"1"
zero	.STRINGZ	"0"
space	.STRINGZ	" "
Convert_addr .FILL xC000	; The address of where to find the data


.ORIG xC000			; Remote data
Convert .FILL xABCD		; <----!!!NUMBER TO BE CONVERTED TO BINARY!!!
;---------------	
;END of PROGRAM
;---------------	
.END
