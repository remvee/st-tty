* vi:ts=8
*
****************
	XDEF	putchar
	XDEF	del_all
	XDEF	del_chr		8x16 Only!
	XDEF	del_bol		8x16 Only!
	XDEF	del_eol		8x16 Only!
	XDEF	scl_up
	XDEF	scl_dn

	INCLUDE	'conout.i'

	Section	TEXT

putchar:
	move.l	v_cur_ad(a5),a0
	move.l	v_fnt_ad(a6),a1
	asl.w	#4,d0
	lea	0(a1,d0.w),a1

	move.b	(a1)+,0(a0)
	move.b	(a1)+,80(a0)
	move.b	(a1)+,160(a0)
	move.b	(a1)+,240(a0)
	move.b	(a1)+,320(a0)
	move.b	(a1)+,400(a0)
	move.b	(a1)+,480(a0)
	move.b	(a1)+,560(a0)
	move.b	(a1)+,640(a0)
	move.b	(a1)+,720(a0)
	move.b	(a1)+,800(a0)
	move.b	(a1)+,880(a0)
	move.b	(a1)+,960(a0)
	move.b	(a1)+,1040(a0)
	move.b	(a1)+,1120(a0)
	move.b	(a1)+,1200(a0)
	rts

****************

del_all:
	move.l	v_scr_top(a6),a0
	cmp.l	v_scr_bot(a6),a0
	bge	2$
1$:	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	cmp.l	v_scr_bot(a6),a0
	blt	1$
2$:	rts

del_chr:
	move.l	v_cur_ad(a5),a0
	move.w	v_cel_mx(a6),d0
	sub.w	v_cur_cx(a6),d0
	subq.w	#1,d0
	bmi	2$
1$:	move.b	81(a0),80(a0)
	move.b	161(a0),160(a0)
	move.b	241(a0),240(a0)
	move.b	321(a0),320(a0)
	move.b	401(a0),400(a0)
	move.b	481(a0),480(a0)
	move.b	561(a0),560(a0)
	move.b	641(a0),640(a0)
	move.b	721(a0),720(a0)
	move.b	801(a0),800(a0)
	move.b	881(a0),880(a0)
	move.b	961(a0),960(a0)
	move.b	1041(a0),1040(a0)
	move.b	1121(a0),1120(a0)
	move.b	1(a0),(a0)+
	dbra	d0,1$

2$:	clr.b	0(a0)
	clr.b	80(a0)
	clr.b	160(a0)
	clr.b	240(a0)
	clr.b	320(a0)
	clr.b	400(a0)
	clr.b	480(a0)
	clr.b	560(a0)
	clr.b	640(a0)
	clr.b	720(a0)
	clr.b	800(a0)
	clr.b	880(a0)
	clr.b	960(a0)
	clr.b	1040(a0)
	clr.b	1120(a0)
	clr.b	1200(a0)
	rts

del_bol:
	move.l	v_cur_ad(a5),a0
	move.w	v_cur_cx(a6),d0
	sub.w	d0,a0
	subq.w	#1,d0
	bmi	2$
1$:	clr.b	80(a0)
	clr.b	160(a0)
	clr.b	240(a0)
	clr.b	320(a0)
	clr.b	400(a0)
	clr.b	480(a0)
	clr.b	560(a0)
	clr.b	640(a0)
	clr.b	720(a0)
	clr.b	800(a0)
	clr.b	880(a0)
	clr.b	960(a0)
	clr.b	1040(a0)
	clr.b	1120(a0)
	clr.b	1200(a0)
	clr.b	(a0)+
	dbra	d0,1$
2$:	rts

del_eol:
	move.l	v_cur_ad(a5),a0
	move.w	v_cel_mx(a6),d0
	sub.w	v_cur_cx(a6),d0
1$:	clr.b	80(a0)
	clr.b	160(a0)
	clr.b	240(a0)
	clr.b	320(a0)
	clr.b	400(a0)
	clr.b	480(a0)
	clr.b	560(a0)
	clr.b	640(a0)
	clr.b	720(a0)
	clr.b	800(a0)
	clr.b	880(a0)
	clr.b	960(a0)
	clr.b	1040(a0)
	clr.b	1120(a0)
	clr.b	1200(a0)
	clr.b	(a0)+
	dbra	d0,1$
2$:	rts

****************


scl_up:	move.l	v_scr_top(a6),a0
	lea	0(a0),a1
	add.w	v_cel_wr(a6),a1
	cmp.l	v_scr_bot(a6),a1
	beq	2$
1$:	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	move.l	(a1)+,(a0)+
	cmp.l	v_scr_bot(a6),a1
	blt	1$

2$:	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	clr.l	(a0)+
	cmp.l	v_scr_bot(a6),a0
	blt	2$
3$:	rts

scl_dn:	move.l	v_scr_bot(a6),a0
	lea	0(a0),a1
	sub.w	v_cel_wr(a6),a1
	cmp.l	v_scr_top(a6),a1
	beq	2$
1$:	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	move.l	-(a1),-(a0)
	cmp.l	v_scr_top(a6),a1
	bgt	1$

2$:	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	clr.l	-(a0)
	cmp.l	v_scr_top(a6),a0
	bgt	2$
3$:	rts

	END
