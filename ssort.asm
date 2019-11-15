* = $C000
        ;.D SSORT.ML
        ;.O
        ;.S
        JMP DISKIP
        JMP SSORT
DISKIP
        LDX #$02
        JSR $FFC6
        LDY #$05
LOOP1
        JSR $FFE4
        DEY
        BNE LOOP1
LOOP2
        JSR $FFE4
        LDX $90
        BNE THEEND
        CMP $FF
        BNE LOOP2
THEEND
        JMP $FFCC
FINDAD
        CLC
        LDA $2F
        ADC #$09
        STA $FB
        STA $FD
        LDA $30
        ADC #$00
        STA $FC
        STA $FE
        LDA $FB
        STA $A3
        LDA $03FC
        STA $A5
        LDA $FC
        STA $A4
        LDA $03FD
        STA $A6
        LDY #$03
        JSR MULLP
        LDA $A3
        STA $FB
        LDA $A4
        STA $FC
        LDA $FD
        STA $A3
        LDA $03FE
        STA $A5
        LDA $FE
        STA $A4
        LDA $03FF
        STA $A6
        LDY #$03
        JSR MULLP
        LDA $A3
        STA $FD
        LDA $A4
        STA $FE
        RTS
SWAP
        LDY #$00
        JSR MAJORLP
        LDA $FB
        STA $A3
        LDA #$E9
        STA $A5
        LDA $FC
        STA $A4
        LDA #$03
        STA $A6
        LDY #$03
        JSR MULLP
        LDA $A3
        STA $FB
        LDA $A4
        STA $FC
        LDA $FD
        STA $A3
        LDA $FE
        STA $A4
        LDY #$03
        JSR MULLP
        LDA $A3
        STA $FD
        LDA $A4
        STA $FE
        LDY #$00
        JSR MAJORLP
        RTS
MULLP
        CLC
        LDA $A3
        ADC $A5
        STA $A3
        LDA $A4
        ADC $A6
        STA $A4
        DEY
        BNE MULLP
        RTS
MAJORLP
        LDA ($FB),Y
        TAX
        LDA ($FD),Y
        STA ($FB),Y
        TXA
        STA ($FD),Y
        INY
        CPY #$03
        BNE MAJORLP
        RTS
SSORT
        LDA $033C
        STA $033E
        LDA $033D
        STA $033F
LOOPA
        LDA $033F
        LSR
        STA $033F
        LDA $033E
        ROR
        STA $033E
LOOPB
        LDA #$01
        STA $03FC
        STA $03FE
        LDA #$00
        STA $03FD
        STA $03FF
        STA $0340
LOOPC
        LDA $03FE
        STA $03FC
        LDA $03FF
        STA $03FD
        CLC
        LDA $03FE
        ADC $033E
        STA $03FE
        LDA $03FF
        ADC $033F
        STA $03FF
        LDA $03FF
        CMP $033D
        BCC NXTA
        BEQ NXTC
        BCS NXTB
NXTC
        LDA $03FE
        CMP $033C
        BCC NXTA
        BEQ NXTA
        BCS NXTB
NXTA
        JSR COMP
        LDA $FF
        BEQ NXTD
        LDA #$01
        STA $0340
NXTD
        JMP LOOPC
NXTB
        LDA $0340
        BNE LOOPB
        LDA $033F
        BNE LOOPA
        LDA $033E
        CMP #$01
        BEQ OUTA
        BCS LOOPA
OUTA
        RTS
COMP
        JSR FINDAD
        LDA #$00
        STA $FF
        JSR POSTFI
        LDY #$00
        LDA ($FB),Y
        STA $03F0
        LDA ($FD),Y
        STA $03F1
        LDY #$00
CONTCOMP
        LDA ($A3),Y
        CMP ($A5),Y
        BEQ CONTTHIS
        BCS LESSTHAN
GREATER
        LDA #$00
        STA $FF
        RTS
LESSTHAN
        LDA #$01
        STA $FF
        JMP SWAP
CONTTHIS
        INY
        CPY $03F0
        BCS GREATER
        CPY $03F1
        BCS LESSTHAN
        JMP CONTCOMP
POSTFI
        LDY #$01
        LDA ($FB),Y
        STA $A3
        LDA ($FD),Y
        STA $A5
        INY
        LDA ($FB),Y
        STA $A4
        LDA ($FD),Y
        STA $A6
        RTS
