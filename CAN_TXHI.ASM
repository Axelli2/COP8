.sect   code_can_tx, rom

can_tx:
        rc                      ; (*) reset error flag
        ifbit   TXPND, RTSTAT   ; check if transmit busy
        jp      tx_busy         ; .. yes then exit
        ld      b, #tx_obj      ; point to tx_obj[0]
        ld      x, #TID         ; point to TID
        ld      a, [b+]         ; get tx_obj[0]; point to tx_obj[1]
        x       a, [x-]         ; .. and save
        ld      a, [b+]         ; get tx_obj[1]; point to tx_obj[2]
        x       a, [x-]         ; .. and save
        ld      a, [b+]         ; point to tx_obj[3]
        ld      a, [b-]         ; get tx_obj[3]; point to tx_obj[2]
        x       a, [x-]         ; save to TXD1
        ld      a, [b]          ; get tx_obj[3]
        x       a, [x]          ; save to TXD2
tx_done:
        sbit    txss, tcntl     ;set pending transmission
                                ;automatic reset of txss after transmission
        ret                     ; exit without error
tx_busy:
        sc                      ; (*) indicate tx_busy
        ret                     ; (*) exit with error
        ; retsk                 ; optional use retsk instead
                                ; 1st and last 2 lines to skip next
.endsect

