* vi:ts=8
*
****************
	XDEF	SndBel,SndNoise

	INCLUDE	'xbios.i'
	INCLUDE	'gemdos.i'

	Section	TEXT

	Supexec	#SndNoise
	Pterm0

SndBel	lea	BelDat,a0
	bra	Snd
SndNoise:
	lea	NoiseDat,a0
	bra	Snd

Snd:
1$:	move.b	(a0)+,d0
	bmi	2$
	move.b	d0,$ff8800
	move.b	(a0)+,$ff8802
	bra	1$
2$:	rts

****************

	Section	Data

BelDat:	dc.b	0,$77,1,0
	dc.b	11,0,12,25
	dc.b	13,0
	dc.b	7,%11111110
	dc.b	8,$10
	dc.b	-1

NoiseDat:
	dc.b	6,16
	dc.b	11,0,12,25
	dc.b	13,0
	dc.b	7,%11101111
	dc.b	9,$10
	dc.b	-1

	END
