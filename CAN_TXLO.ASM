.sect   code_can_tx, rom
;
; parametres:
; tx_ptr:       pointer to transmit object
; tx_obj[0:9]   data to transmit
;
; return value:
; tx_ptr = 0xff - bus busy
; tx_ptr = 0x00 - transmission done (interrupt driven)
; tx_ptr = (other value) - transmission in progress
;
; registers used:
; A, X, B
can_tx:
        ifbit   TXPND, RTSTAT   ; check if transmit busy
        jp      tx_busy         ; .. yes then exit
        ld      a, tx_ptr       ; get tx pointer
        x       a, b            ; save to b
        ld      x, #TID         ; point to TID
        ld      a, [b+]         ; get tx_obj[0]; point to tx_obj[1]
        x       a, [x-]         ; .. and save
        ld      a, [b+]         ; get tx_obj[1]; point to tx_obj[2]
        x       a, [x-]         ; .. and save
        ld      a, b            ; get data start value
        x       a, tx_data_start ; save
        ld      a, [b+]         ; point to tx_obj[3]
        ld      a, [b-]         ; get tx_obj[3]; point to tx_obj[2]
        x       a, [x-]         ; save to TXD1
        ld      a, [b+]         ; get tx_obj[3]
        x       a, [x]          ; save to TXD2
        ld      a, b            ; get pointer value
        inc     a
        x       a, tx_ptr       ; save to pointer
        ld      b, #TCNTL
        sbit    TIE, [b]        ; enable transmit interrupt
        sbit    CEIE, [b]       ; enable CAN error interrupt
        sbit    TXSS, [b]       ; start transmission
        ret                     ; exit
tx_busy:
        ld      tx_ptr, #0ff    ; indicate bus busy
        ret                     ; exit
; interrupt driven CAN transmit routine
; assumes A, X and B register can be used
can_txint:
        ld      b, #RTSTAT      ; temporary (!) point to RTSTAT
        ifbit   TXPND, [b]      ; transmission done
        jp      tx_bytes        ; .. no then continue
end_txint:                      ; .. yes then exit
        ld      b, #TXD2        ; point to TXD2
        ld      TXD2, #0        ; dummy write to clear TBE
        ld      tx_ptr, #0      ; indicate transmission done
        rbit    TIE, TCNTL      ; disable interrupt
        jp      int_end         ; global RETI
tx_bytes:
        ld      a, tx_ptr       ; get current pointer
        x       a, x            ; put to x
        ld      b, #TXD1
        ld      a, [x+]         ; get next odd data byte
        x       a, [b+]         ; save to TXD1
        ld      a, [x+]         ; get next even data byte
        x       a, [b]          ; save to TXD2
        ld      a, x            ; get current pointer
        x       a, tx_ptr       ; save pointer
        jp      int_end         ; global RETI
; CAN transmit error routine
; assumes CAN error routine:
;
tx_error:
        ld      a, tx_data_start ; get data start
        x       a, x            ; copy to x
        ld      b, #TXD1         ; point to TXD1
        ld      a, [x+]         ; get 1st data byte
        x       a, [b+]         ; save in TXD1
        ld      a, [x+]         ; get next data byte
        x       a, [b]          ; save in TXD2
        ld      a, x            ; get tx pointer
        x       a, tx_ptr       ; save
        rbit    TERR, TCNTL     ; clear pending
        jp      int_end         ; global RETI
.endsect
;===========================================================================
.sect   code_can_error, rom
; interrupt driven CAN error routine. this code checks
; for standard errors and goes to the respective interrupt
; routine
; an error is assumed "standard" for a transmitter if the
; transmit error bit is set (TERR = 1) and the
; transmit interrupt is enabled (TIE = 1) and the
; transmission is in progress (TXSS = 1)
;
; an error is assumed to be "standard" for a receiver if the
; receive error bit is set (RERR = 1) and the
; receive interrupt is enabled (RIE = 1)
;
can_error:
        ld      b, #TCNTL
        ifbit   TERR, [b]
        jp      tx_error        ; .. then tx errror
        ifbit   RERR, [b]
        jp      rx_error        ; .. then rx error
                        ; else there is no standard error
                        ; but the device could be bus-off
rx_error: ; temp                        
        rbit    TERR, [b]       ; reset TERR pending
        rbit    RERR, [b]       ; reset RERR pending
        jp      int_end         ; golbal RETI
.endsect


