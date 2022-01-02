
#define PORTB           0x6000
#define PORTA           0x6001
#define DDRB            0x6002
#define DDRA            0x6003
#define T1CL            0x6004 //T1 Low Order Latches/Counter
#define T1CH            0x6005 //T1 High Order Counter
#define T1LL            0x6006 //T1 Low Order Latches
#define T1LH            0x6007 //T1 High Order Latches
                      //0x6008 = T2 Low Order Latches/Counter
                      //0x6009 = T2 High Order Counter
#define SHIFTREG        0x600A //Shift Register
#define AUXCONTROL      0x600B //Auxiliary Control Register
                      //0x600C = Peripheral Control Register
#define IRQ_FLAG        0x600d //Interrupt Flag Register
#define IRQ_ENABLE_REG  0x600e //Interrupt Enable Register
                      //0x600f = I/O Register A sans Handshake (I do not believe this computer uses Handshake anyway.)

#define BUS_INPUT  0x00
#define BUS_OUTPUT 0xFF
