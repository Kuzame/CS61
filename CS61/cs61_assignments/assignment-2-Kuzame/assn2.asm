;=================================================
; Name: Adrian Harminto
; Email: aharm002@ucr.edu
; 
; Assignment name: Assignment 2
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
LD R1, DEC_0		;R1 = 1st var for 1st number
LD R2, DEC_0		;R2 = 2nd var for 2nd number
LD R3, HEX_TO_DEC	;R3 = to convert Hex to Dec
LD R4, DEC_0		;R4 = to store the result
LD R5, DEC_0		;R5 = temp var to print R2 since R2 will be negated
;----------------------------------------------
;outputs prompt
;----------------------------------------------	
LEA R0, intro			; 
PUTS
ADD R0, R0, #0
			; Invokes BIOS routine to output string

;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------


ADD R3, R3, #-1		; setting up Hex to Dec
NOT R3, R3

GETC
ADD R1, R1, R0		; inputting user input to R1
ADD R1, R1, R3		; applying Hex to Dec to R1
OUT

LEA R0, NEWLINE		; putting newline ( \n )
PUTS

GETC
ADD R2, R0, #0		; inputting user input to R2
ADD R2, R2, R3		; applying Hex to Dec to R2
ADD R5, R2, R5		; storing the value of R2 to be printed later
ADD R2, R2, #-1		; compensate with -1
NOT R2, R2		; turning value R2 to -R2
OUT 

LEA R0, NEWLINE		; putting newline ( \n )
PUTS

;----------------------------- printing
LD R0, HEX_TO_DEC
ADD R0, R0, R1
OUT
LD R0, SPACE
OUT
LD R0, NEG_SIGN
OUT
LD R0, SPACE
OUT
LD R0, HEX_TO_DEC
ADD R0, R0, R5
OUT
LD R0, SPACE
OUT
LD R0, EQ_SIGN
OUT
LD R0, SPACE
OUT

;----------------------------- //printing

ADD R4, R1, R2		; Perform operation R1 + (-R2)
ADD R4, R4, #0 		; bringing R4 to front for BR to read

BRzp END		; if x >= 0, go to label END
BRn ELSE		; if x < 0, go to label ELSE

ELSE:
LD R0, NEG_SIGN
OUT
NOT R4, R4
ADD R4, R4, #1
;NOT R0, R0 
;OUT


END:
LD R0, HEX_TO_DEC
ADD R0, R0, R4

OUT

LEA R0, NEWLINE		; putting newline ( \n )
PUTS


HALT				; Stop execution of program
;------	
;Data
;------
; String to explain what to input 
intro .STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 
NEWLINE .STRINGZ "\n"	; String that holds the newline character
DEC_0	.FILL	#0
HEX_TO_DEC	.FILL	x30
NEG_SIGN	.FILL	x2D
SPACE		.FILL	x20
EQ_SIGN		.FILL	x3D

;---------------	
;END of PROGRAM
;---------------	
.END

