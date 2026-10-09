ECHO OFF
REM
REM check for valid  file paramater
REM
IF "%1" == "" GOTO NOPARM
IF NOT EXIST %1.LM GOTO NOFILE
REM
REM Build input file for COMMC
REM
ECHO Beginning to build COMMC input file
REM goto COMM conversation mode
ECHO C > LOAD64.MOL
REM goto MOLE Monitor
ECHO @M >> LOAD64.MOL
REM clear all breakpoints
ECHO CL >> LOAD64.MOL
REM resrt HPC
ECHO R >> LOAD64.MOL
REM setup MOLE memory MAP for down loading
ECHO MAP 0,1,2,3 OFF >> LOAD64.MOL
ECHO MAP 4,5,6,7 OFF >> LOAD64.MOL
ECHO MAP 8,9,10,11 OFF >> LOAD64.MOL
ECHO MAP 12,13,14,15 ON >> LOAD64.MOL
REM goto MOLE COMM
ECHO @C >> LOAD64.MOL
REM escape from host conversation mode
ECHO  >> LOAD64.MOL
REM
REM send first block of code to shared memory
ECHO S %1.LM SH $R 200/3FFF $OF C000 >> LOAD64.MOL
REM got to host COMM conversation mode
ECHO C >> LOAD64.MOL
REM got to MOLE Monitor
ECHO @M >> LOAD64.MOL
REM move code form shared memory to external
REM  (i.e. target system's memory)memory
ECHO X C200/FFFF,200 >> LOAD64.MOL
REM goto MOLE COMM mode
ECHO @C >> LOAD64.MOL
REM escape from host conversation mode
ECHO  >> LOAD64.MOL
REM
REM repeat above steps form block 2
ECHO S %1.LM SH $R 4000/7FFF $OF 8000 >> LOAD64.MOL
ECHO C >> LOAD64.MOL
ECHO @M >> LOAD64.MOL
ECHO X C000/FFFF,4000 >> LOAD64.MOL
ECHO @C >> LOAD64.MOL
ECHO  >> LOAD64.MOL
REM repeat above steps form block 3
ECHO S %1.LM SH $R 8000/BFFF $OF 4000 >> LOAD64.MOL
ECHO C >> LOAD64.MOL
ECHO @M >> LOAD64.MOL
ECHO X C000/FFFF,8000 >> LOAD64.MOL
ECHO @C >> LOAD64.MOL
ECHO  >> LOAD64.MOL
REM repeat above steps form block 2
ECHO S %1.LM SH $R C000/FFFF >> LOAD64.MOL
ECHO C >> LOAD64.MOL
ECHO @M >> LOAD64.MOL
ECHO X C000/FFFF,C000 >> LOAD64.MOL
REM
REM turn MOLE MAP off
ECHO MAP 12,13,14,15 OFF >> LOAD64.MOL
REM reset HPC
ECHO R >> LOAD64.MOL
REM escape from host conversation mode
ECHO  >> LOAD64.MOL
REM exit form host COMMC
ECHO @ >> LOAD64.MOL
REM now execute COMM with the file just produced
REM  and put output in LOG file
ECHO Begining to send code to MOLE
REM delete the COMM input file to keep disk relatively clean
ECHO Loading done.
GOTO END
:NOPARM
ECHO usage: LOAD64 file_name
GOTO END
:NOFILE
ECHO file "%1.LM" does not exist.
:END
ECHO ON
