.PHONY: all clean

DIRS=bin
BLUELABEL=bluelabel
ASM6809=./asm6809/src/asm6809
VASM=./vasm-mirror/vasm6800_oldstyle
ASMFLAGS=-B
OBJ=RRTABLE.o RRX7.o RRG23.o RRB10.o RRC11.o RRDX2.o RRLOG.o\
		RRH11.o RRTEST1.o RRM1.o RRP8.o RRS22.o RRSET.o RRT2.o\
		RRTESTB.o RRTESTC.o RRTEXT.o RRTK4.o  RRELESE6.o bluelabel.o

$(shell mkdir -p $(DIRS))

all: clean bluelabel 

%.o: src/%.ASM
	$(ASM6809) -B -l $<.lst -o bin/$@ src/polyfill.asm $<

%.vo: src/%.ASM
	$(VASM) -Fbin -ast -maxerrors=99 -unsshift -o bin/$@ $<

robotron: $(OBJ)
	$(shell mkdir -p $(DIRS))

	#
	# Build sound
	#./vasm-mirror/vasm6800_oldstyle -Fbin -maxerrors=99 -ast -unsshift src/VSNDRM3.SRC\
	# 		-L bin/vsndrm3.lst -o bin/vsndrm3.o


# Recreate the binaries in the Blue Label ROM board from the objects we assembled in
# the 'robotron' section above. Store them in the 'bluelabel' directory.
#
bluelabel: robotron
	$(shell mkdir -p $(BLUELABEL))
	# robotron.sb1
	./ChainFilesToRom.py bluelabel/robotron.sb1 0x1000\
		bin/RRH11.o,0x0001,0x0000,0x1000,"rrh11"
	# robotron.sb2
	./ChainFilesToRom.py bluelabel/robotron.sb2 0x1000\
		bin/RRH11.o,0x1001,0x0000,0x1000,"rrh11"\
		bin/RRC11.o,0x0001,0x0140,0x0a00,"rrc11"\
		bin/RRB10.o,0x0001,0x0ac0,0x0540,"rrb10"
	# robotron.sb3
	./ChainFilesToRom.py bluelabel/robotron.sb3 0x1000\
		bin/RRB10.o,0x0541,0x0000,0x1814,"rrb10"\
		bin/RRELESE6.o,0x0001,0x06b1,0x0008,"rrelese6"\
		bin/RRG23.o,0x0001,0x06c0,0x0940,"rrg23"
	# robotron.sb4
	./ChainFilesToRom.py bluelabel/robotron.sb4 0x1000\
		bin/RRG23.o,0x0941,0x0000,0x0880,"rrg23"\
		bin/RRP8.o,0x0001,0x0880,0x0780,"rrp8"
	# robotron.sb5
	./ChainFilesToRom.py bluelabel/robotron.sb5 0x1000\
		bin/RRP8.o,0x0781,0x0000,0x0780,"rrp8"\
		bin/RRT2.o,0x0001,0x0140,0x0600,"rrt2"\
		bin/RRDX2.o,0x0001,0x0680,0x0420,"rrdx2"\
		bin/RRTK4.o,0x0001,0x0b00,0x0500,"rrtk4"
	# robotron.sb6
	./ChainFilesToRom.py bluelabel/robotron.sb6 0x1000\
		bin/RRTK4.o,0x0501,0x0000,0x0700,"rrtk4"\
		bin/RRM1.o,0x0001,0x0700,0x0414,"rrm1"\
		bin/RRX7.o,0x0001,0x0b40,0x037a,"rrx7"\
		bin/RRTEXT.o,0x0001,0x0f90,0x0070,"rrtext"
	# robotron.sb7
	./ChainFilesToRom.py bluelabel/robotron.sb7 0x1000\
		bin/RRTEXT.o,0x0071,0x0000,0x1000,"rrtext"\
		bin/RRTESTB.o,0x0001,0x0f00,0x0100,"rrtestb"
	# robotron.sb8
	./ChainFilesToRom.py bluelabel/robotron.sb8 0x1000\
		bin/RRTESTB.o,0x0101,0x0000,0x0980,"rrtestb"\
		bin/RRLOG.o,0x0001,0x07a0,0x0860,"rrlog"
	# robotron.sb9
	./ChainFilesToRom.py bluelabel/robotron.sb9 0x1000\
		bin/RRLOG.o,0x0861,0x0000,0x1000,"rrlog"
	# robotron.sba
	./ChainFilesToRom.py bluelabel/robotron.sba 0x1000\
		bin/RRS22.o,0x0001,0x0000,0x0ede,"RRS22"\
		bin/RRELESE6.o,0xb884,0x0f34,0x0007,"rrelese6"\
		bin/RRTABLE.o,0x0001,0x0f40,0x00c0,"rrtable"
	# robotron.sbb
	./ChainFilesToRom.py bluelabel/robotron.sbb 0x1000\
		bin/RRTABLE.o,0x00c1,0x0000,0x0560,"rrtable"\
		bin/RRTESTC.o,0x0001,0x03d0,0x0630,"RRTESTC"\
		bin/RRSET.o,0x0001,0x09c8,0x0650,"rrset"\
		bin/bluelabel.o,0x0001,0x0ff0,0x0010,"bluelabel"
	# robotron.sbc
	./ChainFilesToRom.py bluelabel/robotron.sbc 0x1000\
		bin/RRTEST1.o,0x0001,0x0000,0x2000,"RRTEST1"\
		bin/bluelabel.o,0x0009,0x0ff8,0x0002,"bluelabel"
	echo "fcdaae01ce27faa7f74124e993c85d2b  bluelabel/robotron.sb1" | md5sum -c
	echo "e76de5c47b993d8b41d4eac84271f608  bluelabel/robotron.sb2" | md5sum -c
	echo "44c196a5bffdae56d9a60dcbd27173c4  bluelabel/robotron.sb3" | md5sum -c
	echo "f733a152670f6c7fa37bbfe1f52ea407  bluelabel/robotron.sb4" | md5sum -c
	echo "81c80d8b439b8a973a946874edd92962  bluelabel/robotron.sb5" | md5sum -c
	echo "fbdfa4382d5f841212724978f2addb88  bluelabel/robotron.sb6" | md5sum -c
	echo "57c98cf4620aec6bfd9db9b85f357e8e  bluelabel/robotron.sb7" | md5sum -c
	echo "7c766ea7d72ff7f27719b51fec60a257  bluelabel/robotron.sb8" | md5sum -c
	echo "e01b35d4f2e09d95b1f5148df0992431  bluelabel/robotron.sb9" | md5sum -c
	echo "ac1a2734f7237b9887b2e4b73aa3984f  bluelabel/robotron.sba" | md5sum -c
	echo "cbffe3e9d036a3b3891c85d0bf8f7c90  bluelabel/robotron.sbb" | md5sum -c
	echo "093fd72883331f68972ec39b72f8110e  bluelabel/robotron.sbc" | md5sum -c
	#echo "56eb72160ed0e78ee26854e64a38d34f  bluelabel/robotron.snd" | md5sum -c


clean:
	-rm bin/*.o
	-rm bin/*.lst
	-rm bluelabel/*
