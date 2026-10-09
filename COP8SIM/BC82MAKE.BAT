REM File:  bc82make.bat -- build BC82MAIN.COD from scratch
ECHO OFF
set tpth=%path%
set path=d:\bcc8;%path%
REM ========== COMPILE ==========
REM +e    Generate Error   File (source_file.ERR)
REM +l    Generate Listing File (source_file.LST)
REM +o    Generate Object  File (source_file.OBJ)
ECHO ON
cop8c  bc82main.c c=bc82main.cod +e e=bc82main.err +l l=bc82main.lst +di d=bc82main.hex
ECHO OFF
REM ========== LINK ==========
ECHO ON
rem Don't use the @ sign for linker command file.
rem 1992 March 18:  Walter Banks recommends not using the linker for now.
rem bclink bc82demo.lnk
ECHO OFF

set path=%tpth%
set tpth=
