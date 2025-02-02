# x6502

This is a fork of the original x6502 project.

## Desc

Project to compile/test rom files for the 6502 bread board computer featured: <https://eater.net/6502>

## Compile

## Execution

## Interface

```text

┌ LCD ───────────┐
│
│
└────────────────┘
┌ CPU Monitor ───────────────────────┐┌ Memory  8000:81ff ───────────────────────────────────────────────────────┐
│PC: 8000, OP: a9 (LDA)              ││8000  a9 e0 8d 03 60 a9 ff 8d 02 60 a9 00 8d 01 60 8d   ....`....`....`.  │
│ACC-> e0, 224, 11100000             ││8010  00 60 a2 00 bd 59 80 f0 11 8d 00 60 a9 80 8d 01   .`...Y.....`....  │
│X: 00, Y: 00, SP: ff                ││8020  60 29 7f 8d 01 60 e8 4c 14 80 a2 00 bd 5e 80 f0   `)...`.L.....^..  │
│SR: N----I--, cycle: 00000002       ││8030  11 8d 00 60 a9 a0 8d 01 60 29 7f 8d 01 60 e8 4c   ...`....`)...`.L  │
│Clock mode: STEP                    ││8040  2c 80 a9 18 8d 00 60 a9 00 8d 01 60 a9 80 8d 01   ,.....`....`....  │
└────────────────────────────────────┘│8050  60 a9 7f 8d 01 60 4c 42 80 3c 0c 06 01 00 41 42   `....`LB.<....AB  │
┌ Ports Monitor ─────────────────────┐│8060  43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f 50 51 52   CDEFGHIJKLMNOPQR  │
│0-V1PA-7 0-V1PB-7 0-V2PA-7 0-V2PB-7 ││8070  53 54 55 56 57 58 59 5a 31 32 33 34 35 36 37 38   STUVWXYZ12345678  │
│iiiiiiii iiiiiiii                   ││8080  39 30 61 62 63 64 41 42 43 44 45 46 47 48 49 4a   90abcdABCDEFGHIJ  │
│00000000 11111111                   ││8090  4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5a   KLMNOPQRSTUVWXYZ  │
│                                    ││80a0  31 32 33 34 35 36 37 38 39 30 61 62 63 64 00 00   1234567890abcd..  │
│                                    ││80b0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
└────────────────────────────────────┘│80c0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
┌ Bus Trace ─────────────────────────┐│80d0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│Height 63, Width 237                ││80e0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│Bus addr:8000 mode:r value:a9       ││80f0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│Bus addr:8001 mode:r value:e0       ││8100  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││8110  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││8120  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││8130  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││8140  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││8150  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││8160  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││8170  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││8180  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││8190  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││81a0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││81b0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││81c0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││81d0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││81e0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    ││81f0  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................  │
│                                    │└──────────────────────────────────────────────────────────────────────────┘
│                                    │
└────────────────────────────────────┘
```

## Memory Map

```text
0x0000 - 0x3fff = RAM
0x4000 - 0x5fff = Open Bus (Invalid Memory Addresses)
0x6000 = I/O Register B
0x6001 = I/O Register A
0x6002 = Data Direction Register B
0x6003 = Data Direction Register A
0x6004 = T1 Low Order Latches/Counter
0x6005 = T1 High Order Counter
0x6006 = T1 Low Order Latches
0x6007 = T1 High Order Latches
0x6008 = T2 Low Order Latches/Counter
0x6009 = T2 High Order Counter
0x600a = Shift Register
0x600b = Auxiliary Control Register
0x600c = Peripheral Control Register
0x600d = Interrupt Flag Register
0x600e = Interrupt Enable Register
0x600f = I/O Register A sans Handshake (I do not believe this computer uses Handshake anyway.)
0x6010 - 0x7fff - Mirrors of the sixteen VIA registers
0x8000 - 0xffff = ROM
```

## License

x6502 is freely available under the original 4-clause BSD license, the full text of which is included in the LICENSE file.

## Thanks

Thanks to all the other contributors for the original upstream x6502 project!
