;=================================================
; Name: Adrian Harminto
; Email: aharm002@ucr.edu
; 
; Assignment name: Assignment 4
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
; R1 will be use for operating the temporary value for user's input (R0)
; R5 will be where the value will be stored
; R6 will determine whether it's a positive/negative
;-------------------------------
;INSERT CODE STARTING FROM HERE 
;--------------------------------
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
IsPositive
ADD R3, R3, #1
BRnzp IsZero	; Jump to next argument
IsNegative
ADD R3, R3, #1
NOT R6, R6		; determine that the user already entered - & to inverse its value
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

ADD R1, R1, R4
ADD R1, R1, #-5		; Now this should be '0'
BRz IsZero2
BRn Others	; Same reason as what I did before
ADD R1, R1, #-9
BRnz IsOneToNine2
BRp Others	; If it's not '0'(-9) - '9' (0), it should be error
Others
;----------------- Debugging Test Only Sign Entered
AND R1, R1, #0
ADD R1, R1, R0
ADD R3, R3, #0		; we make sure that either number/signs already entered
BRp Error
;-----------------
ADD R1, R1, #-10
BRz ExitIsNumber	; Check if this is '\n', exit 
ADD R1, R1, #10		; return its value before
BRnzp Error
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
AND R3, R3, #0
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
LEA R0, NEWLINE
PUTS

;Example of how to Output Intro Message
;LD R0, introMessage  ;Output Intro Message
;PUTS

;ADD R1, R0, #-10  ;<--- use this to check if it's \n
;BRnp Loop

;Example of how to Output Error Message
;LD R0, errorMessage  ;Output Error Message
;PUTS

HALT
;---------------	
;Data
;---------------
positiveSign .FILL x2B	; negativeSign is x2D, so same as x2B + #2
timesTen     .FILL #9
introMessage .FILL x6000
errorMessage .FILL x6100
NEWLINE		 .STRINGZ	"\n"

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