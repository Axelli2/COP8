.sect   code_can_rx, rom        ; from interrupt
can_rx:
        ; this interrupt is triggerd by RBF, RRTR or RFV
        ; RRTR and RBF are cleared by reading or b's pointing to RXD1
        ; RFV is cleared by reading RTSTAT to A
        ; or executing the equiv. of LD B, #RSTAT; LD A, #xx

                        ld      b, #rx_obj0     ; (*) receive id hi   ; * only with RIAF = 0
        ifbit   7, [b]          ; buffer free
        jp      receive_msg     ; .. yes then receive
        ld      b, #rx_obj1     ; next buffer
        ifbit   7, [b]          ; buffer free
        jp      receive_msg     ; .. then receive msg
        jp      can_rx_exit         ; else exit
receive_msg:
        rbit    7, [b]
        ld      a, rid         ; (*) get received id
        ifne    a, [b]          ; (*) check if accept
        jp      can_rx_exit         ; (*) .. no then exit
        x       a, [b+]
        ld      a, ridl        ; get received IDLC
        x       a, [b]         ; save message
        ifbit   RRTR, RTSTAT   ; received frame remote frame?
        jp      can_rx_rtr     ; yes
        jp      save_data      ; no
      
can_rx_rtr:
        ld      a,[b]          ; remote frame is signed
        or      a,#0F          ; through rdlc = F
        x       a,[b]          ;
        jp      wait_rx        ;      
save_data:
        ld      a,[b+]         ;dummy read -> point rx_data register
        ld      a, RXD1        ; 
        x       a, [b+]
        ld      a, RXD2
        x       a, [b]
        ld      b, #RTSTAT
wait_rx:
        ifbit   RFV, [b]
        jp      rx_done
        ifbit   RERR, TCNTL
        jp      rx_error
        jp      wait_rx
; this is the error routine error interrupt must not be enabled
rx_error:
        ld      b, #rx_obj1
        ifbit   7, [b]
        jp      check_obj0
        jp      end_error
check_obj0:
        ld      b, #rx_obj0
end_error:
        sbit    7, [b]          ; free buffer
        rbit    RERR, TCNTL
rx_done:
can_rx_exit:
        ld      a, RXD1         ; dummy read to clear RBF, RTR
        ld      a, RTSTAT       ; dummy read to clear RFV
        jp      int_end
.endsect

