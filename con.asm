* vi:ts=8
*
****************
	XDEF	CIInit,CIUnin
	XDEF	COInit,COUnin

	INCLUDE	'gemdos.i'
	INCLUDE	'bios.i'
	INCLUDE	'xbios.i'

	INCLUDE	'io.i'
	INCLUDE	'conout.i'
	XREF	ConIn,CIPtr,ConIORec
	XREF	KeyInit,KeyUnin
	XREF	ConOut,f_norm
	XREF	FIndent
	XREF	LineA,SInfo
	XREF	FontInit

	Section	TEXT

CIInit:	move.l	#dummy,CIPtr

	Iorec	#1
	move.l	d0,ConIORec

	jsr	KeyInit

	Setexc	#TRAP0+CONIN,#ConIn
	move.l	d0,OTrapA
	rts

CIUnin:	Setexc	#TRAP0+CONIN,OTrapA
	jsr	KeyUnin
	rts

****************

COInit:	Cconws	#CReset

	dc.w	$a000
	move.l	d0,LineA
	move.l	LineA,a5
	lea	SInfo,a6

	jsr	FontInit

	move.l	#f_norm,v_funct(a6)
	bclr.b	#S_SCUR,v_status(a5)
	clr.w	v_cur_cx(a6)
	clr.w	v_cur_cy(a6)
	move.w	#79,v_cel_mx(a6)
	move.w	#23,v_cel_my(a6)
	move.w	#80*16,v_cel_wr(a6)

	Logbas
	move.l	d0,v_cur_ad(a5)
	move.l	d0,v_scr_ad(a6)
	move.l	d0,v_scr_top(a6)
	add.l	#32000,d0
	sub.w	v_cel_wr(a6),d0		Status line
	move.l	d0,v_scr_bot(a6)

	Setexc	#TRAP0+CONOUT,#ConOut
	move.l	d0,OTrapB

	move.w	#27,d0
	trap	#CONOUT
	move.w	#'E',d0
	trap	#CONOUT
	rts

COUnin:	Setexc	#TRAP0+CONOUT,OTrapB
	Cconws	#CReset
	rts

****************

	Section	DATA

CReset	dc.b	27,'E',27,'e',27,'q',0

****************

	Section	BSS

dummy	ds.w	1
OTrapA	ds.l	1
OTrapB	ds.l	1

	END
