* vi:ts=8
*
*	VT52 - main
*
*	R.W. van 't Veer
*		15.VIII.95,	Amsterdam
*
****************
	XDEF	Main		Init

	INCLUDE	'io.i'

	Section	TEXT

Main:
Loop:	STATUS			Misc (put status line)

2$:	trap	#AUXIN		Lees teken van Serie-poort
	tst.w	d0
	beq	1$
	trap	#CONOUT		Teken naar Scherm
	subq.w	#1,Delay
	bpl	2$

1$:	move.w	#80,Delay
	trap	#CONIN		Lees teken van Toetsen-bord
	tst.w	d0
	beq	Loop
	trap	#AUXOUT		Teken naar Serie-poort
	bra	Loop

****************

	Section	DATA

WhoAmI	dc.b	27,'/K',0	Standard VT52

	Section	BSS

Delay	ds.w	1

	END
