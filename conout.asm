* vi:ts=8
*
****************
	XDEF	ConOut,f_norm
	XDEF	FIndent,LineA,SInfo

	INCLUDE	'conout.i'
	XREF	putchar,scl_up,scl_dn,del_all,del_chr,del_bol,del_eol
	XREF	SndBel,SndNoise

DELAY	EQU	5

	Section TEXT

ConOut:	move.l	LineA,a5
	lea	SInfo,a6

	clr.w	$452				Cursor off!
	move.b	#DELAY,v_cur_tim(a5)
	btst.b	#S_CREV,v_status(a5)
	beq	1$
	bclr.b	#S_CREV,v_status(a5)
	move.l	v_cur_ad(a5),a0
	not.b	(a0)
	not.b	80(a0)
	not.b	160(a0)
	not.b	240(a0)
	not.b	320(a0)
	not.b	400(a0)
	not.b	480(a0)
	not.b	560(a0)
	not.b	640(a0)
	not.b	720(a0)
	not.b	800(a0)
	not.b	880(a0)
	not.b	960(a0)
	not.b	1040(a0)
	not.b	1120(a0)
	not.b	1200(a0)

1$:	move.l	v_funct(a6),a0
	move.l	#f_norm,v_funct(a6)
	jsr	(a0)

	move.w	#1,$452
	rte

f_norm:	cmp.b	#' ',d0
	bcc	_char
	cmp.b	#7,d0		Bel
	beq	_bel
	cmp.b	#8,d0		Back Space
	beq	_bs
	cmp.b	#9,d0		Horizontal Tab
	beq	_ht
	cmp.b	#10,d0		Line Feed
	beq	_lf
	cmp.b	#13,d0		Carrage Return
	beq	_cr
	cmp.b	#27,d0		Escape
	beq	_esc

	rts

_bel:	jmp	SndBel

_bs:	subq.w	#1,v_cur_cx(a6)
	bpl	1$
	clr.w	v_cur_cx(a6)
	rts
1$:	subq.l	#1,v_cur_ad(a5)
	rts

_ht:	move.l	v_cur_ad(a5),d0
	sub.w	v_cur_cx(a6),d0
	move.w	v_cur_cx(a6),d1
	add.w	#8,d1
	and.w	#$fff8,d1
	cmp.w	v_cel_mx(a6),d1
	ble	1$
	move.w	v_cel_mx(a6),d1
1$:	add.w	d1,d0
	move.l	d0,v_cur_ad(a5)
	move.w	d1,v_cur_cx(a6)
	rts

_lf:	move.l	v_cur_ad(a5),d0
	add.w	v_cel_wr(a6),d0
	cmp.l	v_scr_bot(a6),d0
	blt	1$
	jmp	scl_up
1$:	move.l	d0,v_cur_ad(a5)
	addq.w	#1,v_cur_cy(a6)
	rts
	
_cr:	move.l	v_cur_ad(a5),d0
	sub.w	v_cur_cx(a6),d0
	move.l	d0,v_cur_ad(a5)
	clr.w	v_cur_cx(a6)
	rts

_char:	jsr	putchar
	move.w	v_cur_cx(a6),d0
	cmp.w	v_cel_mx(a6),d0
	bge	2$
	addq.w	#1,v_cur_cx(a6)
	addq.l	#1,v_cur_ad(a5)
3$:	rts
2$:	btst.b	#S_WRAP,v_status(a5)
	beq	3$
	bsr	_cr
	bra	_lf

_esc:	move.l	#f_esc,v_funct(a6)
	rts

****************

f_esc:	cmp.b	#'A',d0		Cursor up
	beq	_up
	cmp.b	#'B',d0		Cursor down
	beq	_dn
	cmp.b	#'C',d0		Cursor right
	beq	_ri
	cmp.b	#'D',d0		Cursor left
	beq	_bs
	cmp.b	#'E',d0		Clear screen
	beq	_cl
	cmp.b	#'G',d0		Set cursor position
	beq	_cm
	cmp.b	#'H',d0		Cursor home
	beq	_ho
	cmp.b	#'J',d0		Erase to end of page
	beq	_cd
	cmp.b	#'K',d0		Clear to end of line
	beq	_ce
	cmp.b	#'L',d0		Insert line
	beq	_al
	cmp.b	#'M',d0		Delete line
	beq	_dl
	cmp.b	#'N',d0		Erase to line start
	beq	_cb
	cmp.b	#'S',d0		Scroll region
	beq	_cs
	cmp.b	#'Z',d0		Indentify
	beq	_ID
	cmp.b	#'a',d0		Reverse mode
	beq	_mr
	cmp.b	#'b',d0		Dubbel mode
	beq	_md
	cmp.b	#'c',d0		Underline mode
	beq	_us
	cmp.b	#'d',d0		Dim mode
	beq	_mh
	cmp.b	#'e',d0		Show cursor
	beq	_ve
	cmp.b	#'f',d0		Hide cursor
	beq	_vi
	cmp.b	#'g',d0		More cursor
	beq	_vs
	cmp.b	#'j',d0		Save cursor
	beq	_sc
	cmp.b	#'k',d0		Restore cursor
	beq	_rc
	cmp.w	#'v',d0		No wrap
	beq	_RA
	cmp.w	#'w',d0		Wrap right margin
	beq	_SA
	cmp.b	#'q',d0		Normal mode
	beq	_me
	cmp.b	#7,d0		Visual bel
	beq	_vb

_RET	rts

_up:	move.l	v_cur_ad(a5),d0
	sub.w	v_cel_wr(a6),d0
	cmp.l	v_scr_top(a6),d0
	blt	1$
	move.l	d0,v_cur_ad(a5)
	subq.w	#1,v_cur_cy(a6)
1$:	rts
	
_dn:	move.l	v_cur_ad(a5),d0
	add.w	v_cel_wr(a6),d0
	cmp.l	v_scr_bot(a6),d0
	bge	1$
	move.l	d0,v_cur_ad(a5)
	addq.w	#1,v_cur_cy(a6)
1$:	rts
	
_ri:	move.w	v_cur_cx(a6),d0
	cmp.w	v_cel_mx(a6),d0
	bge	1$
	addq.w	#1,v_cur_cx(a6)
	addq.l	#1,v_cur_ad(a5)
1$:	rts

_cl:	clr.w	v_cur_cx(a6)
	clr.w	v_cur_cy(a6)
	move.l	v_scr_ad(a6),v_cur_ad(a5)
	jmp	del_all

_cm:	move.l	#_cm1,v_funct(a6)
	rts
_cm1:	move.l	#_cm2,v_funct(a6)
	sub.b	#32,d0
	and.w	#$ff,d0
	move.w	d0,v_arg1(a6)
	rts
_cm2:	move.w	v_arg1(a6),d1
	sub.b	#32,d0
	and.l	#$ff,d0

	cmp.w	v_cel_mx(a6),d0
	ble	1$
	move.w	v_cel_mx(a6),d0
1$:	cmp.w	v_cel_my(a6),d1
	ble	2$
	move.w	v_cel_my(a6),d1

2$:	move.w	d0,v_cur_cx(a6)
	move.w	d1,v_cur_cy(a6)
	mulu	v_cel_wr(a6),d1
	add.l	d0,d1
	add.l	v_scr_ad(a6),d1
	move.l	d1,v_cur_ad(a5)
	rts

_ho:	clr.w	v_cur_cx(a6)
	clr.w	v_cur_cy(a6)
	move.l	v_scr_ad(a6),v_cur_ad(a5)
	rts

_cd:	jsr	del_eol
	move.l	v_cur_ad(a5),d0
	sub.w	v_cur_cx(a6),d0
	add.w	v_cel_wr(a6),d0
	move.l	v_scr_top(a6),-(sp)
	move.l	d0,v_scr_top(a6)
	jsr	del_all
	move.l	(sp)+,v_scr_top(a6)
	rts

_ce:	jmp	del_eol

_al:	move.l	v_cur_ad(a5),d0
	sub.w	v_cur_cx(a6),d0
	move.l	d0,v_cur_ad(a5)
	clr.w	v_cur_cx(a6)
	move.l	v_scr_top(a6),-(sp)
	move.l	d0,v_scr_top(a6)
	jsr	scl_dn
	move.l	(sp)+,v_scr_top(a6)
	rts

_dl:	move.l	v_cur_ad(a5),d0
	sub.w	v_cur_cx(a6),d0
	move.l	d0,v_cur_ad(a5)
	clr.w	v_cur_cx(a6)
	move.l	v_scr_top(a6),-(sp)
	move.l	d0,v_scr_top(a6)
	jsr	scl_up
	move.l	(sp)+,v_scr_top(a6)
	rts

_cb:	jmp	del_bol

_cs:	move.l	#_cs1,v_funct(a6)
	rts
_cs1:	move.l	#_cs2,v_funct(a6)
	sub.b	#32,d0
	and.w	#$ff,d0
	move.w	d0,v_arg1(a6)
	rts
_cs2:	move.w	v_arg1(a6),d1
	sub.b	#32,d0
	and.l	#$ff,d0

	cmp.w	v_cel_my(a6),d0
	ble	1$
	move.w	v_cel_my(a6),d0
1$:	cmp.w	v_cel_my(a6),d1
	ble	2$
	move.w	v_cel_my(a6),d1

2$:	cmp.w	d0,d1
	bgt	3$
	beq	4$
	exg	d0,d1
	
3$:	clr.w	v_cur_cx(a6)
	move.w	d0,v_cur_cy(a6)

	addq.w	#1,d1
	mulu	v_cel_wr(a6),d0
	mulu	v_cel_wr(a6),d1
	add.l	v_scr_ad(a6),d0
	add.l	v_scr_ad(a6),d1
	move.l	d0,v_scr_top(a6)
	move.l	d1,v_scr_bot(a6)

	move.l	d0,v_cur_ad(a5)
4$:	rts

_ID:	move.w	#-1,FIndent
	rts

_mr:	or.w	#%0001,v_fnt_typ(a6)
	move.w	v_fnt_typ(a6),d0
	asl.w	#2,d0
	move.l	v_fnt_tab(a6),a0
	move.l	0(a0,d0.w),v_fnt_ad(a6)
	rts

_md:	or.w	#%0010,v_fnt_typ(a6)
	move.w	v_fnt_typ(a6),d0
	asl.w	#2,d0
	move.l	v_fnt_tab(a6),a0
	move.l	0(a0,d0.w),v_fnt_ad(a6)
	rts

_us:	or.w	#%0100,v_fnt_typ(a6)
	move.w	v_fnt_typ(a6),d0
	asl.w	#2,d0
	move.l	v_fnt_tab(a6),a0
	move.l	0(a0,d0.w),v_fnt_ad(a6)
	rts

_mh:	or.w	#%1000,v_fnt_typ(a6)
	move.w	v_fnt_typ(a6),d0
	asl.w	#2,d0
	move.l	v_fnt_tab(a6),a0
	move.l	0(a0,d0.w),v_fnt_ad(a6)
	rts

_me:	clr.w	v_fnt_typ(a6)
	move.w	v_fnt_typ(a6),d0
	asl.w	#2,d0
	move.l	v_fnt_tab(a6),a0
	move.l	0(a0,d0.w),v_fnt_ad(a6)
	rts

_ve:	bset.b	#S_CVIS,v_status(a5)
	rts
_vi:	bclr.b	#S_CVIS,v_status(a5)
	rts
_vs:	bset.b	#S_CVIS,v_status(a5)		NOT IMPLEMENTED
	rts

_sc:	move.l	v_cur_ad(a5),v_sav_ad(a6)
	move.w	v_cur_cx(a6),v_sav_cx(a6)
	move.w	v_cur_cy(a6),v_sav_cy(a6)
	bset.b	#S_SCUR,v_status(a5)
	rts
_rc:	btst.b	#S_SCUR,v_status(a5)
	beq	1$
	move.l	v_sav_ad(a6),v_cur_ad(a5)
	move.w	v_sav_cx(a6),v_cur_cx(a6)
	move.w	v_sav_cy(a6),v_cur_cy(a6)
	bclr.b	#S_SCUR,v_status(a5)
1$:	rts

_RA:	bclr.b	#S_WRAP,v_status(a5)
	rts
_SA:	bset.b	#S_WRAP,v_status(a5)
	rts

_vb:	bra	_bel				NOT IMPLEMENTED

****************

	Section	BSS

FIndent	ds.w	1
LineA	ds.l	1
SInfo	ds.l	25

	END
