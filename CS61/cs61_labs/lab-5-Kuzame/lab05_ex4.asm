;=================================================
; Name: Adrian Harminto
; Email: aharm002@ucr.edu
; 
; Lab: lab 4
; Lab section: 24
; TA: Bryan Marsh
; 
;=================================================
.orig x3000
;------------
;Instruction
;------------

LD R2, ptr
LD R6, start
LD R1, size
LD R5, convert

Loop ; 
STR R6, R2, #0
ADD R6, R6, R6
ADD R2, R2, #1
ADD R1, R1, #-1
BRp Loop

;Continuation on exercise 3

;---- Resetting its value ----
LD R2, ptr
LD R6, size; reusing R6

Loop2
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
ADD R2, R2, #1
ADD R6, R6, #-1
BRp Loop2


HALT
;------------
;Local data
;------------
NEWLINE		.STRINGZ	"\n"
size		.FILL	#10
start		.FILL	#1
ptr		.FILL	x4000
convert		.FILL	x30
zero		.STRINGZ	"0"
one		.STRINGZ	"1"
space		.STRINGZ	" "
binary		.STRINGZ	"b"

.orig x4000
new_ptr		.BLKW	#10

.end


