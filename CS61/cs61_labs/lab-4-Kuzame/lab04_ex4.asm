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

LEA R0, intro ; exercise 4
PUTS		;putting intro
LD R3, ptr

Loop ; scanning characters
GETC
OUT
BRz END_LOOP
STR R0, R3, #0
ADD R3, R3, #1
ADD R1, R0, #-10
BRnp Loop

END_LOOP
;LEA R0, NULL
;STR R0, R3, #0
;LD R3, ptr

;NEWLINE
LEA R0, NEWLINE
PUTS
LEA R0, output
PUTS
LD R0, ptr ; print the entire characters entered
PUTS
LEA R0, NEWLINE
PUTS




HALT
;------------
;Local data
;------------
intro		.STRINGZ	"Enter characters, press enter when done:\n"
output		.STRINGZ	"You entered:\n"
NEWLINE		.STRINGZ	"\n"
ptr		.FILL	x4000
;NULL		.FILL	x00

.orig x4000

.end

