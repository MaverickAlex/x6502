;addresses
PORTB             = $6000 ;0x6000 = I/O Register B
PORTA             = $6001 ;0x6001 = I/O Register A
DDRB              = $6002 ;0x6002 = Data Direction Register B
DDRA              = $6003 ;0x6003 = Data Direction Register A
                          ;0x6004 = T1 Low Order Latches/Counter
                          ;0x6005 = T1 High Order Counter
                          ;0x6006 = T1 Low Order Latches
                          ;0x6007 = T1 High Order Latches
                          ;0x6008 = T2 Low Order Latches/Counter
                          ;0x6009 = T2 High Order Counter
SHIFTREG          = $600a ;0x600a = Shift Register
AUXCONTROL        = $600b ;0x600b = Auxiliary Control Register
                          ;0x600c = Peripheral Control Register
IRQ_FLAG          = $600d ;0x600d = Interrupt Flag Register
IRQ_ENABLE_REG    = $600e ;0x600e = Interrupt Enable Register
                          ;0x600f = I/O Register A sans Handshake (I do not believe this computer uses Handshake anyway.)
;flags/data

;irq flags




IRQ_SET    = %10000000  ;Set/Clear 
IRQ_TIMER1 = %01000000  ;Timer1 
IRQ_TIMER2 = %00100000  ;Timer2
IRQ_CB1    = %00010000  ;CB1 
IRQ_CB2    = %00001000  ;CB2
IRQ_SHIFT  = %00000100  ;Shift Register
IRQ_CA1    = %00000010  ;CA1
IRQ_CA2    = %00000001  ;CA2

SHIFT_OUT_CB1 = %00011100 ;1 1 1 Shift out under control of external clock (CB1)




