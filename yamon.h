/*
   yamon.h: MIPS VR4300 mini-monitor
   Copyright 1996, 2003 Eric Smith <eric@brouhaha.com>
   http://www.brouhaha.com/~eric/software/mmon/

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License version 2 as published
   by the Free Software Foundation.  Note that permission is not granted
   to redistribute this program under the terms of any other version of the
   General Public License.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#if defined(__mips64)
#define YAMON_BASE	(0xffffffffbfc00500)
#else
#define YAMON_BASE	(0xbfc00500)
#endif

#define YAMON_START		(YAMON_BASE + 0x00)
#define YAMON_PRINT_COUNT	(YAMON_BASE + 0x04)
#define YAMON_FLASH_CACHE	(YAMON_BASE + 0x2c)
#define YAMON_PRINT		(YAMON_BASE + 0x34)
#define YAMON_REG_CPU_ISR	(YAMON_BASE + 0x38)
#define YAMON_UNREG_CPU_ISR	(YAMON_BASE + 0x3c)
#define YAMON_REG_IC_ISR	(YAMON_BASE + 0x40)
#define YAMON_UNREG_IC_ISR	(YAMON_BASE + 0x44)
#define YAMON_REG_ESR		(YAMON_BASE + 0x48)
#define YAMON_UNREG_ESR		(YAMON_BASE + 0x4c)
#define YAMON_GETCHAR		(YAMON_BASE + 0x50)
#define YAMON_SYSCON_READ	(YAMON_BASE + 0x54)

