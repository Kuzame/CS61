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
ADD R5, R5, #1
LD R4, sub_ptr2
JSRR R4

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

; EXECUTE
BRnzp StartJumpHere
Error
LD R0, errorMessage
PUTS
StartJumpHere
LD R0, introMessage
PUTS
;making sure that everything is neutralized
AND R1, R1, #0 ;########## WHAT IF YOU TRY: ADD R1, R0, #0 ??? ###############
AND R2, R2, #0 
AND R3, R3, #0 
AND R4, R4, #0 
AND R5, R5, #0 
AND R6, R6, #0 

;setting up error check for char '+'
LD R4, positiveSign
ADD R4, R4, #-1
NOT R4, R4
;------------ Loop for debugging '-'/'+' sign ----------------
GETC
OUT
ADD R1, R1, R0	; put cin value into R1
ADD R1, R1, R4	; check if it's a +
BRz IsPositive
ADD R1, R1, #-2	; check if it's a -
BRz IsNegative
ADD R1, R1, #-3	; -3 will navigate it up and check if it's '0'
BRz IsZero
BRn Error	; we don't want any negatives up to this point, bc we're checking 0-9 now
ADD R1, R1, #-9	; now 0-8 should be caught as by BRn and 9 by BRz
BRnz IsOneToNine
BRnp Error	; Then we are not receiving '+', '-', '0'-'9'
;-------------------------------------------------------------
IsPositive; treat it as if it's empty
BRnzp IsZero	; Jump to next argument
IsNegative
ADD R6, R6, #-1
BRnzp IsZero	; Jump to next argument
IsOneToNine
ADD R1, R1, #9
ADD R5, R5, R1	; Now store the value inside R5
IsZero		; Every conditions above exit with IsZero
BRnzp FirstTimeEnteringLoop
;-------------------------------------------------------------
;------------------- Loop for numbers ------------------------
IsNumber


FirstTimeEnteringLoop
;neutralize R1 to be use for R0 and testing
AND R1, R1, #0

GETC
OUT
ADD R1, R1, R0
ADD R1, R1, #-10
BRz ExitIsNumber	; Check if this is '\n', exit 
ADD R1, R1, #10		; return its value before
ADD R1, R1, R4
ADD R1, R1, #-5		; Now this should be '0'
BRz IsZero2
BRn Error	; Same reason as what I did before
ADD R1, R1, #-9
BRnz IsOneToNine2
BRp Error	; If it's not '0'(-9) - '9' (0), it should be error

;-------------------------------------------------------------
IsOneToNine2
ADD R1, R1, #9
;---------Do times ten before input another value--------------
IsZero2
AND R3, R3, #0
LD R2, timesTen
ADD R3, R5, #0	; create constant value of R5
;-------------------------
LoopTimesTen	; multiply whatever the value R5 has by 10
ADD R5, R5, R3
ADD R2, R2, #-1
BRp LoopTimesTen
;--------------------------- /ten ------------------------------
Skip

;--- Convert # to neg if it should be ---
ADD R6, R6, #0
BRzp NotNegative
NOT R1, R1
ADD R1, R1, #1
NotNegative
;----------------------------------------

ADD R5, R5, R1
BRnzp IsNumber

ExitIsNumber


; restoring data
LD R1, BACKUP_R1_5000
LD R2, BACKUP_R2_5000
LD R3, BACKUP_R3_5000
LD R4, BACKUP_R4_5000
;LD R5, BACKUP_R5_5000 ;the value is stored in R5
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
positiveSign .FILL x2B	; negativeSign is x2D, so same as x2B + #2
timesTen     .FILL #9
introMessage .FILL x6000
errorMessage .FILL x6100
BACKUP_R1_5000 .BLKW	#1
BACKUP_R2_5000 .BLKW	#1
BACKUP_R3_5000 .BLKW	#1
BACKUP_R4_5000 .BLKW	#1
BACKUP_R5_5000 .BLKW	#1
BACKUP_R6_5000 .BLKW	#1
BACKUP_R7_5000 .BLKW	#1
;----------##########----------- /sub routine 1 ------------##########-----------

;----------##########-----------  sub routine 2 ------------##########-----------
; R1 = value
; R2 = place (-10000, -1000, ... , -10 )
; R3 = temp (value-place)
; R4 = counter
; R5 = flag (if it's leading 0: -1. If it's no longer leading 0: 0)
; [R6 = conversion from ascii to its character]
.ORIG x5800
; backing up data
ST R1, BACKUP_R1_5800
ST R2, BACKUP_R2_5800
ST R3, BACKUP_R3_5800
ST R4, BACKUP_R4_5800
ST R5, BACKUP_R5_5800
ST R6, BACKUP_R6_5800
ST R7, BACKUP_R7_5800

; EXECUTE
AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0
AND R6, R6, #0

ADD R1, R1, R5
AND R5, R5, #0
ADD R5, R5, #-1	;set flag to -1 by default
LD R6, convert
LD R2, ten_thousand

LEA R0, introMsg
PUTS

;---- is it negative? ----
ADD R1, R1, #0
BRzp Not_Negative
LEA R0, neg_sign
PUTS
NOT R1, R1
ADD R1, R1, #1

Not_Negative	;otherwise print nothing

;--------- Begin Printing Process -----------
ADD R3, R3, R1
Loop4
ADD R3, R3, R2
BRn DoneLoop4	;the only way to get out of the loop is if R3 is negative
ADD R4, R4, #1	;If it's positive, add 1 to counter
AND R5, R5, #0	;If it ever enters here, it shouldn't be a leading 0
ADD R1, R3, #0
BRnzp Loop4

DoneLoop4
AND R3, R3, #0		;(emptying temp)
ADD R3, R3, R1		;(reseting temp to orig value)
LD R2, one_thousand	;(preparing place)
ADD R5, R5, #0	;check if this is leading 0
BRn Loop3	;if yes, do nothing and move on
ADD R4, R4, R6
ST R4, result
LD R0, result
OUT
AND R4, R4, #0

Loop3
ADD R3, R3, R2
BRn DoneLoop3	;the only way to get out of the loop is if R3 is negative
ADD R4, R4, #1	;If it's positive, add 1 to counter
AND R5, R5, #0	;If it ever enters here, it shouldn't be a leading 0
ADD R1, R3, #0
BRnzp Loop3

DoneLoop3
AND R3, R3, #0		;(emptying temp)
ADD R3, R3, R1		;(reseting temp to orig value)
LD R2, one_hundred	;(preparing place)
ADD R5, R5, #0	;check if this is leading 0
BRn Loop2	;if yes, do nothing and move on
ADD R4, R4, R6
ST R4, result
LD R0, result
OUT
AND R4, R4, #0

Loop2
ADD R3, R3, R2
BRn DoneLoop2	;the only way to get out of the loop is if R3 is negative
ADD R4, R4, #1	;If it's positive, add 1 to counter
AND R5, R5, #0	;If it ever enters here, it shouldn't be a leading 0
ADD R1, R3, #0
BRnzp Loop2

DoneLoop2
AND R3, R3, #0		;(emptying temp)
ADD R3, R3, R1		;(reseting temp to orig value)
LD R2, ten	;(preparing place)
ADD R5, R5, #0	;check if this is leading 0
BRn Loop	;if yes, do nothing and move on
ADD R4, R4, R6
ST R4, result
LD R0, result
OUT
AND R4, R4, #0


Loop
ADD R3, R3, R2
BRn DoneLoop	;the only way to get out of the loop is if R3 is negative
ADD R4, R4, #1	;If it's positive, add 1 to counter
AND R5, R5, #0	;If it ever enters here, it shouldn't be a leading 0
ADD R1, R3, #0
BRnzp Loop

DoneLoop
AND R3, R3, #0		;(emptying temp)
ADD R3, R3, R1		;(reseting temp to orig value)
;LD R2, ten		;(doesn't matter)
ADD R5, R5, #0	;check if this is leading 0
BRn ExitLoop	;if yes, do nothing and move on
ADD R4, R4, R6
ST R4, result
LD R0, result
OUT

ExitLoop
AND R4, R4, #0
;--------- now below should be the 5th one
ADD R1, R1, R6
ST R1, result
LD R0, result
OUT

; ---------------

; restoring data
LD R1, BACKUP_R1_5800
LD R2, BACKUP_R2_5800
LD R3, BACKUP_R3_5800
LD R4, BACKUP_R4_5800
LD R5, BACKUP_R5_5800
LD R6, BACKUP_R6_5800
LD R7, BACKUP_R7_5800
; returning
RET

; Subroutine Data
neg_sign	.STRINGZ "-"
convert		.FILL x30
ten_thousand	.FILL #-10000
one_thousand	.FILL #-1000
one_hundred	.FILL #-100
ten		.FILL #-10
result			.BLKW	#1
BACKUP_R1_5800 .BLKW	#1
BACKUP_R2_5800 .BLKW	#1
BACKUP_R3_5800 .BLKW	#1
BACKUP_R4_5800 .BLKW	#1
BACKUP_R5_5800 .BLKW	#1
BACKUP_R6_5800 .BLKW	#1
BACKUP_R7_5800 .BLKW	#1
introMsg		.STRINGZ	"You entered: "
;----------##########----------- /sub routine 2 ------------##########-----------

;------------
;Remote data
;------------
.ORIG x6000
;---------------
;messages
;---------------
intro .STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"
;---------------
;error_messages
;---------------
.ORIG x6100	
error_mes .STRINGZ	"\nERROR INVALID INPUT\n"

;---------------
;END of PROGRAM
;---------------
.END
;-------------------
;PURPOSE of PROGRAM
;-------------------
