* vi:ts=8
*
****************
	XDEF	KeyInit,KeyUnin,KAltTbl

	INCLUDE	'gemdos.i'
	INCLUDE	'xbios.i'

	Section	TEXT

ERROR:	Pterm	d0

KeyInit	Malloc	#256*4		reserveer geheugen voor keytables
	tst.l	d0
	ble	ERROR
	move.l	d0,unshift
	add.l	#256,d0
	move.l	d0,shift
	add.l	#256,d0
	move.l	d0,capsl
	add.l	#256,d0
	move.l	d0,KAltTbl

	Keytbl	#-1,#-1,#-1	haal orginele keytables
	move.l	d0,a2
	move.l	0(a2),Ounshif	onthoud ze
	move.l	4(a2),Oshift
	move.l	8(a2),Ocapsl

	move.w	#2,d0		copieer ze
	move.l	unshift,a1
1$:	move.l	(a2)+,a0
	move.w	#255,d1
2$:	move.b	(a0)+,(a1)+
	dbra	d1,2$
	dbra	d0,1$

	move.l	unshift,a0	verander unshift
	lea	unsdiff,a1
	bsr	patchtbl

	move.l	shift,a0	verander shift
	lea	shidiff,a1
	bsr	patchtbl

	move.l	capsl,a0	verander capslock
	lea	capdiff,a1
	bsr	patchtbl

	move.l	unshift,a0	maak alternate keytable
	move.l	KAltTbl,a1
	lea	altkeys,a2
	moveq	#0,d0
3$:	move.b	(a2)+,d0
	beq	4$
	move.b	0(a0,d0.w),0(a1,d0.w)
	or.b	#%10000000,0(a1,d0.w)
	bra	3$

4$:	Keytbl	unshift,shift,capsl
	rts

KeyUnin Keytbl	Ounshif,Oshift,Ocapsl
	Mfree	unshift
	rts

****************

patchtbl:
	moveq	#0,d0
1$:	move.b	(a1)+,d0
	beq	2$
	move.b	(a1)+,0(a0,d0.w)
	bra	patchtbl
2$:	rts

****************

	Section	DATA

altkeys	dc.b	16,17,18,19,20,21,22,23,24,25	QWERTYUIOP
	dc.b	30,31,32,33,34,35,36,37,38	ASDFGHJKL
	dc.b	44,45,46,47,48,49,50		ZXCVBNM
	dc.b	0

unsdiff	dc.b	59,-2,60,-3,61,-4,62,-5,63,-6,64,-7,65,-8,66,-9,67,-10,68,-11
	dc.b	71,-12	Clr
	dc.b	72,-13	Up
	dc.b	75,-14	Left
	dc.b	77,-15	Right
	dc.b	80,-16	Down
	dc.b	82,-17	Insert
*	dc.b	83,-18	Delete
	dc.b	97,-19	Undo
	dc.b	98,-20	Help
	dc.b	0

shidiff	dc.b	4,-25	3	POUND_SIGN
	dc.b	41,-26	`	MACRON
	dc.b	71,-12	Home
	dc.b	72,-21	Up	pgup
	dc.b	75,-22	Left	start
	dc.b	77,-23	Right	end
	dc.b	80,-24	Down	pgdn
	dc.b	82,-17	Insert
*	dc.b	83,-18	Delete
	dc.b	97,-1	Undo
	dc.b	98,-20	Help	exit
	dc.b	0

capdiff	dc.b	59,-2,60,-3,61,-4,62,-5,63,-6,64,-7,65,-8,66,-9,67,-10,68,-11
	dc.b	71,-12	Clr
	dc.b	72,-13	Up
	dc.b	75,-14	Left
	dc.b	77,-15	Right
	dc.b	80,-16	Down
	dc.b	82,-17	Insert
*	dc.b	83,-18	Delete
	dc.b	97,-19	Undo
	dc.b	98,-20	Help
	dc.b	0

****************

	Section	BSS

Ounshif	ds.l	1
Oshift	ds.l	1
Ocapsl	ds.l	1
unshift	ds.l	1
shift	ds.l	1
capsl	ds.l	1
KAltTbl	ds.l	1

	END
