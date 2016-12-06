;=================================================
; Name: Adrian Harminto
; Email: aharm002
; 
; Assignment name: Assignment 5
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
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
ReLoop
LD R6, MENU
JSRR R6
ADD R1, R1, #-1
BRz IsOne
ADD R1, R1, #-1
BRz IsTwo
ADD R1, R1, #-1
BRz IsThree
ADD R1, R1, #-1
BRz IsFour
ADD R1, R1, #-1
BRz IsFive
ADD R1, R1, #-1
BRz IsSix
ADD R1, R1, #-1
BRz IsSeven

; R1 should be diminished to 0 after reaching either one of these points below
IsOne
	LD R6, ALL_MACHINES_BUSY
	JSRR R6
	ADD R2, R2, #-1
	BRzp AllAreBusy
	;NotAllBusy
		LEA R0, ALLNOTBUSY
		PUTS
		BRnzp ExitIsOne
	AllAreBusy
		LEA R0, ALLBUSY
		PUTS
	ExitIsOne
	BRnzp ReLoop
IsTwo
	LD R6, ALL_MACHINES_FREE
	JSRR R6
	ADD R2, R2, #-1
	BRzp AllAreFree
	;NotAllBusy
		LEA R0, NOTFREE
		PUTS
		BRnzp ExitIsTwo
	AllAreFree
		LEA R0, FREE
		PUTS
	ExitIsTwo
	BRnzp ReLoop
IsThree
	LD R6, NUM_BUSY_MACHINES
	JSRR R6
	LEA R0, BUSYMACHINE1
	PUTS
	LD R6, PRINT_NUMBER
	JSRR R6
	LEA R0, BUSYMACHINE2
	PUTS
	BRnzp ReLoop
IsFour
	LD R6, NUM_FREE_MACHINES
	JSRR R6
	LEA R0, FREEMACHINE1
	PUTS
	LD R6, PRINT_NUMBER
	JSRR R6
	LEA R0, FREEMACHINE2
	PUTS
	BRnzp ReLoop
IsFive
	LD R6, GET_INPUT
	JSRR R6
	LD R6, MACHINE_STATUS
	JSRR R6
	LEA R0, STATUS1
	PUTS
	ADD R3, R2, #0 ; store MACHINE STATUS temporarily to R3, so we can use our print number helper
	ADD R2, R1, #0 ; load the value of GetInput
	LD R6, PRINT_NUMBER
	JSRR R6
	
	ADD R2, R3, #0 ; store the original value from MachineStatus back to R2
	ADD R2, R2, #-1
	BRzp StatusIsFree
	;StatusIsNOTFree
		LEA R0, STATUS2
		PUTS
		BRnzp ExitStatus
	StatusIsFree
		LEA R0, STATUS3
		PUTS
	ExitStatus		
	BRnzp ReLoop
IsSix
	LD R6, FIRST_FREE
	JSRR R6
	ADD R2, R2, #0
	BRn NoFirstFree
	;ThereIsFirstFree
		LEA R0, FIRSTFREE
		PUTS
		LD R6, PRINT_NUMBER
		JSRR R6
		LEA R0, FIRSTFREE2
		PUTS
		BRnzp ExitFirstFree
	NoFirstFree
		LEA R0, FIRSTFREE3
		PUTS
	ExitFirstFree
	BRnzp ReLoop
IsSeven
	LEA R0, Goodbye
	PUTS
HALT
;---------------	
;Data
;---------------
;Add address for subroutines
MENU				.FILL	x3400
ALL_MACHINES_BUSY	.FILL	x3800
ALL_MACHINES_FREE	.FILL	x3C00
NUM_BUSY_MACHINES	.FILL	x4000
NUM_FREE_MACHINES	.FILL	x4400
MACHINE_STATUS		.FILL 	x4800
FIRST_FREE			.FILL	x4C00
GET_INPUT			.FILL	x5000
PRINT_NUMBER		.FILL	x5400

;Other data 


;Strings for options
Goodbye .Stringz "Goodbye!\n"
ALLNOTBUSY .Stringz "Not all machines are busy\n"
ALLBUSY .Stringz "All machines are busy\n"
FREE .STRINGZ "All machines are free\n"
NOTFREE .STRINGZ "Not all machines are free\n"
BUSYMACHINE1 .STRINGZ "There are "
BUSYMACHINE2 .STRINGZ " busy machines\n"
FREEMACHINE1 .STRINGZ "There are "
FREEMACHINE2 .STRINGZ " free machines\n"
STATUS1 .STRINGZ "Machine "
STATUS2  .STRINGZ " is busy\n"
STATUS3 .STRINGZ " is free\n"
FIRSTFREE .STRINGZ "The first available machine is number "
FIRSTFREE2 .STRINGZ "\n"
FIRSTFREE3 .STRINGZ "No machines are free\n"



.ORIG x3400
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, allowed the
;                          user to select an option, and returned the selected option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7
; no other return value is possible
;-----------------------------------------------------------------------------------------------------------------
; restoring data
ST R0, BACKUP_R0_3400
ST R1, BACKUP_R1_3400
ST R2, BACKUP_R2_3400
ST R3, BACKUP_R3_3400
ST R4, BACKUP_R4_3400
ST R5, BACKUP_R5_3400
ST R6, BACKUP_R6_3400
ST R7, BACKUP_R7_3400
;-------------------------------
;INSERT CODE For Subroutine MENU
;--------------------------------
; R2 for conversion
LD R2, convert
BRnzp IsItOneToSeven
NotOneToSeven
LEA R0, Error_message_1
PUTS

IsItOneToSeven
LD R0, Menu_string_addr
PUTS
GETC
OUT
ADD R1, R0, #0
LEA R0, newline
PUTS
ADD R1, R1, R2
BRnz NotOneToSeven
ADD R1, R1, #-7
BRp NotOneToSeven
ADD R1, R1, #7


; restoring data
LD R0, BACKUP_R0_3400
;LD R1, BACKUP_R1_3400
LD R2, BACKUP_R2_3400
LD R3, BACKUP_R3_3400
LD R4, BACKUP_R4_3400
LD R5, BACKUP_R5_3400
LD R6, BACKUP_R6_3400
LD R7, BACKUP_R7_3400
; returning
RET
BACKUP_R0_3400 .BLKW	#1
BACKUP_R1_3400 .BLKW	#1
BACKUP_R2_3400 .BLKW	#1
BACKUP_R3_3400 .BLKW	#1
BACKUP_R4_3400 .BLKW	#1
BACKUP_R5_3400 .BLKW	#1
BACKUP_R6_3400 .BLKW	#1
BACKUP_R7_3400 .BLKW	#1
;--------------------------------
;Data for subroutine MENU
;--------------------------------
convert			.FILL	xFFD0 ; This is equivalent to the negative value of x30
newline			.STRINGZ "\n"
Error_message_1 .STRINGZ "INVALID INPUT\n"
Menu_string_addr .FILL x6000

.ORIG x3800
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY [1]
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy,    0 otherwise
;-----------------------------------------------------------------------------------------------------------------
; restoring data
ST R0, BACKUP_R0_3800
ST R1, BACKUP_R1_3800
ST R2, BACKUP_R2_3800
ST R3, BACKUP_R3_3800
ST R4, BACKUP_R4_3800
ST R5, BACKUP_R5_3800
ST R6, BACKUP_R6_3800
ST R7, BACKUP_R7_3800
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_BUSY
;--------------------------------
AND R2, R2, #0
LD R6, BUSYNESS_ADDR_ALL_MACHINES_BUSY
LDR R5, R6, #0
AND R6, R6, #0
ADD R6, R6, #15	;We want to check al 16 of them

CheckIfAllBusy
	ADD R5, R5, #0
	BRn NotAllBusy
	ADD R5, R5, R5
	ADD R6, R6, #-1
	BRzp CheckIfAllBusy
; After exiting CheckIfAllBusy successfully
ADD R2, R2, #1
	
NotAllBusy ; R2 is already 0 by default


; restoring data
LD R0, BACKUP_R0_3800
LD R1, BACKUP_R1_3800
;LD R2, BACKUP_R2_3800
LD R3, BACKUP_R3_3800
LD R4, BACKUP_R4_3800
LD R5, BACKUP_R5_3800
LD R6, BACKUP_R6_3800
LD R7, BACKUP_R7_3800
; returning
RET
BACKUP_R0_3800 .BLKW	#1
BACKUP_R1_3800 .BLKW	#1
BACKUP_R2_3800 .BLKW	#1
BACKUP_R3_3800 .BLKW	#1
BACKUP_R4_3800 .BLKW	#1
BACKUP_R5_3800 .BLKW	#1
BACKUP_R6_3800 .BLKW	#1
BACKUP_R7_3800 .BLKW	#1
;--------------------------------
;Data for subroutine ALL_MACHINES_BUSY
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_BUSY .Fill xC000

.ORIG x3C00 
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE [2]
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free,    0 otherwise
;-----------------------------------------------------------------------------------------------------------------
; restoring data
ST R0, BACKUP_R0_3C00
ST R1, BACKUP_R1_3C00
ST R2, BACKUP_R2_3C00
ST R3, BACKUP_R3_3C00
ST R4, BACKUP_R4_3C00
ST R5, BACKUP_R5_3C00
ST R6, BACKUP_R6_3C00
ST R7, BACKUP_R7_3C00
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_FREE
;--------------------------------
AND R2, R2, #0
LD R6, BUSYNESS_ADDR_ALL_MACHINES_FREE
LDR R5, R6, #0
AND R6, R6, #0
ADD R6, R6, #15	;We want to check al 16 of them

CheckIfAllFree
	ADD R5, R5, #0
	BRzp NotAllFree
	ADD R5, R5, R5
	ADD R6, R6, #-1
	BRzp CheckIfAllFree
; After exiting CheckIfAllFree successfully
ADD R2, R2, #1
	
NotAllFree ; R2 is already 0 by default

; restoring data
LD R0, BACKUP_R0_3C00
LD R1, BACKUP_R1_3C00
;LD R2, BACKUP_R2_3C00
LD R3, BACKUP_R3_3C00
LD R4, BACKUP_R4_3C00
LD R5, BACKUP_R5_3C00
LD R6, BACKUP_R6_3C00
LD R7, BACKUP_R7_3C00
; returning
RET
BACKUP_R0_3C00 .BLKW	#1
BACKUP_R1_3C00 .BLKW	#1
BACKUP_R2_3C00 .BLKW	#1
BACKUP_R3_3C00 .BLKW	#1
BACKUP_R4_3C00 .BLKW	#1
BACKUP_R5_3C00 .BLKW	#1
BACKUP_R6_3C00 .BLKW	#1
BACKUP_R7_3C00 .BLKW	#1
;--------------------------------
;Data for subroutine ALL_MACHINES_FREE
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_FREE .Fill xC000

.ORIG x4000
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES [3]
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R2): The number of machines that are busy
;-----------------------------------------------------------------------------------------------------------------
; restoring data
ST R0, BACKUP_R0_4000
ST R1, BACKUP_R1_4000
ST R2, BACKUP_R2_4000
ST R3, BACKUP_R3_4000
ST R4, BACKUP_R4_4000
ST R5, BACKUP_R5_4000
ST R6, BACKUP_R6_4000
ST R7, BACKUP_R7_4000
;-------------------------------
;INSERT CODE For Subroutine NUM_BUSY_MACHINES
;--------------------------------
AND R2, R2, #0
LD R6, BUSYNESS_ADDR_NUM_BUSY_MACHINES
LDR R5, R6, #0
AND R6, R6, #0
ADD R6, R6, #15	;We want to check al 16 of them

CheckNumBusy
	ADD R5, R5, #0
	BRn NotBusy
	ADD R2, R2, #1
	NotBusy
	ADD R5, R5, R5
	ADD R6, R6, #-1
	BRzp CheckNumBusy


; restoring data
LD R0, BACKUP_R0_4000
LD R1, BACKUP_R1_4000
;LD R2, BACKUP_R2_4000
LD R3, BACKUP_R3_4000
LD R4, BACKUP_R4_4000
LD R5, BACKUP_R5_4000
LD R6, BACKUP_R6_4000
LD R7, BACKUP_R7_4000
; returning
RET
BACKUP_R0_4000 .BLKW	#1
BACKUP_R1_4000 .BLKW	#1
BACKUP_R2_4000 .BLKW	#1
BACKUP_R3_4000 .BLKW	#1
BACKUP_R4_4000 .BLKW	#1
BACKUP_R5_4000 .BLKW	#1
BACKUP_R6_4000 .BLKW	#1
BACKUP_R7_4000 .BLKW	#1
;--------------------------------
;Data for subroutine NUM_BUSY_MACHINES
;--------------------------------
BUSYNESS_ADDR_NUM_BUSY_MACHINES .Fill xC000

.ORIG x4400
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES [4]
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R2): The number of machines that are free 
;-----------------------------------------------------------------------------------------------------------------
; restoring data
ST R0, BACKUP_R0_4400
ST R1, BACKUP_R1_4400
ST R2, BACKUP_R2_4400
ST R3, BACKUP_R3_4400
ST R4, BACKUP_R4_4400
ST R5, BACKUP_R5_4400
ST R6, BACKUP_R6_4400
ST R7, BACKUP_R7_4400
;-------------------------------
;INSERT CODE For Subroutine NUM_FREE_MACHINES
;--------------------------------
AND R2, R2, #0
LD R6, BUSYNESS_ADDR_NUM_FREE_MACHINES
LDR R5, R6, #0
AND R6, R6, #0
ADD R6, R6, #15	;We want to check al 16 of them

CheckNumFree
	ADD R5, R5, #0
	BRzp NotFree
	ADD R2, R2, #1
	NotFree
	ADD R5, R5, R5
	ADD R6, R6, #-1
	BRzp CheckNumFree

; restoring data
LD R0, BACKUP_R0_4400
LD R1, BACKUP_R1_4400
;LD R2, BACKUP_R2_4400
LD R3, BACKUP_R3_4400
LD R4, BACKUP_R4_4400
LD R5, BACKUP_R5_4400
LD R6, BACKUP_R6_4400
LD R7, BACKUP_R7_4400
; returning
RET
BACKUP_R0_4400 .BLKW	#1
BACKUP_R1_4400 .BLKW	#1
BACKUP_R2_4400 .BLKW	#1
BACKUP_R3_4400 .BLKW	#1
BACKUP_R4_4400 .BLKW	#1
BACKUP_R5_4400 .BLKW	#1
BACKUP_R6_4400 .BLKW	#1
BACKUP_R7_4400 .BLKW	#1
;--------------------------------
;Data for subroutine NUM_FREE_MACHINES
;--------------------------------
BUSYNESS_ADDR_NUM_FREE_MACHINES .Fill xC000

.ORIG x4800
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS [5]
; Input (R1): Which machine to check
; Postcondition: The subroutine has returned a value indicating whether the machine indicated
;                          by (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;-----------------------------------------------------------------------------------------------------------------
; restoring data
ST R0, BACKUP_R0_4800
ST R1, BACKUP_R1_4800
ST R2, BACKUP_R2_4800
ST R3, BACKUP_R3_4800
ST R4, BACKUP_R4_4800
ST R5, BACKUP_R5_4800
ST R6, BACKUP_R6_4800
ST R7, BACKUP_R7_4800
;-------------------------------
;INSERT CODE For Subroutine MACHINE_STATUS
;--------------------------------
AND R2, R2, #0
LD R6, BUSYNESS_ADDR_MACHINE_STATUS
LDR R5, R6, #0
AND R6, R6, #0
ADD R6, R6, #15	;We want to check al 16 of them

NOT R1, R1
ADD R1, R1, #1
ADD R6, R6, R1
BRz ExitIteration

Iterate
	ADD R5, R5, R5
	ADD R6, R6, #-1
	BRp Iterate
; After exiting CheckIfAllBusy successfully
ExitIteration

ADD R5, R5, #0
BRzp IsBusy
;IsFree
	ADD R2, R2, #1
	
IsBusy ; R2 is already 0 by default

; restoring data
LD R0, BACKUP_R0_4800
LD R1, BACKUP_R1_4800
;LD R2, BACKUP_R2_4800
LD R3, BACKUP_R3_4800
LD R4, BACKUP_R4_4800
LD R5, BACKUP_R5_4800
LD R6, BACKUP_R6_4800
LD R7, BACKUP_R7_4800
; returning
RET
BACKUP_R0_4800 .BLKW	#1
BACKUP_R1_4800 .BLKW	#1
BACKUP_R2_4800 .BLKW	#1
BACKUP_R3_4800 .BLKW	#1
BACKUP_R4_4800 .BLKW	#1
BACKUP_R5_4800 .BLKW	#1
BACKUP_R6_4800 .BLKW	#1
BACKUP_R7_4800 .BLKW	#1
;--------------------------------
;Data for subroutine MACHINE_STATUS
;--------------------------------
BUSYNESS_ADDR_MACHINE_STATUS.Fill xC000

.ORIG x4C00
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE [6]
; Inputs: None
; Postcondition: 
; The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R2): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
; restoring data
ST R0, BACKUP_R0_4C00
ST R1, BACKUP_R1_4C00
ST R2, BACKUP_R2_4C00
ST R3, BACKUP_R3_4C00
ST R4, BACKUP_R4_4C00
ST R5, BACKUP_R5_4C00
ST R6, BACKUP_R6_4C00
ST R7, BACKUP_R7_4C00
;-------------------------------
;INSERT CODE For Subroutine FIRST_FREE
;--------------------------------
AND R2, R2, #0
LD R6, BUSYNESS_ADDR_FIRST_FREE
LDR R5, R6, #0
AND R6, R6, #0
ADD R6, R6, #15	;We want to check al 16 of them

ADD R3, R5, #0	; R3 = Preserve the original value of R5
AND R4, R4, #0
ADD R4, R4, x0001	;temporary value that we'll left shift to check the next value 
CheckFirstFree
	AND R5, R5, R4
	ADD R5, R5, #0
	BRnp IsFirstFree
	
;	ADD R3, R6, #0 ; to right shift R6 numbers
;	RightShiftLoop
;		
	ADD R4, R4, R4
	ADD R5, R3, #0
	ADD R6, R6, #-1
	BRzp CheckFirstFree
	BRn NothingIsFree
; After exiting CheckIfAllFree successfully
IsFirstFree;
	ADD R2, R2, #15
	NOT R6, R6
	ADD R6, R6, #1
	ADD R2, R2, R6
	BRnzp DoneCheckFirstFree
NothingIsFree
	ADD R2, R2, #-1

DoneCheckFirstFree

; restoring data
LD R0, BACKUP_R0_4C00
LD R1, BACKUP_R1_4C00
;LD R2, BACKUP_R2_4C00
LD R3, BACKUP_R3_4C00
LD R4, BACKUP_R4_4C00
LD R5, BACKUP_R5_4C00
LD R6, BACKUP_R6_4C00
LD R7, BACKUP_R7_4C00
; returning
RET
BACKUP_R0_4C00 .BLKW	#1
BACKUP_R1_4C00 .BLKW	#1
BACKUP_R2_4C00 .BLKW	#1
BACKUP_R3_4C00 .BLKW	#1
BACKUP_R4_4C00 .BLKW	#1
BACKUP_R5_4C00 .BLKW	#1
BACKUP_R6_4C00 .BLKW	#1
BACKUP_R7_4C00 .BLKW	#1
;--------------------------------
;Data for subroutine FIRST_FREE
;--------------------------------
BUSYNESS_ADDR_FIRST_FREE .Fill xC000

.ORIG x5000
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: Get input / GET_INPUT
; Inputs: None
; Postcondition: 
; The subroutine get up to a 5 digit input from the user within the range [-32768,32767]
; Return Value (R1): The value of the contructed input
; NOTE: This subroutine should be the same as the one that you did in assignment 5
;	to get input from the user, except the prompt is different.
;-----------------------------------------------------------------------------------------------------------------
; restoring data
ST R0, BACKUP_R0_5000
ST R1, BACKUP_R1_5000
ST R2, BACKUP_R2_5000
ST R3, BACKUP_R3_5000
ST R4, BACKUP_R4_5000
ST R5, BACKUP_R5_5000
ST R6, BACKUP_R6_5000
ST R7, BACKUP_R7_5000
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
BRnzp StartJumpHere
Error
LEA R0, NEWLINE
PUTS
LEA R0, Error_message_2
PUTS
StartJumpHere
LEA R0, prompt
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
ADD R5, R5, #0 ; Check if it's negative
BRn Error
ADD R5, R5, #-15 ; Check if it's above +15
BRp Error

ADD R5, R5, #15 ; return its value back
LEA R0, NEWLINE
PUTS
ADD R1, R5, #0	; now store it to the desired register (R1)

; restoring data
LD R0, BACKUP_R0_5000
;LD R1, BACKUP_R1_5000
LD R2, BACKUP_R2_5000
LD R3, BACKUP_R3_5000
LD R4, BACKUP_R4_5000
LD R5, BACKUP_R5_5000
LD R6, BACKUP_R6_5000
LD R7, BACKUP_R7_5000
; returning
RET
BACKUP_R0_5000 .BLKW	#1
BACKUP_R1_5000 .BLKW	#1
BACKUP_R2_5000 .BLKW	#1
BACKUP_R3_5000 .BLKW	#1
BACKUP_R4_5000 .BLKW	#1
BACKUP_R5_5000 .BLKW	#1
BACKUP_R6_5000 .BLKW	#1
BACKUP_R7_5000 .BLKW	#1
;--------------------------------
;Data for subroutine Get input
;--------------------------------
prompt .STRINGZ "Enter which machine you want the status of (0 - 15), followed by ENTER: "
Error_message_2 .STRINGZ "ERROR INVALID INPUT\n"
positiveSign .FILL x2B	; negativeSign is x2D, so same as x2B + #2
timesTen     .FILL #9
NEWLINE		 .STRINGZ	"\n"

.ORIG x5400
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: print number
; Inputs: 
; Postcondition: 
; The subroutine prints the number that is in 
; Return Value : -
; NOTE: This subroutine should print the number to the user WITHOUT 
;		leading 0's and DOES NOT output the '+' for positive numbers.
;-----------------------------------------------------------------------------------------------------------------
; restoring data
ST R0, BACKUP_R0_5400
ST R1, BACKUP_R1_5400
ST R2, BACKUP_R2_5400
ST R3, BACKUP_R3_5400
ST R4, BACKUP_R4_5400
ST R5, BACKUP_R5_5400
ST R6, BACKUP_R6_5400
ST R7, BACKUP_R7_5400
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------

ADD R2, R2, #-10
BRzp HasTwoDigits
BRn HasOneDigit
HasTwoDigits
	LD R0, convert_to_dec
	ADD R0, R0, #1
	OUT
	LD R0, convert_to_dec
	ADD R0, R0, R2
	OUT
	BRnzp DonePrinting

HasOneDigit
	ADD R2, R2, #10
	LD R0, convert_to_dec
	ADD R0, R0, R2
	OUT

DonePrinting
; restoring data
LD R0, BACKUP_R0_5400
LD R1, BACKUP_R1_5400
LD R2, BACKUP_R2_5400
LD R3, BACKUP_R3_5400
LD R4, BACKUP_R4_5400
LD R5, BACKUP_R5_5400
LD R6, BACKUP_R6_5400
LD R7, BACKUP_R7_5400
; returning
RET
BACKUP_R0_5400 .BLKW	#1
BACKUP_R1_5400 .BLKW	#1
BACKUP_R2_5400 .BLKW	#1
BACKUP_R3_5400 .BLKW	#1
BACKUP_R4_5400 .BLKW	#1
BACKUP_R5_5400 .BLKW	#1
BACKUP_R6_5400 .BLKW	#1
BACKUP_R7_5400 .BLKW	#1
;--------------------------------
;Data for subroutine print number
;--------------------------------
convert_to_dec		.FILL	x30


.ORIG x6000
MENUSTRING .STRINGZ "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xC000			; Remote data
BUSYNESS .FILL xABCD		; <----!!!VALUE FOR BUSYNESS VECTOR!!!

;---------------	
;END of PROGRAM
;---------------	
.END
