* vi:ts=8
*
****************
	XDEF	FontInit	conout

	INCLUDE	'gemdos.i'
	INCLUDE	'bios.i'
	INCLUDE	'xbios.i'

	INCLUDE	'conout.i'

FONTSZ	EQU	256*16

	Section TEXT

ERROR:	Pterm	d0

FontInit:
	Malloc	#FONTSZ*16		reserveer geheugen voor font
	tst.l	d0			 data en buffer
	ble	ERROR
	move.l	d0,FntData

	Fopen	#FntName,#0		lees font in buffer
	tst.l	d0
	bmi	1$		geen font file
	move.w	d0,d6

	move.l	FntData,a0		buffer adres

	Fread	d6,#FONTSZ,a0
	bmi	ERROR
	Fclose	d6
	tst.l	d0
	bmi	ERROR

2$:	bsr	FontBuild

	move.l	#AllFnts,v_fnt_tab(a6)
	move.w	#0,v_fnt_typ(a6)
	move.l	FntData,v_fnt_ad(a6)
	rts

1$:	dc.w	$a000			Systeem font naar '8086-format'
	move.l	8(a1),a0
	move.l	$4c(a0),a0
	move.l	FntData,a1

	move.w	#255,d0
3$:	move.b	(a0),(a1)+
	move.b	$100(a0),(a1)+
	move.b	$200(a0),(a1)+
	move.b	$300(a0),(a1)+
	move.b	$400(a0),(a1)+
	move.b	$500(a0),(a1)+
	move.b	$600(a0),(a1)+
	move.b	$700(a0),(a1)+
	move.b	$800(a0),(a1)+
	move.b	$900(a0),(a1)+
	move.b	$a00(a0),(a1)+
	move.b	$b00(a0),(a1)+
	move.b	$c00(a0),(a1)+
	move.b	$d00(a0),(a1)+
	move.b	$e00(a0),(a1)+
	move.b	$f00(a0),(a1)+

	addq.l	#1,a0
	dbra	d0,3$

	bra	2$

FontBuild:
	move.w	#15,d0			Make font tabel
	lea	AllFnts,a1
	move.l	FntData,a0
1$:	move.l	a0,(a1)+
	lea	FONTSZ(a0),a0
	dbra	d0,1$

	lea	AllFnts,a4

	move.l	(a4),a0			Reverse
	move.l	4(a4),a1
	bsr	FontRV

	move.l	(a4),a0			Dubblestrike
	move.l	8(a4),a1
	bsr	FontDS
	move.l	8(a4),a0		Reverse
	move.l	12(a4),a1
	bsr	FontRV

	move.l	(a4),a0			Underline
	move.l	16(a4),a1
	bsr	FontUL
	move.l	16(a4),a0		Reverse
	move.l	20(a4),a1
	bsr	FontRV
	move.l	16(a4),a0		Dubblestrike
	move.l	24(a4),a1
	bsr	FontDS
	move.l	24(a4),a0		Reverse
	move.l	28(a4),a1
	bsr	FontRV

	move.l	(a4),a0			Dim
	move.l	32(a4),a1
	bsr	FontDM
	move.l	32(a4),a0		Reverse
	move.l	36(a4),a1
	bsr	FontRV
	move.l	8(a4),a0		Dubblestrike
	move.l	40(a4),a1
	bsr	FontDM
	move.l	40(a4),a0		Reverse
	move.l	44(a4),a1
	bsr	FontRV
	move.l	16(a4),a0		Underline
	move.l	48(a4),a1
	bsr	FontDM
	move.l	48(a4),a0		Reverse
	move.l	52(a4),a1
	bsr	FontRV
	move.l	24(a4),a0		Dubblestrike Underline
	move.l	56(a4),a1
	bsr	FontDM
	move.l	56(a4),a0		Reverse
	move.l	60(a4),a1
	bsr	FontRV
	rts

FontRV:	move.w	#FONTSZ-1,d0
1$:	move.b	(a0)+,(a1)
	not.b	(a1)+
	dbra	d0,1$
	rts

FontUL:	move.w	#255,d0
	lea	ULCHAR*16(a0),a2
1$:	move.w	#15,d1
	move.l	a2,a3
2$:	move.b	(a0)+,(a1)
	move.b	(a3)+,d2
	or.b	d2,(a1)+
	dbra	d1,2$
	dbra	d0,1$
	rts

FontDS:	move.w	#FONTSZ-1,d0
1$:	move.b	(a0),(a1)
	move.b	(a0)+,d1
	lsr.b	#1,d1
	or.b	d1,(a1)+
	dbra	d0,1$
	rts

FontDM:	move.w	#255*8,d0
1$:	move.b	(a0)+,(a1)
	and.b	#%10101010,(a1)+
	move.b	(a0)+,(a1)
	and.b	#%01010101,(a1)+
	dbra	d0,1$
	rts

****************

	Section	DATA

FntName	dc.b	'\default.f16',0

****************

	Section	BSS

FntData	ds.l	1
AllFnts ds.l	16

	END
