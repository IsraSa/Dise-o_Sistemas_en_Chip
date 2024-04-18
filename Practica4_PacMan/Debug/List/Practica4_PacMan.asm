
;CodeVisionAVR C Compiler V4.02 Evaluation
;(C) Copyright 1998-2024 Pavel Haiduc, HP InfoTech S.R.L.
;http://www.hpinfotech.ro

;Build configuration    : Debug
;Chip type              : ATmega328P
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: Off
;Smart register allocation: Off

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega328P
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC

	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPMCSR=0x37
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x08FF
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.EQU __FLASH_PAGE_SIZE=0x40
	.EQU __EEPROM_PAGE_SIZE=0x04

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETW1P
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETD1P_INC
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	.ENDM

	.MACRO __GETD1P_DEC
	LD   R23,-X
	LD   R22,-X
	LD   R31,-X
	LD   R30,-X
	.ENDM

	.MACRO __PUTDP1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTDP1_DEC
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __CPD10
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	.ENDM

	.MACRO __CPD20
	SBIW R26,0
	SBCI R24,0
	SBCI R25,0
	.ENDM

	.MACRO __ADDD12
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	.ENDM

	.MACRO __ADDD21
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	.ENDM

	.MACRO __SUBD12
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	.ENDM

	.MACRO __SUBD21
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	.ENDM

	.MACRO __ANDD12
	AND  R30,R26
	AND  R31,R27
	AND  R22,R24
	AND  R23,R25
	.ENDM

	.MACRO __ORD12
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	.ENDM

	.MACRO __XORD12
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
	.ENDM

	.MACRO __XORD21
	EOR  R26,R30
	EOR  R27,R31
	EOR  R24,R22
	EOR  R25,R23
	.ENDM

	.MACRO __COMD1
	COM  R30
	COM  R31
	COM  R22
	COM  R23
	.ENDM

	.MACRO __MULD2_2
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	.ENDM

	.MACRO __LSRD1
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	.ENDM

	.MACRO __LSLD1
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	.ENDM

	.MACRO __ASRB4
	ASR  R30
	ASR  R30
	ASR  R30
	ASR  R30
	.ENDM

	.MACRO __ASRW8
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	.ENDM

	.MACRO __LSRD16
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	.ENDM

	.MACRO __LSLD16
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	.ENDM

	.MACRO __CWD1
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	.ENDM

	.MACRO __CWD2
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
	.ENDM

	.MACRO __SETMSD1
	SER  R31
	SER  R22
	SER  R23
	.ENDM

	.MACRO __ADDW1R15
	CLR  R0
	ADD  R30,R15
	ADC  R31,R0
	.ENDM

	.MACRO __ADDW2R15
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	.ENDM

	.MACRO __EQB12
	CP   R30,R26
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __NEB12
	CP   R30,R26
	LDI  R30,1
	BRNE PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12
	CP   R30,R26
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12
	CP   R26,R30
	LDI  R30,1
	BRGE PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12
	CP   R26,R30
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12
	CP   R30,R26
	LDI  R30,1
	BRLT PC+2
	CLR  R30
	.ENDM

	.MACRO __LEB12U
	CP   R30,R26
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __GEB12U
	CP   R26,R30
	LDI  R30,1
	BRSH PC+2
	CLR  R30
	.ENDM

	.MACRO __LTB12U
	CP   R26,R30
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __GTB12U
	CP   R30,R26
	LDI  R30,1
	BRLO PC+2
	CLR  R30
	.ENDM

	.MACRO __CPW01
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	.ENDM

	.MACRO __CPW02
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	.ENDM

	.MACRO __CPD12
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	.ENDM

	.MACRO __CPD21
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	.ENDM

	.MACRO __BSTB1
	CLT
	TST  R30
	BREQ PC+2
	SET
	.ENDM

	.MACRO __LNEGB1
	TST  R30
	LDI  R30,1
	BREQ PC+2
	CLR  R30
	.ENDM

	.MACRO __LNEGW1
	OR   R30,R31
	LDI  R30,1
	BREQ PC+2
	LDI  R30,0
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETW1Z
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CALL __GETD1Z
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETW2X
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __GETD2X
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x3,0x3,0x3,0x2,0x2,0xC,0x0,0x8
	.DB  0x0,0x1,0x0,0x6
_0x22:
	.DB  0xE,0x1D,0x1F,0x1E,0x1F,0x1F,0xE
_0x23:
	.DB  0xE,0x1D,0x1E,0x18,0x1C,0x1F,0xE
_0x24:
	.DB  0xE,0x17,0x1F,0xF,0x1F,0x1F,0xE
_0x25:
	.DB  0xE,0x17,0xF,0x3,0x7,0x1F,0xE
_0x0:
	.DB  0x48,0x20,0x45,0x20,0x4C,0x20,0x4C,0x20
	.DB  0x4F,0x0,0x4D,0x72,0x2E,0x20,0x50,0x61
	.DB  0x63,0x4D,0x61,0x6E,0x0

__GLOBAL_INI_TBL:
	.DW  0x07
	.DW  _PacMan1
	.DW  _0x22*2

	.DW  0x07
	.DW  _PacMan2
	.DW  _0x23*2

	.DW  0x07
	.DW  _PacMan3
	.DW  _0x24*2

	.DW  0x07
	.DW  _PacMan4
	.DW  _0x25*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI

	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x300

	.CSEG
        .equ __lcd_port=0x0b
        .equ __lcd_EN=3
        .equ __lcd_RS=2
        .equ __lcd_D4=4
        .equ __lcd_D5=5
        .equ __lcd_D6=6
        .equ __lcd_D7=7
; 0000 0010        #endasm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_SetupLCD:
; .FSTART _SetupLCD
	SBIW R28,12
	LDI  R24,12
	__GETWRN 22,23,0
	LDI  R30,LOW(_0x3*2)
	LDI  R31,HIGH(_0x3*2)
	RCALL __INITLOCB
	ST   -Y,R16
;	TableSetup -> Y+1
;	i -> R16
; 0000 0014     SBI __lcd_port-1,__lcd_EN
    SBI __lcd_port-1,__lcd_EN
    SBI __lcd_port-1,__lcd_RS
    SBI __lcd_port-1,__lcd_D4
    SBI __lcd_port-1,__lcd_D5
    SBI __lcd_port-1,__lcd_D6
    SBI __lcd_port-1,__lcd_D7
	LDI  R26,LOW(50)
	LDI  R27,0
	RCALL _delay_ms
	LDI  R16,LOW(0)
_0x5:
	CPI  R16,12
	BRSH _0x6
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _delay_ms
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _SendDataBitsLCD
	RCALL _PulseEn
	SUBI R16,-1
	RJMP _0x5
_0x6:
	LDI  R30,LOW(12)
	STS  _cursor,R30
	LDS  R26,_cursor
	RCALL _WriteComandLCD
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND
_PulseEn:
; .FSTART _PulseEn
    SBI __lcd_port,__lcd_EN  // EN=1;
    CBI __lcd_port,__lcd_EN // EN=0;
	RET
; .FEND
_SendDataBitsLCD:
; .FSTART _SendDataBitsLCD
	ST   -Y,R16
	MOV  R16,R26
;	dato -> R16
	SBRS R16,3
	RJMP _0x7
	SBI __lcd_port,__lcd_D7
	RJMP _0x8
_0x7:
	CBI __lcd_port,__lcd_D7
_0x8:
	SBRS R16,2
	RJMP _0x9
	SBI __lcd_port,__lcd_D6
	RJMP _0xA
_0x9:
	CBI __lcd_port,__lcd_D6
_0xA:
	SBRS R16,1
	RJMP _0xB
	SBI __lcd_port,__lcd_D5
	RJMP _0xC
_0xB:
	CBI __lcd_port,__lcd_D5
_0xC:
	SBRS R16,0
	RJMP _0xD
	SBI __lcd_port,__lcd_D4
	RJMP _0xE
_0xD:
	CBI __lcd_port,__lcd_D4
_0xE:
	RJMP _0x2060001
; .FEND
_WriteComandLCD:
; .FSTART _WriteComandLCD
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
;	Comando -> R17
;	tempComando -> R16
	CBI __lcd_port,__lcd_RS
	RJMP _0x2060003
; .FEND
_CharLCD:
; .FSTART _CharLCD
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
;	dato -> R17
;	tempdato -> R16
	SBI __lcd_port,__lcd_RS
_0x2060003:
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _delay_ms
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	MOV  R16,R30
	SWAP R16
	ANDI R16,0xF
	MOV  R26,R16
	RCALL _SendDataBitsLCD
	RCALL _PulseEn
	MOV  R30,R17
	ANDI R30,LOW(0xF)
	MOV  R16,R30
	MOV  R26,R16
	RCALL _SendDataBitsLCD
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _delay_ms
	RCALL _PulseEn
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
_StringLCD:
; .FSTART _StringLCD
	RCALL __SAVELOCR3
	__PUTW2R 17,18
;	Mensaje -> R17,R18
;	i -> R16
	LDI  R16,LOW(0)
_0x10:
	MOV  R30,R16
	SUBI R16,-1
	LDI  R31,0
	ADD  R30,R17
	ADC  R31,R18
	LPM  R26,Z
	RCALL _CharLCD
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R17
	ADC  R31,R18
	LPM  R30,Z
	CPI  R30,0
	BRNE _0x10
	RCALL __LOADLOCR3
	RJMP _0x2060002
; .FEND
;	Mensaje -> R19,R20
;	tiempo -> R17,R18
;	i -> R16
;	Mensaje -> R17,R18
;	i -> R16
_MoveCursor:
; .FSTART _MoveCursor
	ST   -Y,R17
	ST   -Y,R16
	MOV  R16,R26
	LDD  R17,Y+2
;	x -> R17
;	y -> R16
	MOV  R30,R16
	LDI  R31,0
	SBIW R30,0
	BRNE _0x1B
	MOV  R26,R17
	SUBI R26,-LOW(128)
	RJMP _0x52
_0x1B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1C
	MOV  R26,R17
	SUBI R26,-LOW(192)
	RJMP _0x52
_0x1C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1D
	MOV  R26,R17
	SUBI R26,-LOW(148)
	RJMP _0x52
_0x1D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1A
	MOV  R26,R17
	SUBI R26,-LOW(212)
_0x52:
	RCALL _WriteComandLCD
_0x1A:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2060002:
	ADIW R28,3
	RET
; .FEND
_CreateChar:
; .FSTART _CreateChar
	RCALL __SAVELOCR4
	__PUTW2R 17,18
	LDD  R19,Y+4
;	NoCaracter -> R19
;	datos -> R17,R18
;	i -> R16
	MOV  R30,R19
	LSL  R30
	LSL  R30
	LSL  R30
	SUBI R30,-LOW(64)
	MOV  R26,R30
	RCALL _WriteComandLCD
	LDI  R16,LOW(0)
_0x20:
	CPI  R16,8
	BRSH _0x21
	__GETW2R 17,18
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	LD   R26,X
	RCALL _CharLCD
	SUBI R16,-1
	RJMP _0x20
_0x21:
	LDI  R26,LOW(128)
	RCALL _WriteComandLCD
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; .FEND

	.DSEG
;unsigned char read_adc(unsigned char adc_input)
; 0000 0027 {

	.CSEG
_read_adc:
; .FSTART _read_adc
; 0000 0028 ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R16
	MOV  R16,R26
;	adc_input -> R16
	MOV  R30,R16
	ORI  R30,LOW(0x60)
	STS  124,R30
; 0000 0029 // Delay needed for the stabilization of the ADC input voltage
; 0000 002A delay_us(10);
	__DELAY_USB 3
; 0000 002B // Start the AD conversion
; 0000 002C ADCSRA|=(1<<ADSC);
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 002D // Wait for the AD conversion to complete
; 0000 002E while ((ADCSRA & (1<<ADIF))==0);
_0x26:
	LDS  R30,122
	ANDI R30,LOW(0x10)
	BREQ _0x26
; 0000 002F ADCSRA|=(1<<ADIF);
	LDS  R30,122
	ORI  R30,0x10
	STS  122,R30
; 0000 0030 return ADCH;
	LDS  R30,121
_0x2060001:
	LD   R16,Y+
	RET
; 0000 0031 }
; .FEND
;void delayPacMan();
;void main(void)
; 0000 0037 {
_main:
; .FSTART _main
; 0000 0038 // VerifIrico apoyandonos del code Wizard, linea de la 141 a la 150
; 0000 0039 // ADC initialization
; 0000 003A // ADC Clock frequency: 500.000 kHz
; 0000 003B // ADC Auto Trigger Source: Software
; 0000 003C // Only the 8 most significant bits of
; 0000 003D // the AD conversion result are used
; 0000 003E ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(129)
	STS  122,R30
; 0000 003F ADCSRB=(0<<ADTS2) | (0<<ADTS1) | (0<<ADTS0);
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0040 // Digital input buffers on ADC0: Off, ADC1: On, ADC2: On, ADC3: On
; 0000 0041 // ADC4: On, ADC5: On
; 0000 0042 DIDR0=(0<<ADC5D) | (0<<ADC4D) | (0<<ADC3D) | (0<<ADC2D) | (0<<ADC1D) | (1<<ADC0D);
	LDI  R30,LOW(1)
	STS  126,R30
; 0000 0043 
; 0000 0044 SetupLCD();
	RCALL _SetupLCD
; 0000 0045 CreateChar(0, PacMan1); // Pac Man boca cerrada derecha
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(_PacMan1)
	LDI  R27,HIGH(_PacMan1)
	RCALL _CreateChar
; 0000 0046 CreateChar(1, PacMan2); // Pac Man boca abierta derecha
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(_PacMan2)
	LDI  R27,HIGH(_PacMan2)
	RCALL _CreateChar
; 0000 0047 CreateChar(2, PacMan3); // Pac Man boca cerrada izquierda
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(_PacMan3)
	LDI  R27,HIGH(_PacMan3)
	RCALL _CreateChar
; 0000 0048 CreateChar(3, PacMan4); // Pac Man boca abierta izaquierda
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(_PacMan4)
	LDI  R27,HIGH(_PacMan4)
	RCALL _CreateChar
; 0000 0049 PORTC.1 = 1; // Habilita la resistencia de pull-up del boton PC1
	SBI  0x8,1
; 0000 004A while (1)
_0x2B:
; 0000 004B {
; 0000 004C MoveCursor(3,0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _MoveCursor
; 0000 004D StringLCD("H E L L O");
	__POINTW2FN _0x0,0
	RCALL _StringLCD
; 0000 004E MoveCursor(3,1);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _MoveCursor
; 0000 004F StringLCD("Mr. PacMan");
	__POINTW2FN _0x0,10
	RCALL _StringLCD
; 0000 0050 /*
; 0000 0051 while(i<16){
; 0000 0052 MoveCursor(i,0);
; 0000 0053 CharLCD(1);
; 0000 0054 delayPacMan();
; 0000 0055 MoveCursor(i,0);
; 0000 0056 CharLCD(0);
; 0000 0057 delayPacMan();
; 0000 0058 MoveCursor(i,0);
; 0000 0059 CharLCD(' ');
; 0000 005A i++;
; 0000 005B }
; 0000 005C i--;
; 0000 005D while (i>=0)
; 0000 005E {
; 0000 005F MoveCursor(i,1);
; 0000 0060 CharLCD(3);
; 0000 0061 delayPacMan();
; 0000 0062 MoveCursor(i,1);
; 0000 0063 CharLCD(2);
; 0000 0064 delayPacMan();
; 0000 0065 MoveCursor(i,1);
; 0000 0066 CharLCD(' ');
; 0000 0067 i--;
; 0000 0068 }
; 0000 0069 i++;
; 0000 006A while (i<16)
; 0000 006B {
; 0000 006C MoveCursor(i,1);
; 0000 006D CharLCD(1);
; 0000 006E delayPacMan();
; 0000 006F MoveCursor(i,1);
; 0000 0070 CharLCD(0);
; 0000 0071 delayPacMan();
; 0000 0072 MoveCursor(i,1);
; 0000 0073 CharLCD(' ');
; 0000 0074 i++;
; 0000 0075 }
; 0000 0076 i--;
; 0000 0077 while(i>=0){
; 0000 0078 MoveCursor(i,0);
; 0000 0079 CharLCD(3);
; 0000 007A delayPacMan();
; 0000 007B MoveCursor(i,0);
; 0000 007C CharLCD(2);
; 0000 007D delayPacMan();
; 0000 007E MoveCursor(i,0);
; 0000 007F CharLCD(' ');
; 0000 0080 i--;
; 0000 0081 }
; 0000 0082 i++;
; 0000 0083 
; 0000 0084 }
; 0000 0085 */
; 0000 0086 do
_0x2F:
; 0000 0087 {
; 0000 0088 if (i == 16 && j == 0)
	LDS  R26,_i
	CPI  R26,LOW(0x10)
	BRNE _0x32
	LDS  R26,_j
	CPI  R26,LOW(0x0)
	BREQ _0x33
_0x32:
	RJMP _0x31
_0x33:
; 0000 0089 {
; 0000 008A j = 1;
	LDI  R30,LOW(1)
	STS  _j,R30
; 0000 008B i = 15;
	LDI  R30,LOW(15)
	STS  _i,R30
; 0000 008C } else if (i < 0 && j == 1)
	RJMP _0x34
_0x31:
	LDS  R26,_i
	CPI  R26,0
	BRGE _0x36
	LDS  R26,_j
	CPI  R26,LOW(0x1)
	BREQ _0x37
_0x36:
	RJMP _0x35
_0x37:
; 0000 008D {
; 0000 008E j = 0;
	LDI  R30,LOW(0)
	STS  _j,R30
; 0000 008F i = 0;
	STS  _i,R30
; 0000 0090 } else if (i < 0 && j == 0)
	RJMP _0x38
_0x35:
	LDS  R26,_i
	CPI  R26,0
	BRGE _0x3A
	LDS  R26,_j
	CPI  R26,LOW(0x0)
	BREQ _0x3B
_0x3A:
	RJMP _0x39
_0x3B:
; 0000 0091 {
; 0000 0092 i = 0;
	LDI  R30,LOW(0)
	STS  _i,R30
; 0000 0093 j = 1;
	LDI  R30,LOW(1)
	RJMP _0x53
; 0000 0094 } else if (i == 16 && j == 1)
_0x39:
	LDS  R26,_i
	CPI  R26,LOW(0x10)
	BRNE _0x3E
	LDS  R26,_j
	CPI  R26,LOW(0x1)
	BREQ _0x3F
_0x3E:
	RJMP _0x3D
_0x3F:
; 0000 0095 {
; 0000 0096 i = 15;
	LDI  R30,LOW(15)
	STS  _i,R30
; 0000 0097 j = 0;
	LDI  R30,LOW(0)
_0x53:
	STS  _j,R30
; 0000 0098 }
; 0000 0099 
; 0000 009A 
; 0000 009B if (PINC.1 == 0 && j == 0)
_0x3D:
_0x38:
_0x34:
	SBIC 0x6,1
	RJMP _0x41
	LDS  R26,_j
	CPI  R26,LOW(0x0)
	BREQ _0x42
_0x41:
	RJMP _0x40
_0x42:
; 0000 009C {
; 0000 009D MoveCursor(i,j);
	RJMP _0x54
; 0000 009E CharLCD(1);
; 0000 009F delayPacMan();
; 0000 00A0 MoveCursor(i,j);
; 0000 00A1 CharLCD(0);
; 0000 00A2 delayPacMan();
; 0000 00A3 MoveCursor(i,j);
; 0000 00A4 CharLCD(' ');
; 0000 00A5 i++;
; 0000 00A6 } else if (PINC.1 == 0 && j == 1)
_0x40:
	SBIC 0x6,1
	RJMP _0x45
	LDS  R26,_j
	CPI  R26,LOW(0x1)
	BREQ _0x46
_0x45:
	RJMP _0x44
_0x46:
; 0000 00A7 {
; 0000 00A8 MoveCursor(i,j);
	RCALL SUBOPT_0x0
; 0000 00A9 CharLCD(3);
	RCALL SUBOPT_0x1
; 0000 00AA delayPacMan();
; 0000 00AB MoveCursor(i,j);
; 0000 00AC CharLCD(2);
	RCALL SUBOPT_0x2
; 0000 00AD delayPacMan();
; 0000 00AE MoveCursor(i,j);
; 0000 00AF CharLCD(' ');
	RCALL SUBOPT_0x3
; 0000 00B0 i--;
	RJMP _0x55
; 0000 00B1 } else if (PINC.1 == 1 && j == 0)
_0x44:
	SBIS 0x6,1
	RJMP _0x49
	LDS  R26,_j
	CPI  R26,LOW(0x0)
	BREQ _0x4A
_0x49:
	RJMP _0x48
_0x4A:
; 0000 00B2 {
; 0000 00B3 MoveCursor(i,j);
	RCALL SUBOPT_0x0
; 0000 00B4 CharLCD(3);
	RCALL SUBOPT_0x1
; 0000 00B5 delayPacMan();
; 0000 00B6 MoveCursor(i,j);
; 0000 00B7 CharLCD(2);
	RCALL SUBOPT_0x2
; 0000 00B8 delayPacMan();
; 0000 00B9 MoveCursor(i,j);
; 0000 00BA CharLCD(' ');
	RCALL SUBOPT_0x3
; 0000 00BB i--;
	RJMP _0x55
; 0000 00BC } else if (PINC.1 == 1 && j == 1)
_0x48:
	SBIS 0x6,1
	RJMP _0x4D
	LDS  R26,_j
	CPI  R26,LOW(0x1)
	BREQ _0x4E
_0x4D:
	RJMP _0x4C
_0x4E:
; 0000 00BD {
; 0000 00BE MoveCursor(i,j);
_0x54:
	LDS  R30,_i
	ST   -Y,R30
	LDS  R26,_j
	RCALL _MoveCursor
; 0000 00BF CharLCD(1);
	LDI  R26,LOW(1)
	RCALL _CharLCD
; 0000 00C0 delayPacMan();
	RCALL _delayPacMan
; 0000 00C1 MoveCursor(i,j);
	RCALL SUBOPT_0x0
; 0000 00C2 CharLCD(0);
	LDI  R26,LOW(0)
	RCALL _CharLCD
; 0000 00C3 delayPacMan();
	RCALL _delayPacMan
; 0000 00C4 MoveCursor(i,j);
	RCALL SUBOPT_0x0
; 0000 00C5 CharLCD(' ');
	LDI  R26,LOW(32)
	RCALL _CharLCD
; 0000 00C6 i++;
	LDS  R30,_i
	SUBI R30,-LOW(1)
_0x55:
	STS  _i,R30
; 0000 00C7 }
; 0000 00C8 } while (i<16 && i>=0);
_0x4C:
	LDS  R26,_i
	CPI  R26,LOW(0x10)
	BRGE _0x4F
	CPI  R26,0
	BRGE _0x50
_0x4F:
	RJMP _0x30
_0x50:
	RJMP _0x2F
_0x30:
; 0000 00C9 
; 0000 00CA }
	RJMP _0x2B
; 0000 00CB }
_0x51:
	RJMP _0x51
; .FEND
;void delayPacMan(){
; 0000 00CC void delayPacMan(){
_delayPacMan:
; .FSTART _delayPacMan
; 0000 00CD delay_ms(read_adc(0));
	LDI  R26,LOW(0)
	RCALL _read_adc
	LDI  R31,0
	MOVW R26,R30
	RCALL _delay_ms
; 0000 00CE }
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_cursor:
	.BYTE 0x1
_PacMan1:
	.BYTE 0x8
_PacMan2:
	.BYTE 0x8
_PacMan3:
	.BYTE 0x8
_PacMan4:
	.BYTE 0x8
_i:
	.BYTE 0x1
_j:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x0:
	LDS  R30,_i
	ST   -Y,R30
	LDS  R26,_j
	RJMP _MoveCursor

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(3)
	RCALL _CharLCD
	RCALL _delayPacMan
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(2)
	RCALL _CharLCD
	RCALL _delayPacMan
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(32)
	RCALL _CharLCD
	LDS  R30,_i
	SUBI R30,LOW(1)
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	PUSH R26
	PUSH R27
	MOVW R26,R22
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	POP  R27
	POP  R26
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
