* vi:ts=8
*
****************
	XDEF	AIInit,AIUnin
	XDEF	AOInit,AOUnin

	INCLUDE	'bios.i'
	INCLUDE	'xbios.i'

	INCLUDE	'io.i'

	Section	TEXT

AIInit:	Iorec	#0
	move.l	d0,AuxIORec

	move.l	d0,a0			XON/XOFF?
	btst.b	#0,$20(a0)
	beq	1$

	Setexc	#TRAP0+AUXIN,#AuxIn
	move.l	d0,OTrapA
	rts

1$:	Setexc	#TRAP0+AUXIN,#AuxInNX	geen XON/XOFF!
	move.l	d0,OTrapA
	rts

AIUnin:	Setexc	#TRAP0+AUXIN,OTrapA
	rts

AOInit:	Iorec	#0
	move.l	d0,AuxIORec
	Setexc	#TRAP0+AUXOUT,#AuxOut
	move.l	d0,OTrapB
	rts

AOUnin:	Setexc	#TRAP0+AUXOUT,OTrapB
	rts

****************

AuxInNX:
	clr.w	d0
	bsr	AuxRead
	rte

AuxIn:	Bconstat #AUX
	tst.w	d0
	beq	1$
	Bconin	#AUX
1$:	rte
	
AuxRead	move	sr,-(sp)
	or 	#$700,sr
	move.l	AuxIORec,a0
	clr.l	d0

	move.w	6(a0),d1	ibufhd
	cmp.w	8(a0),d1	ibuftl
	beq	2$

	addq.w	#1,d1
	cmp.w	4(a0),d1	ibufsiz
	bcs	1$
	clr.w	d1

1$:	movea.l	0(a0),a1	ibuf
	clr.l	d0
	move.b	0(a1,d1.w),d0
	move.w	d1,6(a0)	ibufhd

2$:	move	(sp)+,sr
	rts

****************

AuxOut:	Bconout	#AUX,d0
	rte
	
AuxWrite:
	move	sr,-(sp)
	ori 	#$700,sr
	move.l	AuxIORec,a0

1$:	btst	#7,$fffa2d		Transmitter Status Register
	beq	2$

	move.w	$14(a0),d1
	cmp.w	$16(a0),d1
	bne	2$

	move.b	d0,$fffa2f		USART Date Register
	bra	3$

2$:	move.w	$16(a0),d1
	addq.w	#1,d1
	cmp.w	$12(a0),d1	obufsiz
	bcs	3$
	clr.w	d1

3$:	cmp.w	$14(a0),d1
	beq	4$

	movea.l	$e(a0),a1
	move.b	d0,0(a1,d1.w)
	move.w	d1,$16(a0)

4$:	move	(sp)+,sr
	rts  	

****************

	Section BSS

AuxIORec
	ds.l	1
OTrapA	ds.l	1
OTrapB	ds.l	1

	END
