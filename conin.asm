* vi:ts=8
*
****************
	XDEF	ConIn
	XDEF	FExit,CIPtr,ConIORec

	XREF	KAltTbl

	Section	TEXT

ConIn:	move.l	CIPtr,a0
	clr.w	d0
	move.b	(a0)+,d0
	beq	1$
	move.l	a0,CIPtr
	rte

1$:	bsr	ConRead
	tst.w	d0
	bge	4$

2$:	neg.w	d0
	cmp.w	#1,d0
	bne	3$
	move.w	#-1,FExit
	rte

3$:	lsl.w	#2,d0
	lea	KeyMap,a0
	add.w	d0,a0
	clr.w	d0
	move.b	(a0)+,d0
	move.l	a0,CIPtr

4$:	rte

****************

ConRead	move	sr,-(sp)
	or 	#$700,sr
	move.l	ConIORec,a0
	clr.l	d0

	move.w	6(a0),d1	Staat er iets in de buffer?
	cmp.w	8(a0),d1
	beq	2$

	addq.w	#4,d1
	cmp.w	4(a0),d1
	bcs	1$
	clr.w	d1

1$:	move.l	0(a0),a1
	move.l	0(a1,d1.w),d0
	move.w	d1,6(a0)

	ext.w	d0		meer character toetsen zijn WORD negatief

	tst.w	d0		de niet behandelde Alternate-Toetst
	bne	2$
	move.l	KAltTbl,a0
	swap	d0
	clr.w	d1
	move.b	0(a0,d0.w),d1
	swap	d0
	move.w	d1,d0

2$:	move	(sp)+,sr
	rts

****************

	Section	DATA

KeyMap	ds.l	2
	dc.b	27,'O1',0	F1
	dc.b	27,'O2',0
	dc.b	27,'O3',0
	dc.b	27,'O4',0
	dc.b	27,'O5',0
	dc.b	27,'O6',0
	dc.b	27,'O7',0
	dc.b	27,'O8',0
	dc.b	27,'O9',0
	dc.b	27,'O0',0	F10
	dc.b	0,0,0,0		Clr
	dc.b	27,'OA',0	up
	dc.b	27,'OD',0	left
	dc.b	27,'OC',0	right
	dc.b	27,'OB',0	down
	dc.b	0,0,0,0		Insert
	dc.b	0,0,0,0		Delete
	dc.b	27,'OM',0	Undo
	dc.b	27,'OL',0	Help
	dc.b	27,'OJ',0	prev. page
	dc.b	27,'OH',0	home
	dc.b	27,'OI',0	home-down
	dc.b	27,'OK',0	next page
	dc.b	163,0,0,0	POUND_SIGN
	dc.b	175,0,0,0	MACRON

****************

	Section	BSS

FExit	ds.w	1
CIPtr	ds.l	1
ConIORec:
	ds.l	1

	END
