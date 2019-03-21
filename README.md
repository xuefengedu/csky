# csky

# issue 1
```
root@2064d50385ea:/code/buildroot/output/build/uclibc-bb379dc1fb1544998838e5a3451f1937ea66ab27# vi libc/sysdeps/linux/common/rename.c
root@2064d50385ea:/code/buildroot/output/build/uclibc-bb379dc1fb1544998838e5a3451f1937ea66ab27# cat libc/sysdeps/linux/common/rename.c
/*
 * rename() for uClibc
 *
 * Copyright (C) 2000-2006 Erik Andersen <andersen@uclibc.org>
 *
 * Licensed under the LGPL v2.1, see the file COPYING.LIB in this tarball.
 */

#include <sys/syscall.h>
#include <stdio.h>
#include <unistd.h>

#define __NR_rename 1034

#if defined __NR_renameat && !defined __NR_rename
# include <fcntl.h>
int rename(const char *oldpath, const char *newpath)
{
        return renameat(AT_FDCWD, oldpath, AT_FDCWD, newpath);
}
#else
_syscall2(int, rename, const char *, oldpath, const char *, newpath)
#endif
```

# issue 2
```
root@2064d50385ea:/code/buildroot/output/build/uclibc-bb379dc1fb1544998838e5a3451f1937ea66ab27# cd /code/buildroot
/disk1/code/buildroot# cp output/build/linux-4.16.2/arch/csky/configs/defconfig output/build/linux-4.16.2/arch/csky/configs/gx66xx_defconfig
```

# issue 3
```
 CC      scripts/mod/empty.o
csky-buildroot-linux-uclibcabiv1-gcc.br_real: error: unrecognized command line option ‘-mno-stack-size’; did you mean ‘-mstack-size’?
scripts/Makefile.build:324: recipe for target 'scripts/mod/empty.o' failed
make[3]: *** [scripts/mod/empty.o] Error 1
make[3]: *** Waiting for unfinished jobs....
scripts/Makefile.build:583: recipe for target 'scripts/mod' failed
make[2]: *** [scripts/mod] Error 2
Makefile:566: recipe for target 'scripts' failed
make[1]: *** [scripts] Error 2
make[1]: Leaving directory '/disk1/code/buildroot/output/build/linux-4.16.2'
package/pkg-generic.mk:248: recipe for target '/disk1/code/buildroot/output/build/linux-4.16.2/.stamp_built' failed
make: *** [/disk1/code/buildroot/output/build/linux-4.16.2/.stamp_built] Error 2
root@mytestbox:/disk1/code/buildroot# vi output/build/linux-4.16.2/arch/csky/Makefile
#ifeq ($(CSKYABI),abiv2)
#KBUILD_CFLAGS += -mno-stack-size
#endif
```

# issue 4
```
scripts/mod/devicetable-offsets.c:1:0: error: bad value (ck807f) for -mcpu= switch
 // SPDX-License-Identifier: GPL-2.0

scripts/mod/empty.c:1:0: error: bad value (ck807f) for -mcpu= switch
 /* empty file to figure out endianness / word size */
 
root@mytestbox:/disk1/code/buildroot# vi output/build/linux-4.16.2/arch/csky/Makefile
ifdef CONFIG_CPU_CK860
CPUTYPE = ck860
CSKYABI = abiv2
endif
CPUTYPE = ck610
CSKYABI = abiv1
ifneq ($(CSKYABI),)
MCPU_STR = $(CPUTYPE)$(FPUEXT)$(VDSPEXT)$(TEEEXT)
KBUILD_CFLAGS += -mcpu=$(MCPU_STR)
```

# issue 5
```
root@mytestbox:/disk1/code/buildroot# make
make: Circular /disk1/code/buildroot/output/build/toolchain/.stamp_configured <- toolchain-buildroot dependency dropped.
>>> linux 4.16.2 Building
cp -f board/nationalchip/gx66xx/gx6605s.dts /disk1/code/buildroot/output/build/linux-4.16.2/arch/csky/boot/dts/
PATH="/disk1/code/buildroot/output/host/bin:/disk1/code/buildroot/output/host/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin" BR_BINARIES_DIR=/disk1/code/buildroot/output/images /usr/bin/make -j2 HOSTCC="/usr/bin/gcc" HOSTCFLAGS="" ARCH=csky INSTALL_MOD_PATH=/disk1/code/buildroot/output/target CROSS_COMPILE="/disk1/code/buildroot/output/host/bin/csky-buildroot-linux-uclibcabiv1-" DEPMOD=/disk1/code/buildroot/output/host/sbin/depmod INSTALL_MOD_STRIP=1 -C /disk1/code/buildroot/output/build/linux-4.16.2 uImage
make[1]: Entering directory '/disk1/code/buildroot/output/build/linux-4.16.2'
  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CHK     scripts/mod/devicetable-offsets.h
  CHK     include/generated/bounds.h
make[2]: *** No rule to make target 'arch/csky/boot/dts/.dtb.S', needed by 'arch/csky/boot/dts/.dtb.o'.  Stop.
arch/csky/Makefile:81: recipe for target 'dtbs' failed
make[1]: *** [dtbs] Error 2
make[1]: *** Waiting for unfinished jobs....
  CHK     include/generated/timeconst.h
  CC      arch/csky/kernel/asm-offsets.s
In file included from ./arch/csky/include/asm/thread_info.h:12:0,
                 from ./include/linux/thread_info.h:38,
                 from ./include/asm-generic/current.h:5,
                 from ./arch/csky/include/generated/asm/current.h:1,
                 from ./include/linux/sched.h:12,
                 from arch/csky/kernel/asm-offsets.c:4:
./arch/csky/include/asm/processor.h:22:21: fatal error: abi/fpu.h: No such file or directory
 #include <abi/fpu.h>
                     ^
compilation terminated.
Kbuild:56: recipe for target 'arch/csky/kernel/asm-offsets.s' failed
make[2]: *** [arch/csky/kernel/asm-offsets.s] Error 1
Makefile:1105: recipe for target 'prepare0' failed
make[1]: *** [prepare0] Error 2

#root@mytestbox:/disk1/code/buildroot# cp output/build/linux-4.16.2/arch/csky/boot/dts/gx6605s.dts output/build/linux-4.16.2/arch/csky/boot/dts/.dts
root@mytestbox:/disk1/code/buildroot# vi output/build/linux-4.16.2/arch/csky/Makefile
root@mytestbox:/disk1/code/buildroot# cat output/build/linux-4.16.2/arch/csky/boot/dts/Makefile
dtstree := $(srctree)/$(src)

ifneq '$(CONFIG_CSKY_BUILTIN_DTB)' '""'
builtindtb-y := $(patsubst "%",%,$(CONFIG_CSKY_BUILTIN_DTB))
dtb-y += $(builtindtb-y).dtb
obj-y += $(builtindtb-y).dtb.o
.SECONDARY: $(obj)/$(builtindtb-y).dtb.S
else
dtb-y := $(patsubst $(dtstree)/%.dts,%.dtb, $(wildcard $(dtstree)/*.dts))
endif

always += $(dtb-y)
clean-files += *.dtb *.dtb.S
root@mytestbox:/disk1/code/buildroot# vi output/build/linux-4.16.2/arch/csky/boot/dts/Makefile
root@mytestbox:/disk1/code/buildroot# cat output/build/linux-4.16.2/arch/csky/boot/dts/Makefile
dtstree := $(srctree)/$(src)

ifneq '$(CONFIG_CSKY_BUILTIN_DTB)' '""'
#builtindtb-y := $(patsubst "%",%,$(CONFIG_CSKY_BUILTIN_DTB))
builtindtb-y=gx6605s
dtb-y += $(builtindtb-y).dtb
obj-y += $(builtindtb-y).dtb.o
.SECONDARY: $(obj)/$(builtindtb-y).dtb.S
else
dtb-y := $(patsubst $(dtstree)/%.dts,%.dtb, $(wildcard $(dtstree)/*.dts))
endif

always += $(dtb-y)
clean-files += *.dtb *.dtb.S
```

# issue 6
```
/bin/sh: 1: ./scripts/dtc/dtc: not found
scripts/Makefile.lib:320: recipe for target 'arch/csky/boot/dts/gx6605s.dtb' failed
make[2]: *** [arch/csky/boot/dts/gx6605s.dtb] Error 127
arch/csky/Makefile:81: recipe for target 'dtbs' failed


#root@mytestbox:/disk1/code/buildroot# make dtc
#root@mytestbox:/disk1/code/buildroot# cp output/build/dtc-1.4.4/* /disk1/code/buildroot/output/build/linux-4.16.2/scripts/dtc/

cp -f board/nationalchip/gx66xx/gx6605s.dts /disk1/code/buildroot/output/build/linux-4.16.2/arch/csky/boot/dts/
PATH="/disk1/code/buildroot/output/host/bin:/disk1/code/buildroot/output/host/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin" BR_BINARIES_DIR=/disk1/code/buildroot/output/images /usr/bin/make -j2 HOSTCC="/usr/bin/gcc" HOSTCFLAGS="" ARCH=csky INSTALL_MOD_PATH=/disk1/code/buildroot/output/target -l"/disk1/code/buildroot//output/build/linux-4.16.2/include" CROSS_COMPILE="/disk1/code/buildroot/output/host/bin/csky-buildroot-linux-uclibcabiv1-" DEPMOD=/disk1/code/buildroot/output/host/sbin/depmod INSTALL_MOD_STRIP=1 -C /disk1/code/buildroot/output/build/linux-4.16.2 uImage
find . -name fpu.h
PATH="/disk1/code/buildroot/output/host/bin:/disk1/code/buildroot/output/host/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin" BR_BINARIES_DIR=/disk1/code/buildroot/output/images /usr/bin/make -j2 HOSTCC="/usr/bin/gcc" HOSTCFLAGS="" ARCH=csky INSTALL_MOD_PATH=/disk1/code/buildroot/output/target -l"/disk1/code/buildroot/output/build/linux-4.16.2/include:/disk1/code/buildroot/output/build/linux-4.16.2/arch/csky/abiv2/inc" CROSS_COMPILE="/disk1/code/buildroot/output/host/bin/csky-buildroot-linux-uclibcabiv1-" DEPMOD=/disk1/code/buildroot/output/host/sbin/depmod INSTALL_MOD_STRIP=1 -C /disk1/code/buildroot/output/build/linux-4.16.2 uImage
PATH="/disk1/code/buildroot/output/host/bin:/disk1/code/buildroot/output/host/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin" BR_BINARIES_DIR=/disk1/code/buildroot/output/images /usr/bin/make -j2 HOSTCC="/usr/bin/gcc" HOSTCFLAGS="" ARCH=csky INSTALL_MOD_PATH=/disk1/code/buildroot/output/target -l"/disk1/code/buildroot/output/build/linux-4.16.2/arch/csky/abiv2/inc" CROSS_COMPILE="/disk1/code/buildroot/output/host/bin/csky-buildroot-linux-uclibcabiv1-" DEPMOD=/disk1/code/buildroot/output/host/sbin/depmod INSTALL_MOD_STRIP=1 -C /disk1/code/buildroot/output/build/linux-4.16.2 uImage
PATH="/disk1/code/buildroot/output/host/bin:/disk1/code/buildroot/output/host/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin" BR_BINARIES_DIR=/disk1/code/buildroot/output/images /usr/bin/make -j2 HOSTCC="/usr/bin/gcc" HOSTCFLAGS="" ARCH=csky INSTALL_MOD_PATH=/disk1/code/buildroot/output/target -l"/disk1/code/buildroot/output/build/linux-4.16.2/include" CROSS_COMPILE="/disk1/code/buildroot/output/host/bin/csky-buildroot-linux-uclibcabiv1-" DEPMOD=/disk1/code/buildroot/output/host/sbin/depmod INSTALL_MOD_STRIP=1 -C /disk1/code/buildroot/output/build/linux-4.16.2 uImage
```
