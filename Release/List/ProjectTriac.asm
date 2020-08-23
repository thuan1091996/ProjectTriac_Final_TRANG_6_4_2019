
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
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
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _count=R4
	.DEF _T_delay=R6
	.DEF _T_Timer1=R8
	.DEF _T_shift_delay=R10
	.DEF _Status=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0xE:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
	.DB  0x80,0x90
_0x4B:
	.DB  0x63,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x1

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  _MA_7SEG
	.DW  _0xE*2

	.DW  0x0A
	.DW  0x04
	.DW  _0x4B*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Project_Triac
;Version : 1.0
;Date    : 7/19/2018
;Author  : Tran Minh Thuan
;Company : VM Machine
;Comments:
;Supported by: Nguyen Van Quyen
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;
;
;//Test Section///////////////////////
;*******************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include "EEPROM.H"

	.CSEG
_eepromWrite:
;	address -> Y+1
;	data -> Y+0
_0x3:
	IN   R30,0x1C
	CPI  R30,0
	BREQ _0x6
	LDI  R30,LOW(2)
	CPI  R30,0
	BRNE _0x7
_0x6:
	RJMP _0x5
_0x7:
	RJMP _0x3
_0x5:
	RCALL SUBOPT_0x0
	LD   R30,Y
	OUT  0x1D,R30
	LDI  R30,LOW(4)
	OUT  0x1C,R30
	LDI  R30,LOW(2)
	OUT  0x1C,R30
	RJMP _0x2000001
_eepromRead:
	ST   -Y,R17
;	address -> Y+1
;	data -> R17
_0x8:
	IN   R30,0x1C
	CPI  R30,0
	BREQ _0xB
	LDI  R30,LOW(2)
	CPI  R30,0
	BRNE _0xC
_0xB:
	RJMP _0xA
_0xC:
	RJMP _0x8
_0xA:
	RCALL SUBOPT_0x0
	LDI  R30,LOW(1)
	OUT  0x1C,R30
	IN   R17,29
	IN   R30,0x1D
	CPI  R30,LOW(0xFF)
	BRLO _0xD
	LDI  R17,LOW(0)
_0xD:
	MOV  R30,R17
	LDD  R17,Y+0
_0x2000001:
	ADIW R28,3
	RET
;
;#define SW_EMER     PINB.3
;#define SW_ON       PINB.3
;#define SW_GIAM     PINC.4
;#define SW_TANG     PINC.5
;#define LED         PORTB.5
;#define SIGNAL      PORTB.1
;#define CLK         PORTC.2 //Chan 11 clock
;#define SDI         PORTC.0 //Chan 14 data
;#define STR         PORTC.1 //Chan 12 chot
;
;
;
;
;/* ------Cac dinh nghia ve chuong trinh va cac bien--------*/
;//-----------------------------------------------------------
;//Dinh nghia cac bien toan cuc
;unsigned int    count=99;           //Bien dem gia tri delay dau tien 99 -> hien thi 00
;unsigned int    T_delay=0;         //Tang 1 moi khi ngat timer0 (100us)
;int             T_Timer1=0;        //Tang 1 moi ngat timer1 de phuc vu kich B1
;unsigned int    T_shift_delay=0;   //Dich de ve diem 0
;unsigned char   Status=1;          //Vua bat nguon thi he thong se hoat dong
;unsigned char   MA_7SEG[10]={0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90};

	.DSEG
;unsigned int    count_pre;
;//Dinh nghia cac chuong trinh
;void INT0_INIT(void);                   //Khoi tao cho ngat ngoai
;void Timer_INIT(void);                  //Khoi tao thong so va ngat cho Timer0
;void GPIO_INIT(void);                   //Khoi tao cac input, output
;void Delay_100us(unsigned int Time);    //Delay 100us ung voi moi don vi
;void Display();                         //Hien thi gia tri ra 7segs
;void CheckSW(void);                     //Doc gia tri nut nhan
;void Power_Check(void);                 //Check nut nhan nguon
;int Wait_Shift(void);                   //Doi de shift toi muc 0
;/*---------------------Interrupt Service Routine-----------*/
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0040 {

	.CSEG
_timer1_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0041     // Reinitialize Timer1 value
; 0000 0042     TCNT1H=0xFE20 >> 8;                 //FFB0-80us - (2^16-80)
	RCALL SUBOPT_0x1
; 0000 0043     TCNT1L=0xFE20 & 0xFF;
; 0000 0044     //------------------------------------------------------//
; 0000 0045     T_shift_delay++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	SBIW R30,1
; 0000 0046     if (Wait_Shift()==1)
	RCALL _Wait_Shift
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xF
; 0000 0047     {
; 0000 0048 
; 0000 0049         if((T_Timer1>=count)&&(T_Timer1<(count+3)))
	__CPWRR 8,9,4,5
	BRLO _0x11
	RCALL SUBOPT_0x2
	BRLO _0x12
_0x11:
	RJMP _0x10
_0x12:
; 0000 004A         {
; 0000 004B             SIGNAL=1;
	SBI  0x18,1
; 0000 004C         }
; 0000 004D         if(T_Timer1>=(count+3))
_0x10:
	RCALL SUBOPT_0x2
	BRLO _0x15
; 0000 004E         {
; 0000 004F             SIGNAL=0;
	CBI  0x18,1
; 0000 0050             TIMSK&=~0x04;
	IN   R30,0x39
	ANDI R30,0xFB
	OUT  0x39,R30
; 0000 0051         }
; 0000 0052         T_Timer1++;
_0x15:
	MOVW R30,R8
	ADIW R30,1
	MOVW R8,R30
; 0000 0053     }
; 0000 0054 };
_0xF:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;////////////////////////////////////////////////////////////////                                                                                                                /*------------Cac chuong trinh ngat----------------------*/
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0057 {// External Interrupt 0 service routine
_ext_int0_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0058     //Reset count value
; 0000 0059     T_shift_delay=0;
	CLR  R10
	CLR  R11
; 0000 005A     T_Timer1=0;
	CLR  R8
	CLR  R9
; 0000 005B     TIMSK|=0x04;                        //Enable Timer1 Overflow interrupt
	IN   R30,0x39
	ORI  R30,4
	OUT  0x39,R30
; 0000 005C     // Reinitialize Timer1 value
; 0000 005D     TCNT1H=0xFE20 >> 8;                 //80us - (2^16-80)
	RCALL SUBOPT_0x1
; 0000 005E     TCNT1L=0xFE20 & 0xFF;
; 0000 005F };
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;////////////////////////////////////////////////////////////////
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0062 {
_timer0_ovf_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0063     /*---------- Timer0 Overflow ISR------------------------------
; 0000 0064     // First Reinitialize timer0 value
; 0000 0065     // Increase count (T_delay) value
; 0000 0066     */
; 0000 0067     TCNT0=0x9D;    //Tinh toan = 0x9D(100), nhung bu sai so nen A0
	LDI  R30,LOW(157)
	OUT  0x32,R30
; 0000 0068     T_delay++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0069     //------------------------------------------------------//
; 0000 006A 
; 0000 006B };
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;/*----------------------------------------------*/
;void main(void)
; 0000 006E {
_main:
; 0000 006F GPIO_INIT();
	RCALL _GPIO_INIT
; 0000 0070 Timer_INIT();
	RCALL _Timer_INIT
; 0000 0071 INT0_INIT();
	RCALL _INT0_INIT
; 0000 0072 count=eepromRead(0);   //Load value from EEPROM\
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x3
	RCALL _eepromRead
	MOV  R4,R30
	CLR  R5
; 0000 0073 #asm("sei")
	sei
; 0000 0074 while (1)
_0x18:
; 0000 0075       {
; 0000 0076         SIGNAL=0;
	CBI  0x18,1
; 0000 0077         Power_Check();
	RCALL _Power_Check
; 0000 0078         CheckSW();
	RCALL _CheckSW
; 0000 0079         Display();
	RCALL _Display
; 0000 007A       }
	RJMP _0x18
; 0000 007B };
_0x1D:
	RJMP _0x1D
;/*--------------Cac chuong trinh con--------------------*/
;void INT0_INIT(void)     //TEST DONE
; 0000 007E {
_INT0_INIT:
; 0000 007F     // External Interrupt(s) initialization
; 0000 0080     // INT0: On
; 0000 0081     // INT0 Mode: Rising Edge
; 0000 0082     // INT1: Off
; 0000 0083     GICR|=(0<<INT1) | (1<<INT0);                                //Enable interrupt
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0084     MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (1<<ISC00);    //Rising edge
	LDI  R30,LOW(3)
	OUT  0x35,R30
; 0000 0085     GIFR=(0<<INTF1) | (1<<INTF0);                               //Clear the flag
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 0086 };
	RET
;//////////////////////////////////////////////////////////
;void Timer_INIT(void)    //TEST DONE
; 0000 0089 {
_Timer_INIT:
; 0000 008A //----------------Timer0--------------------------------//
; 0000 008B     // Timer/Counter 0 initialization
; 0000 008C     // Clock source: System Clock
; 0000 008D     // Clock value: 8000.000 kHz
; 0000 008E     // Prescaler: 8
; 0000 008F     TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);  //Prescaler - 8
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 0090     TCNT0=0x9D;                               // 100us
	LDI  R30,LOW(157)
	OUT  0x32,R30
; 0000 0091 //----------------Timer1--------------------------------//
; 0000 0092     // Timer/Counter 1 initialization
; 0000 0093     // Clock source: System Clock
; 0000 0094     // Clock value: 8000.000 kHz
; 0000 0095     // Mode: Normal top=0xFFFF
; 0000 0096     // OC1A output: Disconnected
; 0000 0097     // OC1B output: Disconnected
; 0000 0098     // Noise Canceler: Off
; 0000 0099     // Input Capture on Falling Edge
; 0000 009A     // Timer Period: 0.8 ms
; 0000 009B     // Timer1 Overflow Interrupt: On
; 0000 009C     // Input Capture Interrupt: Off
; 0000 009D     // Compare A Match Interrupt: Off
; 0000 009E     // Compare B Match Interrupt: Off
; 0000 009F     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00A0     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
	LDI  R30,LOW(1)
	OUT  0x2E,R30
; 0000 00A1     TCNT1H=0xFE20 >> 8;                 //80us - (2^16-80)
	RCALL SUBOPT_0x1
; 0000 00A2     TCNT1L=0xFE20 & 0xff;
; 0000 00A3     ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 00A4     ICR1L=0x00;
	OUT  0x26,R30
; 0000 00A5     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00A6     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00A7     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00A8     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00A9 };
	RET
;///////////////////////////////////////////////////////////
;void GPIO_INIT(void)     //TEST DONE
; 0000 00AC {
_GPIO_INIT:
; 0000 00AD     // Input/Output Ports initialization
; 0000 00AE     // Port B initialization
; 0000 00AF     // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out
; 0000 00B0     DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(35)
	OUT  0x17,R30
; 0000 00B1     // State: Bit7=T Bit6=T Bit5=1 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=0
; 0000 00B2     PORTB=(0<<PORTB7) | (0<<PORTB6) | (1<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(40)
	OUT  0x18,R30
; 0000 00B3 
; 0000 00B4     // Port C initialization
; 0000 00B5     // Function: Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In
; 0000 00B6     DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 00B7     // State: Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=0 Bit1=T Bit0=T
; 0000 00B8     PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(56)
	OUT  0x15,R30
; 0000 00B9     PORTD=0xFF;    // Co tro noi keo len cho chan 5,6,7
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 00BA     DDRD=0x00;    // Cac chan cua PORTD la cac chan INPUT
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 00BB };
	RET
;///////////////////////////////////////////////////////////
;int Wait_Shift(void)     //TEST DONE
; 0000 00BE {
_Wait_Shift:
; 0000 00BF     if(T_shift_delay>=55)            //sau 8*80us ve diem 0
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	CP   R10,R30
	CPC  R11,R31
	BRLO _0x1E
; 0000 00C0     return 1;                       //Ve diem 0
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET
; 0000 00C1     else                            //Chua ve diem 0
_0x1E:
; 0000 00C2     return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; 0000 00C3 };
	RET
;///////////////////////////////////////////////////////////
;void Delay_100us(unsigned int Time)  //TEST DONE
; 0000 00C6 {
_Delay_100us:
; 0000 00C7 /* Create delay function with 100us corresponding to each value */
; 0000 00C8     TCNT0=0x9D;         //Tinh toan = 0x9D, nhung bu sai so nen A0
;	Time -> Y+0
	LDI  R30,LOW(157)
	OUT  0x32,R30
; 0000 00C9     TIMSK|=0x01;        //Cho phep ngat tran timer0
	IN   R30,0x39
	ORI  R30,1
	OUT  0x39,R30
; 0000 00CA     T_delay=0;          //Reset gia tri dem
	CLR  R6
	CLR  R7
; 0000 00CB     while(T_delay<Time);//Chua du
_0x20:
	LD   R30,Y
	LDD  R31,Y+1
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x20
; 0000 00CC     TIMSK&=~0x01;       //Du thoi gian, tat ngat tran timer0
	IN   R30,0x39
	ANDI R30,0xFE
	OUT  0x39,R30
; 0000 00CD };
	ADIW R28,2
	RET
;///////////////////////////////////////////////////////////
;void CheckSW(void)  //TEST DONE
; 0000 00D0 {
_CheckSW:
; 0000 00D1     if(!SW_GIAM)
	SBIC 0x13,4
	RJMP _0x23
; 0000 00D2     {
; 0000 00D3         Delay_100us(2500);
	RCALL SUBOPT_0x4
; 0000 00D4         if(count>0) count--;
	CLR  R0
	CP   R0,R4
	CPC  R0,R5
	BRSH _0x24
	MOVW R30,R4
	SBIW R30,1
	MOVW R4,R30
; 0000 00D5         else        count=0;
	RJMP _0x25
_0x24:
	CLR  R4
	CLR  R5
; 0000 00D6     }
_0x25:
; 0000 00D7     if(!SW_TANG)
_0x23:
	SBIC 0x13,5
	RJMP _0x26
; 0000 00D8     {
; 0000 00D9         Delay_100us(2500);
	RCALL SUBOPT_0x4
; 0000 00DA         if(count<99) count++;
	RCALL SUBOPT_0x5
	CP   R4,R30
	CPC  R5,R31
	BRSH _0x27
	MOVW R30,R4
	ADIW R30,1
	RJMP _0x4A
; 0000 00DB         else         count=99;
_0x27:
	RCALL SUBOPT_0x5
_0x4A:
	MOVW R4,R30
; 0000 00DC     }
; 0000 00DD     if(count!=count_pre)
_0x26:
	LDS  R30,_count_pre
	LDS  R31,_count_pre+1
	CP   R30,R4
	CPC  R31,R5
	BREQ _0x29
; 0000 00DE     {
; 0000 00DF 
; 0000 00E0         DDRB&=~0x02;
	CBI  0x17,1
; 0000 00E1         Delay_100us(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x6
; 0000 00E2         DDRB|=0x02;
	SBI  0x17,1
; 0000 00E3         Delay_100us(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x6
; 0000 00E4         eepromWrite(0,count); //Store count in EEPROM, EEPROM have only 100,000 write
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x3
	ST   -Y,R4
	RCALL _eepromWrite
; 0000 00E5     }
; 0000 00E6     count_pre=count;
_0x29:
	__PUTWMRN _count_pre,0,4,5
; 0000 00E7 };
	RET
;///////////////////////////////////////////////////////////
;void Display()  //TEST DONE
; 0000 00EA {
_Display:
; 0000 00EB     unsigned char i,Q;
; 0000 00EC     unsigned char Dvi,Chuc;
; 0000 00ED     Dvi=MA_7SEG[(99-count)%10];
	RCALL __SAVELOCR4
;	i -> R17
;	Q -> R16
;	Dvi -> R19
;	Chuc -> R18
	RCALL SUBOPT_0x7
	RCALL __MODW21U
	SUBI R30,LOW(-_MA_7SEG)
	SBCI R31,HIGH(-_MA_7SEG)
	LD   R19,Z
; 0000 00EE     Chuc=MA_7SEG[(99-count)/10];
	RCALL SUBOPT_0x7
	RCALL __DIVW21U
	SUBI R30,LOW(-_MA_7SEG)
	SBCI R31,HIGH(-_MA_7SEG)
	LD   R18,Z
; 0000 00EF     Q=Chuc; for(i=0;i<8;i++){SDI=Q&0x80;CLK=0;CLK=1;Q<<=1;}
	MOV  R16,R18
	LDI  R17,LOW(0)
_0x2B:
	CPI  R17,8
	BRSH _0x2C
	SBRC R16,7
	RJMP _0x2D
	CBI  0x15,0
	RJMP _0x2E
_0x2D:
	SBI  0x15,0
_0x2E:
	CBI  0x15,2
	SBI  0x15,2
	LSL  R16
	SUBI R17,-1
	RJMP _0x2B
_0x2C:
; 0000 00F0     Q=Dvi; for(i=0;i<8;i++){SDI=Q&0x80;CLK=0;CLK=1;Q<<=1;}
	MOV  R16,R19
	LDI  R17,LOW(0)
_0x34:
	CPI  R17,8
	BRSH _0x35
	SBRC R16,7
	RJMP _0x36
	CBI  0x15,0
	RJMP _0x37
_0x36:
	SBI  0x15,0
_0x37:
	CBI  0x15,2
	SBI  0x15,2
	LSL  R16
	SUBI R17,-1
	RJMP _0x34
_0x35:
; 0000 00F1     STR=0; STR=1;
	CBI  0x15,1
	SBI  0x15,1
; 0000 00F2 };
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
;///////////////////////////////////////////////////////////
;void Power_Check(void) //Test done
; 0000 00F5 {
_Power_Check:
; 0000 00F6 /* Check the power button to allow system operating normally
; 0000 00F7 SW_EMER - Emergency switch if this button was switched on (=0), lock the output signal
; 0000 00F8 SW_ON - On/Off button, if this button was pressed toggle on/off the output signal
; 0000 00F9 Status =0 -> Signal was disable
; 0000 00FA Status = 1 -> Signal was enable
; 0000 00FB */
; 0000 00FC     if(SW_EMER==0)                          //LOCK
	SBIC 0x16,3
	RJMP _0x40
; 0000 00FD         {
; 0000 00FE             Status=0;                       //Signal disable
	CLR  R13
; 0000 00FF             Delay_100us(5000);              //Wait for bound
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	RCALL SUBOPT_0x6
; 0000 0100             if(SW_EMER==1)                  //UNLOCK
	SBIS 0x16,3
	RJMP _0x41
; 0000 0101             Status=1;                       //Signal enable
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 0102         }
_0x41:
; 0000 0103     else
	RJMP _0x42
_0x40:
; 0000 0104         {
; 0000 0105             if(SW_ON==0)                    //Switch press toggle the power
	SBIC 0x16,3
	RJMP _0x43
; 0000 0106                 {
; 0000 0107                     Delay_100us(5000);      //Wait for bound
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	RCALL SUBOPT_0x6
; 0000 0108                     Status=(Status+1)%2;    //Toggle
	MOV  R30,R13
	LDI  R31,0
	ADIW R30,1
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __MODW21
	MOV  R13,R30
; 0000 0109                 }
; 0000 010A         }
_0x43:
_0x42:
; 0000 010B     if(Status==1) {LED=0; DDRB|=0x02;}      //System ON, on LED and enable SIGNAL
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0x44
	CBI  0x18,5
	SBI  0x17,1
; 0000 010C     else          {LED=1; DDRB&=~0x02;}     //System OFF, Off LED and disable SIGNAL
	RJMP _0x47
_0x44:
	SBI  0x18,5
	CBI  0x17,1
_0x47:
; 0000 010D };
	RET
;/*--------------------------------------------------------*/

	.DSEG
_MA_7SEG:
	.BYTE 0xA
_count_pre:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	OUT  0x1E+1,R31
	OUT  0x1E,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(254)
	OUT  0x2D,R30
	LDI  R30,LOW(32)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	MOVW R30,R4
	ADIW R30,3
	CP   R8,R30
	CPC  R9,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(2500)
	LDI  R31,HIGH(2500)
	RCALL SUBOPT_0x3
	RJMP _Delay_100us

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(99)
	LDI  R31,HIGH(99)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x3
	RJMP _Delay_100us

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	RCALL SUBOPT_0x5
	SUB  R30,R4
	SBC  R31,R5
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

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

;END OF CODE MARKER
__END_OF_CODE:
