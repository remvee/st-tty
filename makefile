#
#	STtty Makefile
#

STTTY =	init.bin main.bin statusln.bin aux.bin con.bin conin.bin keymap.bin \
	conout.bin font.bin graphics.bin sound.bin

#	Targets

mystt :	$(STTTY)
	\bin\link.ttp -debug -nolist -with sttty.lnk

sound :	sound.bin
	\bin\link.ttp sound -nolist

aux :	aux.bin
	\bin\link.ttp aux -nolist

#	Dependencies

main.bin aux.bin con.bin : io.i

conout.bin font.bin graphics.bin : conout.i

#	Rules

.asm.bin :; \bin\assem.ttp opt q inc \incl $*
