;=================================================
; Name: Adrian Harminto
; Email: aharm002@ucr.edu
; 
; Lab: lab 7
; Lab section: 24
; TA: Bryan Marsh
; 
;=================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
;-------------------------------
;INSERT CODE STARTING FROM HERE 
;--------------------------------

LD R6, sub_ptr
JSRR R6

HALT
;---------------	
;Data
;---------------
sub_ptr		.FILL x5000
sub_ptr2	.FILL x5800
;NEWLINE		 .STRINGZ	"\n"


;-----------##########---------- sub routine 1 -----------##########------------
; R1 will be use for operating the temporary value for user's input (R0)
; R5 will be where the value will be stored
; R6 will determine whether it's a positive/negative

.ORIG x5000
; backing up data
ST R1, BACKUP_R1_5000
ST R2, BACKUP_R2_5000
ST R3, BACKUP_R3_5000
ST R4, BACKUP_R4_5000
ST R5, BACKUP_R5_5000
ST R6, BACKUP_R6_5000
ST R7, BACKUP_R7_5000
LD R5, convert

; EXECUTE
Loop
LEA R0, intro
PUTS
;making sure that everything is neutralized
AND R1, R1, #0 ;########## WHAT IF YOU TRY: ADD R1, R0, #0 ??? ###############
AND R2, R2, #0 
AND R3, R3, #0 
AND R4, R4, #0 

GETC
ADD R1, R1, R0
ADD R1, R1, #-10
BRz Exit
ADD R1, R1, #10

ST R0, temp
LEA R0, msg
PUTS
LEA R0, temp
PUTS

;R1 = actual value
;R2 = temp value
;R3 = check it 16 times
;R4 = Parity check counter
;R5 = convert
ADD R3, R3, #15
ADD R2, R1, #0
BRn AddCounter
BRzp DontAdd

ParityCheckLoop
ADD R2, R2, R2
BRzp DontAdd
AddCounter
ADD R4, R4, #1

DontAdd

ADD R3, R3, #-1
BRzp ParityCheckLoop

LEA R0, msg2
PUTS
ADD R4, R4, R5
ST R4, temp
LEA R0, temp
PUTS
BRnzp Loop
Exit

LD R1, BACKUP_R1_5000
LD R2, BACKUP_R2_5000
LD R3, BACKUP_R3_5000
LD R4, BACKUP_R4_5000
LD R5, BACKUP_R5_5000 ;the value is stored in R5
LD R6, BACKUP_R6_5000
LD R7, BACKUP_R7_5000
; returning
RET

; Subroutine Data
convert	.FILL	x30
BACKUP_R1_5000 .BLKW	#1
BACKUP_R2_5000 .BLKW	#1
BACKUP_R3_5000 .BLKW	#1
BACKUP_R4_5000 .BLKW	#1
BACKUP_R5_5000 .BLKW	#1
BACKUP_R6_5000 .BLKW	#1
BACKUP_R7_5000 .BLKW	#1
intro .STRINGZ	"\nInput a character. Press ENTER to exit. \n"
msg .STRINGZ	"\nYou entered character: "
msg2.STRINGZ	"\nThe number 1's is:  "
temp	.BLKW	#1

;----------##########----------- /sub routine 1 ------------##########-----------


