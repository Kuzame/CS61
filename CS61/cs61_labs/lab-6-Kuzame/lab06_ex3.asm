;=================================================
; Name: Adrian Harminto
; Email: aharm002@ucr.edu
; 
; Lab: lab 6
; Lab section: 24
; TA: Bryan Marsh
; 
;=================================================


.ORIG x3000
LD R2, ptr
LD R3, size

;neutralize R1
AND R1, R1, #0

;setting up error check for char 'b'
LD R4, charCheck
ADD R4, R4, #-1
NOT R4, R4
BRnzp JumpHere

;------------ Loop for debugging character 'b' ---------------
LoopIsChar
AND R1, R1, #0
LEA R0, errorChar
PUTS
JumpHere
GETC
OUT
ADD R1, R1, R0 ; put cin value into R1
ADD R1, R1, R4 ; check if it's a b
BRnp LoopIsChar
;-------------------------------------------------------------

;setting up conversion from hex to dec
LD R4, convert
ADD R4, R4, #-1
NOT R4, R4



Loop
;----------- Loop for debugging number 1 or 0 ----------------
LoopIsNumber
AND R1, R1, #0		;neutralize used R1
GETC
OUT
ADD R1, R1, R0		; inputting user input to R1
ADD R1, R1, R4		; applying conversion to R1
BRz MoveOn
ADD R1, R1, #-1
BRz MoveOn2			;if this still fails, then it is neither 0 or 1
LEA R0, errorNum
PUTS
BRnp LoopIsNumber

;-------------------------------------------------------------
MoveOn2
ADD R1, R1, #1		; return value 1 after checking it if it's 0
MoveOn
ADD R5, R5, R5		; total = total*2
ADD R5, R5, R1
AND R1, R1, #0		; Done using R1, reseting it's value to use for loops
ADD R2, R2, #1		; i++ on array
ADD R3, R3, #-1
BRzp Loop 

STR R5, R2, #0		; Store total R5 to the array

LD R1, start
LD R3, size2
LD R6, sub_ptr

JSRR R6 ; this is similar to calling void to perform complex/lots of codes

HALT
;localdata
errorChar	.STRINGZ	"\nBeginning should start with 'b'!\n"
errorNum	.STRINGZ	"\nCan only accept 0 or 1!\n"
charCheck	.fill x62
start 		.fill #1
ptr 		.fill x4000
size 		.fill xF
size2		.fill x1
sub_ptr 	.fill x5000
convert 	.fill x30

;ptr points here for the array
.ORIG x4000
	.BLKW xF

;-----------------------------------------------------------------------------------------------------------------------------
;ORIG x5000: void function. Print values inside of R2
;-----------------------------------------------------------------------------------------------------------------------------
.ORIG x5000
; backing up data
ST R0, BACKUP_R1_5000
ST R1, BACKUP_R1_5000
ST R2, BACKUP_R2_5000
ST R3, BACKUP_R3_5000
ST R4, BACKUP_R4_5000
ST R5, BACKUP_R5_5000
ST R6, BACKUP_R6_5000
ST R7, BACKUP_R7_5000
; ---------------
; EXECUTE the void function
; ---------------
LEA R0, NEWLINE
PUTS
LEA R0, binary
PUTS

AND R3, R3, #0
ADD R3, R3, #15
AND R4, R4, #0
ADD R4, R4, #4

LDR R1, R2, #0
; ----------------
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

; ---------------
EXIT
LEA R0, NEWLINE
PUTS

; restoring data
LD R0, BACKUP_R0_5000
LD R1, BACKUP_R1_5000
; LD R2, BACKUP_R2_5000
LD R3, BACKUP_R3_5000
LD R4, BACKUP_R4_5000
LD R5, BACKUP_R5_5000
LD R6, BACKUP_R6_5000
LD R7, BACKUP_R7_5000

; returning
RET

; Subroutine Data
binary .STRINGZ 	"b"
NEWLINE		.STRINGZ	"\n"
temp		.FILL xF
temp2		.FILL xF
zero		.STRINGZ	"0"
one		.STRINGZ	"1"
space		.STRINGZ	" "
BACKUP_R0_5000 .BLKW	#1
BACKUP_R1_5000 .BLKW	#1
BACKUP_R2_5000 .BLKW	#1
BACKUP_R3_5000 .BLKW	#1
BACKUP_R4_5000 .BLKW	#1
BACKUP_R5_5000 .BLKW	#1
BACKUP_R6_5000 .BLKW	#1
BACKUP_R7_5000 .BLKW	#1


