# Makefile for mmon: MIPS VR4300 mini-monitor
# Copyright 1996, 2003 Eric Smith <eric@brouhaha.com>
# http://www.brouhaha.com/~eric/software/mmon/
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as published
# by the Free Software Foundation.  Note that permission is not granted
# to redistribute this program under the terms of any later version of the
# General Public License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

ifeq ($(MMON64),1)
PREFIX=mips64el-unknown-linux-gnu
CFLAGS_ARCH=-mips64 -mabi=64
LD_SCRIPT=mips64.ldscript
MMON_TEXT_ADDR=0xffffffffbfc00000
MMON_DATA_ADDR=0xffffffffa0000010
RESET_TEXT_ADDR=0xffffffff80008000
else
PREFIX=mipsel-unknown-linux-gnu
CFLAGS_ARCH=-mips32 -mabi=32
LD_SCRIPT=mips.ldscript
MMON_TEXT_ADDR=0xbfc00000
MMON_DATA_ADDR=0xa0000010
RESET_TEXT_ADDR=0x80008000
endif

CC=$(PREFIX)-gcc
LD=$(PREFIX)-ld
CONV=$(PREFIX)-conv
DUMP=$(PREFIX)-objdump
OBJCOPY=$(PREFIX)-objcopy

# for real hardware
CFLAGS=-G 0 $(CFLAGS_ARCH) -nostdinc -fno-pic -mno-abicalls -Wall
# Note - on our target hardware, the same DRAM is aliased between a0000000 and
#        bfc00000.  Data section starts at a0000010 to allow room for the
#        four instructions of the reset exception handler.  Data section must
#        end before a0000200, so size of data section must be <= 496 bytes
MMON_LDFLAGS=-G 0 --script=$(LD_SCRIPT) \
	--entry=reset_exception \
	--omagic \
	--discard-all \
	--strip-all \
	-Map mmon.map \
	-Ttext $(MMON_TEXT_ADDR) -Tdata $(MMON_DATA_ADDR)
RESET_LDFLAGS=-G 0 --script=$(LD_SCRIPT) \
	--entry=start \
	--omagic \
	--discard-all \
	--strip-all \
	-Map mmon.map \
	-Ttext $(RESET_TEXT_ADDR)

IMA=-vp  -f sbin
SRC=-vp  -f srec

DUMPFLAGS=-d

SRECS = mmon0.sr mmon1.sr mmon2.sr mmon3.sr
PROTSRECS = mmon0.pr mmon1.pr mmon2.pr mmon3.pr

all:	bios reset
.PHONY:	all

clean:
	@rm -f mmon mmon.dmp *.elf *.sr *.pr *.o *.map *.bin
	@rm -f reset
	@rm -f mipsel_bios.bin
.PHONY:	clean

floppy:	README $(PROTSRECS)
	mount /fd0
	cp README $(PROTSRECS) /fd0
	umount /fd0
.PHONY:	floppy

mmon:	main.o
	$(LD) -o mmon $(MMON_LDFLAGS) main.o

bios:	mmon	
	$(OBJCOPY) -S -j .text --output-target binary mmon mipsel_bios.bin

reset:	reset.o
	$(LD) -o reset $(RESET_LDFLAGS) reset.o

%.sr:	%
	$(CONV) $(SRC) -o $@ $*

%0.sr %1.sr %2.sr %3.sr: %.sr
	splits $*.sr $*0.sr $*1.sr $*2.sr $*3.sr

%.dmp:	%
	$(DUMP) $(DUMPFLAGS) $* > $*.dmp

%.o:	%.S
	$(CC) -c $(CFLAGS) $*.S


# use awk to insert an S3 record near the end to program the sector protect
# on sector 0 of the AMD 29F040 (when using Data I/O programmer)
%.pr:	%.sr
	awk '/^S7/ { print "S30D000800000100000000000000E9" } { print }' $*.sr >$*.pr

