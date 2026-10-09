REM File:  C8A1MAKE.BAT -- build C8A1.COF from scratch
ECHO OFF

set tpth=%path%
set path=c:\asmcop8;%path%
set COP=c:\asmcop8

rem 1.  ===== ASSEMBLE =====
rem     Input    c8a1main.asm                   (default '.ASM')
rem              c8a1spin.asm                   (default '.ASM')
rem     Outputs: (/O) relocatable object module (default '.OBJ')
rem              (/L) listing file              (default '.LIS')
ASMCOP c8a1main /SYM_DEBUG /O /L
ASMCOP c8a1spin /SYM_DEBUG /O /L

rem 2.  ===== LINK =====
rem     Inputs   c8a1main.obj                (default '.OBJ')
rem              c8a1spin.obj                (default '.OBJ')
rem     Outputs  COFF absolute/loadable file (default '.COF')
rem              Map file                    (default '.MAP')
rem     (Range (/R) definitions are dummies to allow us
rem      to use all section types -- see 'c8a1spin.asm')
LNCOP c8a1main,c8a1spin /Outputfile=c8a1 /Format=coff /Mapfile=c8a1 @c8a1make.lnk

rem DUMPCOFF c8a1 /e /h (((greater_than)))c8a1.cdp
rem DUMPOBJ  c8a1.cof   (((greater_than)))c8a1.dmp

rem 3.  Then, when you are using iceMASTER (ICE.EXE), select the
rem     'File,Load' pull-down command to load the file 'C8A1.COF'
rem     into the emulator.

set path=%tpth%
set tpth=
set COP=

