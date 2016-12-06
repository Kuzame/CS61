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
LD R1, start
LD R2, ptr
LD R3, size
Loop
	STR R1, R2, #0
	ADD R2, R2, #1
	ADD R1, R1, R1
	ADD R3, R3, #-1
	BRp Loop
LD R2, ptr
LD R3, size
LD R6, sub_ptr

Loop2
	LDR R1, R2, #0
	JSRR R6 ; this is similar to calling void to perform complex/lots of codes
	ADD R2, R2, #1
	ADD R3, R3, #-1
	BRp Loop2

HALT
;localdata
start .fill #1
ptr .fill x4000
size .fill xA
sub_ptr .fill x5000

.ORIG x5000
; backing up data
ST R1, BACKUP_R1_5000
ST R2, BACKUP_R2_5000
ST R3, BACKUP_R3_5000
ST R4, BACKUP_R4_5000
ST R5, BACKUP_R5_5000
ST R6, BACKUP_R6_5000
ST R7, BACKUP_R7_5000

; EXECUTE
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
LD R1, BACKUP_R1_5000
LD R2, BACKUP_R2_5000
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
zero		.STRINGZ	"0"
one		.STRINGZ	"1"
space		.STRINGZ	" "
BACKUP_R1_5000 .BLKW	#1
BACKUP_R2_5000 .BLKW	#1
BACKUP_R3_5000 .BLKW	#1
BACKUP_R4_5000 .BLKW	#1
BACKUP_R5_5000 .BLKW	#1
BACKUP_R6_5000 .BLKW	#1
BACKUP_R7_5000 .BLKW	#1

