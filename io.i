* vi:ts=8
*
*	VT52 - IO header
*
****************

TRAP0	EQU	32
CONIN	EQU	3
CONOUT	EQU	4
AUXIN	EQU	5
AUXOUT	EQU	6

	NOLIST

	XREF	FExit,FIndent
	XREF	StatusLn

STATUS	MACRO
	tst.w	FExit		Stop Terminal Emulator?
	beq	91$
	rts

91$:	tst.w	FIndent		Indentify myself?
	beq	92$

	clr.w	FIndent
	lea	WhoAmI,a6	Stuur indentificatie code
93$:	move.b	(a6)+,d0
	beq	92$
	trap	#AUXOUT
	bra	93$

92$:	jsr	StatusLn
	ENDM

	LIST
