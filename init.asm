* vi:ts=8
*
****************
	XDEF	TPA

	INCLUDE	'gemdos.i'
	XREF	Main
	XREF	CIInit,CIUnin
	XREF	COInit,COUnin
	XREF	AIInit,AIUnin
	XREF	AOInit,AOUnin

STACKSZ	EQU	4096

	Section	TEXT

Init:	move.l	4(sp),TPA

	move.l	TPA,a0
	move.l	12(a0),d7	tlen
	add.l	20(a0),d7	dlen
	add.l	28(a0),d7	blen
	add.l	#STACKSZ,d7
	and.l	#$fffffe,d7	even adres

	move.l	d7,d0		Nieuwe stack
	add.l	a0,d0
	move.l	d0,sp

	Mshrink	a0,d7		Geef geheugen buiten programma vrij
	
	jsr	AIInit		Aux input init
	jsr	AOInit		Aux output init
	jsr	CIInit		Con input init
	jsr	COInit		Con input init

	jsr	Main

	jsr	COUnin
	jsr	CIUnin
	jsr	AOUnin
	jsr	AIUnin
	Pterm0

****************

	Section	BSS

TPA	ds.l	1

	END
