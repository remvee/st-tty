* vi:ts=8
*
****************
	XDEF	StatusLn

	INCLUDE 'bios.i'
	INCLUDE 'conout.i'
	XREF	LineA,SInfo

	Section TEXT

force:	move.w	#-1,first
	move.w	#-1,CurStat
	
StatusLn:
	tst.w	first
	beq	force

	Kbshift	#-1
	move.w	CurStat,d1
	cmp.w	d1,d0
	bne	1$
	rts

1$:	move.w	d0,CurStat
	lea	StatLine,a0
	btst.b	#4,d0
	beq	2$
	move.b	#' ',70(a0)
	move.b	#'C',71(a0)
	move.b	#'a',72(a0)
	move.b	#'p',73(a0)
	move.b	#'s',74(a0)
	move.b	#' ',75(a0)
	move.b	#'L',76(a0)
	move.b	#'o',77(a0)
	move.b	#'c',78(a0)
	move.b	#'k',79(a0)
	bra	WriStaLn

2$:	move.b	#' ',70(a0)
	move.b	#' ',71(a0)
	move.b	#' ',72(a0)
	move.b	#' ',73(a0)
	move.b	#' ',74(a0)
	move.b	#' ',75(a0)
	move.b	#' ',76(a0)
	move.b	#' ',77(a0)
	move.b	#' ',78(a0)
	move.b	#' ',79(a0)

WriStaLn:
	lea	SInfo,a6
	move.l	LineA,a5

	clr.w	d0
	move.w	#79,d1
	lea	StatLine,a0
	move.l	v_scr_ad(a6),a1
	lea	24*16*80(a1),a1
	move.l	v_fnt_tab(a6),a2
	move.l	4(a2),a2

1$:	clr.w	d0
	move.b	(a0)+,d0
	asl.w	#4,d0
	lea	0(a2,d0.w),a3
	move.b	(a3)+,(a1)+
	move.b	(a3)+,79(a1)
	move.b	(a3)+,159(a1)
	move.b	(a3)+,239(a1)
	move.b	(a3)+,319(a1)
	move.b	(a3)+,399(a1)
	move.b	(a3)+,479(a1)
	move.b	(a3)+,559(a1)
	move.b	(a3)+,639(a1)
	move.b	(a3)+,719(a1)
	move.b	(a3)+,799(a1)
	move.b	(a3)+,879(a1)
	move.b	(a3)+,959(a1)
	move.b	(a3)+,1039(a1)
	move.b	(a3)+,1119(a1)
	move.b	(a3)+,1199(a1)
	dbra	d1,1$
	rts

****************

	Section	DATA

StatLine:
	dc.b	'STtty                                   '
	dc.b	'                                        '

****************

	Section	BSS

first:
	ds.w	1
CurStat:
	ds.w	1

	END
