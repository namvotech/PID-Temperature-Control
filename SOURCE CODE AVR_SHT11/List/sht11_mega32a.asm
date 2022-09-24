
;CodeVisionAVR C Compiler V2.05.6 
;(C) Copyright 1998-2012 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega32A
;Program type           : Application
;Clock frequency        : 16.000000 MHz
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
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#pragma AVRPART ADMIN PART_NAME ATmega32A
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _set=R5
	.DEF _mode_temp=R4
	.DEF _mode_humi=R7
	.DEF _set_temp_int=R8
	.DEF _set_humi_int=R10
	.DEF _set_temp_int_ok=R12
	.DEF __lcd_x=R6

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
	JMP  _timer2_ovf_isr
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

_character_0:
	.DB  0x10,0x18,0x1C,0x1E,0x1C,0x18,0x10,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1,0x1,0x0,0x1

_0x3:
	.DB  0x0,0x0,0x4
_0x4:
	.DB  0x0,0x0,0x5
_0x5:
	.DB  0x0,0x0,0x4
_0x6:
	.DB  0x0,0x0,0x5
_0x7:
	.DB  0x0,0x60,0x6A,0x47
_0x8:
	.DB  0x0,0x0,0xFA,0x44
_0x9:
	.DB  0x0,0x0,0x80,0x3F
_0xA:
	.DB  0x0,0x60,0x6A,0x47
_0xB:
	.DB  0x0,0x0,0xFA,0x44
_0xC:
	.DB  0x0,0x0,0x80,0x3F
_0x0:
	.DB  0x44,0x6F,0x20,0x41,0x6E,0x20,0x4D,0x6F
	.DB  0x6E,0x20,0x48,0x6F,0x63,0x0,0x54,0x68
	.DB  0x75,0x79,0x20,0x44,0x75,0x6F,0x6E,0x67
	.DB  0x20,0x31,0x32,0x31,0x34,0x31,0x30,0x34
	.DB  0x31,0x0,0x50,0x68,0x75,0x6F,0x6E,0x67
	.DB  0x20,0x56,0x6F,0x20,0x20,0x31,0x32,0x31
	.DB  0x34,0x31,0x31,0x37,0x34,0x0,0x44,0x61
	.DB  0x6E,0x67,0x20,0x4B,0x68,0x6F,0x69,0x20
	.DB  0x54,0x61,0x6F,0x20,0x53,0x48,0x54,0x2E
	.DB  0x2E,0x2E,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x43,0x74
	.DB  0x72,0x6C,0x3A,0x20,0x4F,0x6E,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x43,0x74,0x72,0x6C,0x3A
	.DB  0x20,0x4F,0x66,0x66,0x0,0x54,0x65,0x6D
	.DB  0x70,0x3A,0x0,0x43,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x48,0x75,0x6D,0x69,0x3A
	.DB  0x0,0x20,0x25,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x53,0x54,0x0,0x43,0x20
	.DB  0x0,0x53,0x48,0x0
_0x2020003:
	.DB  0x80,0xC0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x03
	.DW  _int_temp
	.DW  _0x3*2

	.DW  0x03
	.DW  _int_humi
	.DW  _0x4*2

	.DW  0x03
	.DW  _int_temp_ok
	.DW  _0x5*2

	.DW  0x03
	.DW  _int_humi_ok
	.DW  _0x6*2

	.DW  0x04
	.DW  _kp
	.DW  _0x7*2

	.DW  0x04
	.DW  _kd
	.DW  _0x8*2

	.DW  0x04
	.DW  _ki
	.DW  _0x9*2

	.DW  0x04
	.DW  _humi_kp
	.DW  _0xA*2

	.DW  0x04
	.DW  _humi_kd
	.DW  _0xB*2

	.DW  0x04
	.DW  _humi_ki
	.DW  _0xC*2

	.DW  0x0E
	.DW  _0x76
	.DW  _0x0*2

	.DW  0x14
	.DW  _0x76+14
	.DW  _0x0*2+14

	.DW  0x14
	.DW  _0x76+34
	.DW  _0x0*2+34

	.DW  0x15
	.DW  _0x76+54
	.DW  _0x0*2+54

	.DW  0x15
	.DW  _0x76+75
	.DW  _0x0*2+75

	.DW  0x15
	.DW  _0x76+96
	.DW  _0x0*2+96

	.DW  0x06
	.DW  _0x76+117
	.DW  _0x0*2+117

	.DW  0x08
	.DW  _0x76+123
	.DW  _0x0*2+123

	.DW  0x06
	.DW  _0x76+131
	.DW  _0x0*2+131

	.DW  0x0A
	.DW  _0x76+137
	.DW  _0x0*2+137

	.DW  0x03
	.DW  _0x76+147
	.DW  _0x0*2+153

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : DO NHIET DO VA DO AM SHT11
;Version : 2
;Date    : 12/6/2014
;Author  : Minh Nam
;Company : ---
;Comments:
;
;
;Chip type               : ATmega32A
;Program type            : Application
;AVR Core Clock frequency: 8.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;#include <mega32a.h>
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
;#include <math.h>
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;
;#include <declare.c>
;
;//SHT11 io Define
;#define SHT_CLK         PORTD.2
;#define SHT_DATA_IN     PIND.3
;#define SHT_DATA_OUT    PORTD.3
;
;#define SHT_DDR_CLK     DDRD.2
;#define SHT_DDR_DATA    DDRD.3
;
;#define DDROUT		1
;#define DDRIN		0
;
;//Button Define
;#define SETTING     PINA.7
;#define UP          PINA.6
;#define DOWN        PINA.3
;#define OK          PINA.5
;#define MODE        PINA.2
;#define CANCEL      PINA.4
;
;#define SPEAK_PORT  PORTB
;#define SPEAK_PIN   4
;#define SPEAK       PORTB.4
;
;#define true        1
;#define false       0
;
;//PWM define
;#define pwm_a       OCR1A    //Dieu khien nhiet do
;#define pwm_b       OCR1B    //Dieu khien do am
;
;//#define CTRL1       PORTD.5
;//#define CTRL2       PORTD.4
;//65535=0xffff; 20000=0x4e20, 10000=0x2710 ;1000=0x03e8
;//#define icr1        (icr1_h<<8)|icr1_l
;#define icr1        10000
;
;//Edge define
;#define not_bit(port,pin)   (port.pin=~port.pin)
;#define set_bit(port,pin)   (port)|= (1<<(pin))
;#define clr_bit(port,pin)   (port)&=~(1<<(pin))
;#define falling_edge(port, pin) do {\
;                                set_bit(port,pin);\
;                                delay_ms(40);\
;                                clr_bit(port,pin);\
;                            } while (0)
;#define rising_edge(port, pin) do {\
;                                clr_bit(port,pin);\
;                                set_bit(port,pin);\
;                            } while (0)
;
;//Define kieu du lieu
;/*    Kieu So Nguyen Co Dau    */
;typedef   signed           char int8_t;
;typedef   signed           int int16_t;
;typedef   signed long      int int32_t;
;
;/*    Kieu So Nguyen Khong Dau */
;typedef   unsigned         char uint8_t;
;typedef   unsigned         int  uint16_t;
;typedef   unsigned long    int  uint32_t;
;/*    Kieu So Thuc */
;typedef   float            float32_t;
;
;//Nap 1 lan
;//Mang luu du lieu cho CGRam LCD
;flash unsigned char character_0[]={0x10,0x18,0x1c,0x1e,0x1c,0x18,0x10,0x00};
;
;#define delay_bt    1500
;// Khai bao bien su dung
;unsigned char set=1,mode_temp=1,mode_humi=1;
;int int_temp[4]={0,4,0,0},int_humi[4]={0,5,0,0};

	.DSEG
;int int_temp_ok[4]={0,4,0,0},int_humi_ok[4]={0,5,0,0};
;unsigned int set_temp_int, set_humi_int, set_temp_int_ok, set_humi_int_ok;
;float set_temp, set_humi;
;float set_temp_ok, set_humi_ok;
;unsigned  int i=0,s, delay;
;float nhiet_do,do_am;
;bit state,dao_pwm=0;
;//================================//
;/***********************************
;Bien Luu EEPROM
;******************************/
;eeprom int eep_temp_ok[4], eep_humi_ok[4];
;
;/*********************************
;PID variable
;*****************************/
;#define sampling_time       64   //ms
;#define inv_sampling_time   6.25     //s=1/sampling_time*1000
;#define pwm_period          5000
;int delay_sampling;
;float err, pre_err=0;
;float kp=60000, kd=2000, ki=1;
;
;//kp=30000, kd=10000, ki=1 (ss=0.2);
;//kp=40000, kd=1000, ki=1(On dinh);
;//kp=40000, kd=15000, ki=1 (On dinh hon, dap ung cham hon);
;//kp=50000, kd=1000, ki=1; pwm_period          5000
;
;float p_part=0, i_part=0,pre_i_part=0, d_part=0;
;float output;
;
;/*********************************
;PID Humi variable
;*****************************/
;#define humi_sampling_time       64   //ms
;#define humi_inv_sampling_time   6.25     //s=1/sampling_time*1000
;#define humi_pwm_period          5000
;
;float humi_err, humi_pre_err=0;
;float humi_kp=60000, humi_kd=2000, humi_ki=1;
;
;//kp=30000, kd=10000, ki=1 (ss=0.2);
;//kp=40000, kd=1000, ki=1(On dinh);
;//kp=40000, kd=15000, ki=1 (On dinh hon, dap ung cham hon);
;//kp=50000, kd=1000, ki=1; pwm_period          5000
;
;float humi_p_part=0, humi_i_part=0,humi_pre_i_part=0, humi_d_part=0;
;float humi_output;
;#include <sub_programs.c>
;//=======================
;//void lcd_putnum_5(unsigned int number)
;//{
;//    unsigned char chucnghin,nghin,tram,chuc,donvi;
;//    chucnghin=number/10000;
;//    nghin=number%10000/1000;
;//    tram=number%1000/100;
;//    chuc=number%100/10;
;//    donvi=number%10;
;//
;//    //Xoa so 0 vo nghia
;//    if(chucnghin==0)
;//    {
;//        lcd_putchar(0x20);
;//        if(nghin==0)
;//        {
;//            lcd_putchar(0x20);
;//            if (tram==0)
;//            {
;//                lcd_putchar(0x20);
;//                if (chuc==0)    lcd_putchar(0x20);
;//                else            lcd_putchar(chuc+48);
;//            }
;//            else
;//            {
;//                lcd_putchar(tram+48);
;//                lcd_putchar(chuc+48);
;//            }
;//        }
;//        else
;//        {
;//            lcd_putchar(nghin+48);
;//            lcd_putchar(tram+48);
;//            lcd_putchar(chuc+48);
;//        }
;//    }
;//    else
;//    {
;//        lcd_putchar(chucnghin+48);
;//        lcd_putchar(nghin+48);
;//        lcd_putchar(tram+48);
;//        lcd_putchar(chuc+48);
;//    }
;//    lcd_putchar(donvi+48);
;//}
;/************************
;*************************/
;//====================
;//void lcd_putnum_ki (float number)
;//{
;//        unsigned int nguyen, thap_phan;
;//        unsigned int chuc, donvi;
;//        unsigned int tp_donvi;
;//
;//        nguyen = number;
;//        number = (number - nguyen)*10;
;//        thap_phan = number;
;//
;//        chuc=nguyen/10;
;//        donvi=nguyen%10;
;//        tp_donvi=thap_phan;
;//
;//        //Xoa so 0 vo nghia
;//
;//        if      (chuc==0)  lcd_putchar(0x20);
;//        else               lcd_putchar(chuc+48);
;//        lcd_putchar(donvi+48);
;//        lcd_putchar('.');
;//        lcd_putchar(tp_donvi+48);
;//}
;//=================
;/**********************
;************************/
;void lcd_putnum_nguyen(unsigned int number)
; 0000 001E {

	.CSEG
_lcd_putnum_nguyen:
;    unsigned int tram, chuc, donvi;
;    tram=number/100;
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
;	number -> Y+6
;	tram -> R16,R17
;	chuc -> R18,R19
;	donvi -> R20,R21
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R16,R30
;    chuc=(number%100)/10;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x0
	MOVW R18,R30
;    donvi=number%10;
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL SUBOPT_0x1
	MOVW R20,R30
;
;    if(tram==0)
	MOV  R0,R16
	OR   R0,R17
	BRNE _0xD
;    {
;        lcd_putchar(0x5f);
	LDI  R26,LOW(95)
	CALL _lcd_putchar
;        if(chuc==0) lcd_putchar(0x5f);
	MOV  R0,R18
	OR   R0,R19
	BRNE _0xE
	LDI  R26,LOW(95)
	RJMP _0x1DB
;        else lcd_putchar(chuc+48);
_0xE:
	MOV  R26,R18
	SUBI R26,-LOW(48)
_0x1DB:
	CALL _lcd_putchar
;    }
;    else
	RJMP _0x10
_0xD:
;    {
;        lcd_putchar(tram+48);
	MOV  R26,R16
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
;        lcd_putchar(chuc+48);
	MOV  R26,R18
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
;    }
_0x10:
;    lcd_putchar(donvi+48);
	MOV  R26,R20
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
;}
	CALL __LOADLOCR6
	RJMP _0x20A0004
;//========================
;void lcd_putnum_thap_phan_set(unsigned int number)
;{
_lcd_putnum_thap_phan_set:
;     unsigned char tp_donvi;
;     tp_donvi=number%10;
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	number -> Y+1
;	tp_donvi -> R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL SUBOPT_0x1
	MOV  R17,R30
;     lcd_putchar(tp_donvi+48);
	MOV  R26,R17
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
;}
	LDD  R17,Y+0
	RJMP _0x20A0007
;//====================
;void lcd_display_sensor (float number)
;{
_lcd_display_sensor:
;        unsigned int nguyen, thap_phan;
;        unsigned int tram, chuc, donvi;
;        unsigned int tp_chuc, tp_donvi;
;
;//        if(number<0)
;//        {
;//            number=-number;
;//            lcd_putchar(0x2d);
;//        }
;//        else lcd_putchar(0x20);
;
;        nguyen = number;
	CALL __PUTPARD2
	SBIW R28,8
	CALL __SAVELOCR6
;	number -> Y+14
;	nguyen -> R16,R17
;	thap_phan -> R18,R19
;	tram -> R20,R21
;	chuc -> Y+12
;	donvi -> Y+10
;	tp_chuc -> Y+8
;	tp_donvi -> Y+6
	CALL SUBOPT_0x2
	MOVW R16,R30
;        number = (number - nguyen)*100;
	MOVW R30,R16
	__GETD2S 14
	CALL SUBOPT_0x3
	CALL SUBOPT_0x4
	__GETD2N 0x42C80000
	CALL __MULF12
	__PUTD1S 14
;        thap_phan = number;
	CALL SUBOPT_0x2
	MOVW R18,R30
;
;        tram=nguyen/100;
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOVW R20,R30
;        chuc=(nguyen%100)/10;
	MOVW R26,R16
	CALL SUBOPT_0x0
	STD  Y+12,R30
	STD  Y+12+1,R31
;        donvi=nguyen%10;
	MOVW R26,R16
	CALL SUBOPT_0x1
	STD  Y+10,R30
	STD  Y+10+1,R31
;
;        tp_chuc=thap_phan/10;
	MOVW R26,R18
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	STD  Y+8,R30
	STD  Y+8+1,R31
;        tp_donvi=thap_phan%10;
	MOVW R26,R18
	CALL SUBOPT_0x1
	STD  Y+6,R30
	STD  Y+6+1,R31
;
;        /*
;        //Giai thuat lam tron so
;        if (tp_donvi>=5)
;        {
;            tp_chuc++;
;            if (tp_chuc>9)
;            {
;                tp_chuc=0;
;                donvi++;
;                if(donvi>9)
;                {
;                    donvi=0;
;                    chuc++;
;                    if(chuc>9)
;                    {
;                        chuc=0;
;                        tram++;
;                        tram=tram>9?0:tram;
;                    }
;                }
;            }
;        }
;        */
;        //Xoa so 0 vo nghia
;        if (tram==0)
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x11
;        {
;            lcd_putchar(0x20);
	LDI  R26,LOW(32)
	CALL _lcd_putchar
;            if (chuc==0)
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	SBIW R30,0
	BRNE _0x12
;                lcd_putchar(0x20);
	LDI  R26,LOW(32)
	RJMP _0x1DC
;            else
_0x12:
;                lcd_putchar(chuc+48);
	LDD  R26,Y+12
	SUBI R26,-LOW(48)
_0x1DC:
	CALL _lcd_putchar
;        }
;        else
	RJMP _0x14
_0x11:
;        {
;            lcd_putchar(tram+48);
	MOV  R26,R20
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
;            lcd_putchar(chuc+48);
	LDD  R26,Y+12
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
;        }
_0x14:
;        lcd_putchar(donvi+48);
	LDD  R26,Y+10
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
;        lcd_putchar('.');
	LDI  R26,LOW(46)
	CALL _lcd_putchar
;        lcd_putchar(tp_chuc+48);
	LDD  R26,Y+8
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
;        lcd_putchar(tp_donvi+48);
	LDD  R26,Y+6
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
;
;}
	CALL __LOADLOCR6
	ADIW R28,18
	RET
;//=================
;//void lcd_display_set (float number)
;//{
;//    unsigned int nguyen, thap_phan;
;//    nguyen = number;
;//    number = (number - nguyen)*10;
;//    thap_phan = number;
;//
;//    lcd_putnum_nguyen(nguyen);
;//    lcd_putchar('.');
;//    lcd_putnum_thap_phan_set(thap_phan);
;//}
;//============================
;void lcd_display_set (unsigned int number)
;{
_lcd_display_set:
;    lcd_putnum_nguyen(number/10);
	ST   -Y,R27
	ST   -Y,R26
;	number -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOVW R26,R30
	RCALL _lcd_putnum_nguyen
;    lcd_putchar('.');
	LDI  R26,LOW(46)
	CALL _lcd_putchar
;    lcd_putnum_thap_phan_set(number%10);
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x1
	MOVW R26,R30
	RCALL _lcd_putnum_thap_phan_set
;}
	ADIW R28,2
	RET
;//=================
;void lcd_display_pwm (unsigned int number)
;{
;    unsigned int trnghin,nghin,tram, chuc, donvi;
;    trnghin=number/10000;
;	number -> Y+10
;	trnghin -> R16,R17
;	nghin -> R18,R19
;	tram -> R20,R21
;	chuc -> Y+8
;	donvi -> Y+6
;    nghin=number%10000/1000;
;    tram=number%1000/100;
;    chuc=(number%100)/10;
;    donvi=number%10;
;
;    lcd_putchar(trnghin+48);
;    lcd_putchar(nghin+48);
;    lcd_putchar(tram+48);
;    lcd_putchar(chuc+48);
;    lcd_putchar(donvi+48);
;}
;//============================
;//Subroutine recording CGRAM character on the LCD
;// function used to define user characters
;
;void define_char(flash unsigned char *pc,unsigned char char_code)
;{
_define_char:
;char i,address;
;address=(char_code<<3)|0x40;
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	address -> R16
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
;for (i=0; i<8; i++) lcd_write_byte(address++,*pc++);
	LDI  R17,LOW(0)
_0x16:
	CPI  R17,8
	BRSH _0x17
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R26,Z
	CALL _lcd_write_byte
	SUBI R17,-1
	RJMP _0x16
_0x17:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20A0005
;
;
;/********************************************
;PID sub programming
;*******************************************/
;void pid_temp_ctrol(float sub_temp,float sub_set_temp)
;{
_pid_temp_ctrol:
;        err=sub_set_temp-sub_temp;
	CALL SUBOPT_0x5
;	sub_temp -> Y+4
;	sub_set_temp -> Y+0
	STS  _err,R30
	STS  _err+1,R31
	STS  _err+2,R22
	STS  _err+3,R23
;        //pid part
;        p_part=kp*err;
	CALL SUBOPT_0x6
	LDS  R26,_kp
	LDS  R27,_kp+1
	LDS  R24,_kp+2
	LDS  R25,_kp+3
	CALL __MULF12
	STS  _p_part,R30
	STS  _p_part+1,R31
	STS  _p_part+2,R22
	STS  _p_part+3,R23
;        d_part=kd*(err-pre_err)*inv_sampling_time;
	LDS  R26,_pre_err
	LDS  R27,_pre_err+1
	LDS  R24,_pre_err+2
	LDS  R25,_pre_err+3
	CALL SUBOPT_0x6
	CALL __SUBF12
	LDS  R26,_kd
	LDS  R27,_kd+1
	LDS  R24,_kd+2
	LDS  R25,_kd+3
	CALL SUBOPT_0x7
	STS  _d_part,R30
	STS  _d_part+1,R31
	STS  _d_part+2,R22
	STS  _d_part+3,R23
;        i_part=pre_i_part + ki*sampling_time*err/1000;
	LDS  R26,_ki
	LDS  R27,_ki+1
	LDS  R24,_ki+2
	LDS  R25,_ki+3
	CALL SUBOPT_0x8
	LDS  R26,_err
	LDS  R27,_err+1
	LDS  R24,_err+2
	LDS  R25,_err+3
	CALL SUBOPT_0x9
	LDS  R26,_pre_i_part
	LDS  R27,_pre_i_part+1
	LDS  R24,_pre_i_part+2
	LDS  R25,_pre_i_part+3
	CALL __ADDF12
	STS  _i_part,R30
	STS  _i_part+1,R31
	STS  _i_part+2,R22
	STS  _i_part+3,R23
;        output=p_part + d_part + i_part;
	LDS  R30,_d_part
	LDS  R31,_d_part+1
	LDS  R22,_d_part+2
	LDS  R23,_d_part+3
	LDS  R26,_p_part
	LDS  R27,_p_part+1
	LDS  R24,_p_part+2
	LDS  R25,_p_part+3
	CALL __ADDF12
	LDS  R26,_i_part
	LDS  R27,_i_part+1
	LDS  R24,_i_part+2
	LDS  R25,_i_part+3
	CALL __ADDF12
	CALL SUBOPT_0xA
;
;        //saturation
;        if(output>=pwm_period)   output=pwm_period-1;
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
	BRLO _0x18
	__GETD1N 0x459C3800
	CALL SUBOPT_0xA
;        if(output<=0)            output=1;
_0x18:
	CALL SUBOPT_0xB
	CALL __CPD02
	BRLT _0x19
	__GETD1N 0x3F800000
	CALL SUBOPT_0xA
;        pwm_a=set==1?output:1;
_0x19:
	MOV  R26,R5
	LDI  R27,0
	SBIW R26,1
	BRNE _0x1A
	LDS  R30,_output
	LDS  R31,_output+1
	LDS  R22,_output+2
	LDS  R23,_output+3
	CALL __CFD1U
	RJMP _0x1B
_0x1A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x1B:
	OUT  0x2A+1,R31
	OUT  0x2A,R30
;        //pwm_b=set==1?output:1;
;        pre_err=err;
	CALL SUBOPT_0x6
	STS  _pre_err,R30
	STS  _pre_err+1,R31
	STS  _pre_err+2,R22
	STS  _pre_err+3,R23
;        pre_i_part=i_part;
	LDS  R30,_i_part
	LDS  R31,_i_part+1
	LDS  R22,_i_part+2
	LDS  R23,_i_part+3
	STS  _pre_i_part,R30
	STS  _pre_i_part+1,R31
	STS  _pre_i_part+2,R22
	STS  _pre_i_part+3,R23
;}
	RJMP _0x20A0004
;
;
;void pid_humi_ctrol(float sub_humi,float sub_set_humi)
;{
_pid_humi_ctrol:
;        humi_err=sub_set_humi-sub_humi;
	CALL SUBOPT_0x5
;	sub_humi -> Y+4
;	sub_set_humi -> Y+0
	STS  _humi_err,R30
	STS  _humi_err+1,R31
	STS  _humi_err+2,R22
	STS  _humi_err+3,R23
;        //pid part
;        humi_p_part=humi_kp*humi_err;
	CALL SUBOPT_0xD
	LDS  R26,_humi_kp
	LDS  R27,_humi_kp+1
	LDS  R24,_humi_kp+2
	LDS  R25,_humi_kp+3
	CALL __MULF12
	STS  _humi_p_part,R30
	STS  _humi_p_part+1,R31
	STS  _humi_p_part+2,R22
	STS  _humi_p_part+3,R23
;        humi_d_part=humi_kd*(humi_err-humi_pre_err)*humi_inv_sampling_time;
	LDS  R26,_humi_pre_err
	LDS  R27,_humi_pre_err+1
	LDS  R24,_humi_pre_err+2
	LDS  R25,_humi_pre_err+3
	CALL SUBOPT_0xD
	CALL __SUBF12
	LDS  R26,_humi_kd
	LDS  R27,_humi_kd+1
	LDS  R24,_humi_kd+2
	LDS  R25,_humi_kd+3
	CALL SUBOPT_0x7
	STS  _humi_d_part,R30
	STS  _humi_d_part+1,R31
	STS  _humi_d_part+2,R22
	STS  _humi_d_part+3,R23
;        humi_i_part=humi_pre_i_part + humi_ki*humi_sampling_time*humi_err/1000;
	LDS  R26,_humi_ki
	LDS  R27,_humi_ki+1
	LDS  R24,_humi_ki+2
	LDS  R25,_humi_ki+3
	CALL SUBOPT_0x8
	LDS  R26,_humi_err
	LDS  R27,_humi_err+1
	LDS  R24,_humi_err+2
	LDS  R25,_humi_err+3
	CALL SUBOPT_0x9
	LDS  R26,_humi_pre_i_part
	LDS  R27,_humi_pre_i_part+1
	LDS  R24,_humi_pre_i_part+2
	LDS  R25,_humi_pre_i_part+3
	CALL __ADDF12
	STS  _humi_i_part,R30
	STS  _humi_i_part+1,R31
	STS  _humi_i_part+2,R22
	STS  _humi_i_part+3,R23
;        humi_output=humi_p_part + humi_d_part + humi_i_part;
	LDS  R30,_humi_d_part
	LDS  R31,_humi_d_part+1
	LDS  R22,_humi_d_part+2
	LDS  R23,_humi_d_part+3
	LDS  R26,_humi_p_part
	LDS  R27,_humi_p_part+1
	LDS  R24,_humi_p_part+2
	LDS  R25,_humi_p_part+3
	CALL __ADDF12
	LDS  R26,_humi_i_part
	LDS  R27,_humi_i_part+1
	LDS  R24,_humi_i_part+2
	LDS  R25,_humi_i_part+3
	CALL __ADDF12
	CALL SUBOPT_0xE
;
;        //saturation
;        if(humi_output>=humi_pwm_period)   humi_output=humi_pwm_period-1;
	CALL SUBOPT_0xF
	CALL SUBOPT_0xC
	BRLO _0x1D
	__GETD1N 0x459C3800
	CALL SUBOPT_0xE
;        if(humi_output<=0)            humi_output=1;
_0x1D:
	CALL SUBOPT_0xF
	CALL __CPD02
	BRLT _0x1E
	__GETD1N 0x3F800000
	CALL SUBOPT_0xE
;        pwm_b=set==1?humi_output:1;
_0x1E:
	MOV  R26,R5
	LDI  R27,0
	SBIW R26,1
	BRNE _0x1F
	LDS  R30,_humi_output
	LDS  R31,_humi_output+1
	LDS  R22,_humi_output+2
	LDS  R23,_humi_output+3
	CALL __CFD1U
	RJMP _0x20
_0x1F:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x20:
	OUT  0x28+1,R31
	OUT  0x28,R30
;        humi_pre_err=humi_err;
	CALL SUBOPT_0xD
	STS  _humi_pre_err,R30
	STS  _humi_pre_err+1,R31
	STS  _humi_pre_err+2,R22
	STS  _humi_pre_err+3,R23
;        humi_pre_i_part=humi_i_part;
	LDS  R30,_humi_i_part
	LDS  R31,_humi_i_part+1
	LDS  R22,_humi_i_part+2
	LDS  R23,_humi_i_part+3
	STS  _humi_pre_i_part,R30
	STS  _humi_pre_i_part+1,R31
	STS  _humi_pre_i_part+2,R22
	STS  _humi_pre_i_part+3,R23
;}
	RJMP _0x20A0004
;#include <sub_interrupt.c>
;/**************************************
;T2 overflow interrupt
;**************************************/
;interrupt [TIM2_OVF] void timer2_ovf_isr (void)
; 0000 001F {
_timer2_ovf_isr:
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
;    delay_sampling++;
	LDI  R26,LOW(_delay_sampling)
	LDI  R27,HIGH(_delay_sampling)
	CALL SUBOPT_0x10
;    if(delay_sampling>=5)
	LDS  R26,_delay_sampling
	LDS  R27,_delay_sampling+1
	SBIW R26,5
	BRLT _0x22
;    {
;        pid_temp_ctrol(nhiet_do,set_temp_ok);
	LDS  R30,_nhiet_do
	LDS  R31,_nhiet_do+1
	LDS  R22,_nhiet_do+2
	LDS  R23,_nhiet_do+3
	CALL __PUTPARD1
	LDS  R26,_set_temp_ok
	LDS  R27,_set_temp_ok+1
	LDS  R24,_set_temp_ok+2
	LDS  R25,_set_temp_ok+3
	RCALL _pid_temp_ctrol
;        pid_humi_ctrol(do_am,set_humi_ok);
	LDS  R30,_do_am
	LDS  R31,_do_am+1
	LDS  R22,_do_am+2
	LDS  R23,_do_am+3
	CALL __PUTPARD1
	LDS  R26,_set_humi_ok
	LDS  R27,_set_humi_ok+1
	LDS  R24,_set_humi_ok+2
	LDS  R25,_set_humi_ok+3
	RCALL _pid_humi_ctrol
;        delay_sampling=0;
	LDI  R30,LOW(0)
	STS  _delay_sampling,R30
	STS  _delay_sampling+1,R30
;    }
;    s++;
_0x22:
	LDI  R26,LOW(_s)
	LDI  R27,HIGH(_s)
	CALL SUBOPT_0x10
;    state=s>=2200?~state:state;
	CALL SUBOPT_0x11
	BRLO _0x23
	LDI  R30,0
	SBRS R2,0
	LDI  R30,1
	RJMP _0x24
_0x23:
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
_0x24:
	CALL __BSTB1
	BLD  R2,0
;    s=s>=2200?0:s;
	CALL SUBOPT_0x11
	BRLO _0x26
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x27
_0x26:
	LDS  R30,_s
	LDS  R31,_s+1
_0x27:
	STS  _s,R30
	STS  _s+1,R31
;    delay++;
	LDI  R26,LOW(_delay)
	LDI  R27,HIGH(_delay)
	CALL SUBOPT_0x10
;}
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
;#include <sub_sht11.c>
;//Library source code for SHT11
;//===========================
;//SHT11 const  define
;#define SHT_NOACK           0
;#define SHT_ACK             1
;#define SHT_STATUS_REG_W    0x06   //0000 0110
;#define SHT_STATUS_REG_R    0x07   //0000 0111
;#define SHT_MEASURE_TEMP    0x03   //0000 0011
;#define SHT_MEASURE_HUMI    0x05   //0000 0101
;#define SHT_RESET           0x1E   //0001 1110
;#define SHT_14_12_BIT       0x00
;#define SHT_12_8_BIT        0x01
;//Cac hang so voi do phan giai 14 va 12 bit
;#define H_C1    -4.0
;#define H_C2    0.0405
;#define H_C3    -0.0000028
;#define H_D1    -40.00      //(vcc=5v)
;//#define H_D1    -39.75        //(vcc=4v)
;#define H_D2    0.01
;#define H_T1    0.01
;#define H_T2    0.00008
;//Cac hang so voi do phan giai 12 va 8 bit
;#define L_C1    -4.0
;#define L_C2    0.648
;#define L_C3    -0.00072
;#define L_D1    -40.00
;#define L_D2    0.04
;#define L_T1    0.01
;#define L_T2    0.00128
;
;static uint8_t SHT_Resolution;
; /*******************************************************************************
;Noi Dung    :   Bat dau mot ket noi moi.
;Tham Bien   :   Khong.
;Tra Ve      :   Khong.
;********************************************************************************/
;void SHT_Start()
; 0000 0020 {
_SHT_Start:
;SHT_DDR_CLK  = DDROUT;  // SHT la chan ra
	SBI  0x11,2
;SHT_DDR_DATA = DDROUT; // Data la chan ra
	SBI  0x11,3
;SHT_DATA_OUT = 1;
	SBI  0x12,3
;SHT_CLK = 0;
	CBI  0x12,2
;SHT_CLK = 1;
	SBI  0x12,2
;SHT_DATA_OUT = 0;
	CBI  0x12,3
;SHT_CLK = 0;
	CBI  0x12,2
;SHT_CLK = 1;
	SBI  0x12,2
;SHT_DATA_OUT = 1;
	SBI  0x12,3
;SHT_CLK = 0;
	CBI  0x12,2
;}
	RET
; /*******************************************************************************
;Noi Dung    :   Reset ket noi moi.
;Tham Bien   :   Khong.
;Tra Ve      :   Khong.
;********************************************************************************/
;void SHT_ResetConection()
;{
_SHT_ResetConection:
;   uint8_t i;
;   SHT_DDR_DATA = DDROUT;  //Data la chan ra
	ST   -Y,R17
;	i -> R17
	SBI  0x11,3
;   SHT_DATA_OUT=1;
	SBI  0x12,3
;   for (i=0; i<9; i++)
	LDI  R17,LOW(0)
_0x42:
	CPI  R17,9
	BRSH _0x43
;       {
;      SHT_CLK=1;
	SBI  0x12,2
;      SHT_CLK=0;
	CBI  0x12,2
;       }
	SUBI R17,-1
	RJMP _0x42
_0x43:
;   SHT_Start();
	RCALL _SHT_Start
;}
	LD   R17,Y+
	RET
; /*******************************************************************************
;Noi Dung    :   Gui 1 Byte du lieu len SHT.
;Tham Bien   :   Data:  Byte du lieu can viet.
;Tra Ve      :   1:     Neu viet Byte xay ra loi.
;                0:     Neu viet Byte thanh cong.
;********************************************************************************/
;uint8_t SHT_WriteByte(uint8_t Data)
;{
_SHT_WriteByte:
;uint8_t i, error = 0;
;SHT_DDR_DATA = DDROUT;                // Data la chan ra
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	Data -> Y+2
;	i -> R17
;	error -> R16
	LDI  R16,0
	SBI  0x11,3
;delay_us(2);
	__DELAY_USB 11
;for(i = 0x80; i > 0; i /= 2)
	LDI  R17,LOW(128)
_0x4B:
	CPI  R17,1
	BRLO _0x4C
;   {
;   SHT_CLK = 0;
	CBI  0x12,2
;   if(i & Data)   SHT_DATA_OUT = 1;
	LDD  R30,Y+2
	AND  R30,R17
	BREQ _0x4F
	SBI  0x12,3
;   else            SHT_DATA_OUT = 0;
	RJMP _0x52
_0x4F:
	CBI  0x12,3
;   delay_us(1);
_0x52:
	CALL SUBOPT_0x12
;   SHT_CLK = 1;
;   delay_us(1);
;   }
	CALL SUBOPT_0x13
	RJMP _0x4B
_0x4C:
;   SHT_CLK = 0;
	CBI  0x12,2
;   SHT_DDR_DATA = DDRIN;            // Data la chan vao
	CBI  0x11,3
;   delay_us(1);
	CALL SUBOPT_0x12
;   SHT_CLK = 1;
;   delay_us(1);
;   error = SHT_DATA_IN;
	LDI  R30,0
	SBIC 0x10,3
	LDI  R30,1
	MOV  R16,R30
;   SHT_CLK = 0;
	CBI  0x12,2
;   delay_ms(250);
	LDI  R26,LOW(250)
	LDI  R27,0
	CALL _delay_ms
;return(error);
	RJMP _0x20A0006
;}
;
; /*******************************************************************************
;Noi Dung    :   Doc 1 Byte du lieu tu SHT.
;Tham Bien   :   ack:   Gia tri ACK 0,1.
;Tra Ve      :   Khong.
;********************************************************************************/
;uint8_t SHT_ReadByte(uint8_t ack)
;{
_SHT_ReadByte:
;uint8_t i, val = 0;
;SHT_DDR_DATA = DDRIN;               // Data la chan vao
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	ack -> Y+2
;	i -> R17
;	val -> R16
	LDI  R16,0
	CBI  0x11,3
;for(i = 0x80; i > 0; i /= 2)
	LDI  R17,LOW(128)
_0x62:
	CPI  R17,1
	BRLO _0x63
;{
;   SHT_CLK = 1;
	SBI  0x12,2
;   delay_us(1);
	__DELAY_USB 5
;   if(SHT_DATA_IN)   val = val | i;
	SBIC 0x10,3
	OR   R16,R17
;   delay_us(1);
	__DELAY_USB 5
;   SHT_CLK = 0;
	CBI  0x12,2
;}
	CALL SUBOPT_0x13
	RJMP _0x62
_0x63:
;SHT_DDR_DATA = DDROUT;                // Data la chan ra
	SBI  0x11,3
;delay_us(1);
	__DELAY_USB 5
;SHT_DATA_OUT = ! ack;
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x6B
	CBI  0x12,3
	RJMP _0x6C
_0x6B:
	SBI  0x12,3
_0x6C:
;SHT_CLK = 1;
	SBI  0x12,2
;delay_us(1);
	__DELAY_USB 5
;SHT_CLK = 0;
	CBI  0x12,2
;return(val);
_0x20A0006:
	MOV  R30,R16
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x20A0007:
	ADIW R28,3
	RET
;}
; /*******************************************************************************
;Noi Dung    :   Khoi tao SHT.
;Tham Bien   :   resolution: gia tri do phan giai.
;                - SHT_14_12_BIT
;                - SHT_12_8_BIT
;Tra Ve      :   Khong.
;********************************************************************************/
;void SHT_Init(uint8_t resolution)
;{
_SHT_Init:
; SHT_ResetConection();
	ST   -Y,R26
;	resolution -> Y+0
	RCALL _SHT_ResetConection
; SHT_WriteByte(SHT_STATUS_REG_W);
	LDI  R26,LOW(6)
	RCALL _SHT_WriteByte
; delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; SHT_WriteByte(resolution);
	LD   R26,Y
	RCALL _SHT_WriteByte
; SHT_Resolution=resolution;
	LD   R30,Y
	STS  _SHT_Resolution_G000,R30
;}
	ADIW R28,1
	RET
; /*******************************************************************************
;Noi Dung    :   Reset SHT.
;Tham Bien   :   Khong.
;Tra Ve      :   Khong.
;********************************************************************************/
;void SHT_ResetChip()
;{
;SHT_ResetConection();
;SHT_WriteByte(SHT_RESET);
;delay_ms(100);
;}
; /*******************************************************************************
;Noi Dung    :   Doc 16 bit du lieu tu SHT.
;Tham Bien   :   Command:   Ma lenh yeu cau.
;Tra Ve      :   16 bit du lieu.
;********************************************************************************/
;uint16_t SHT_ReadSenSor(uint8_t Command)
;{
_SHT_ReadSenSor:
;uint8_t msb, lsb, crc;
;SHT_ResetConection();
	ST   -Y,R26
	CALL __SAVELOCR4
;	Command -> Y+4
;	msb -> R17
;	lsb -> R16
;	crc -> R19
	RCALL _SHT_ResetConection
;SHT_WriteByte(Command);
	LDD  R26,Y+4
	RCALL _SHT_WriteByte
;///////////////////////////////////////////////
;while(SHT_DATA_IN){#asm ("sei")};
_0x71:
	SBIS 0x10,3
	RJMP _0x73
	sei
	RJMP _0x71
_0x73:
;#asm ("cli")
	cli
;delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
;//////////////////////////////////////////////
;msb = SHT_ReadByte(SHT_ACK);
	LDI  R26,LOW(1)
	RCALL _SHT_ReadByte
	MOV  R17,R30
;lsb = SHT_ReadByte(SHT_ACK);
	LDI  R26,LOW(1)
	RCALL _SHT_ReadByte
	MOV  R16,R30
;crc = SHT_ReadByte(SHT_NOACK);
	LDI  R26,LOW(0)
	RCALL _SHT_ReadByte
	MOV  R19,R30
;return(((uint16_t) msb << 8) | (uint16_t) lsb);
	MOV  R31,R17
	LDI  R30,LOW(0)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	CALL __LOADLOCR4
_0x20A0005:
	ADIW R28,5
	RET
;}
; /*******************************************************************************
;Noi Dung    :   Doc  gia tri nhiet do,do am tu SHT.
;Tham Bien   :   *tem: con tro luu tru du lieu nhiet do.
;                *humi: con tro luu tru du lieu do am.
;Tra Ve      :   Khong.
;********************************************************************************/
;void SHT_ReadTemHumi(float *tem, float *humi)
;{
_SHT_ReadTemHumi:
;   uint16_t SOT;
;   uint16_t SORH;
;   SOT=SHT_ReadSenSor(SHT_MEASURE_TEMP);
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	*tem -> Y+6
;	*humi -> Y+4
;	SOT -> R16,R17
;	SORH -> R18,R19
	LDI  R26,LOW(3)
	RCALL _SHT_ReadSenSor
	MOVW R16,R30
;   SORH=SHT_ReadSenSor(SHT_MEASURE_HUMI);
	LDI  R26,LOW(5)
	RCALL _SHT_ReadSenSor
	MOVW R18,R30
;   if(SHT_Resolution==SHT_14_12_BIT)
	LDS  R30,_SHT_Resolution_G000
	CPI  R30,0
	BREQ PC+3
	JMP _0x74
;   {
;    *tem=(H_D1+H_D2*SOT);
	CALL SUBOPT_0x14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __PUTDP1
;    *humi=((H_D1+H_D2*SOT-25)*(H_T1+H_T2*SORH)+H_C1+H_C2*SORH+H_C3*SORH*SORH);
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R18
	CALL SUBOPT_0x3
	__GETD2N 0x38A7C5AC
	CALL SUBOPT_0x16
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x17
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R18
	CALL SUBOPT_0x3
	__GETD2N 0x3D25E354
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R18
	CALL SUBOPT_0x3
	__GETD2N 0xB63BE7A2
	CALL SUBOPT_0x18
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RJMP _0x1DD
;   }
;   else
_0x74:
;   {
;   *tem=(L_D1+L_D2*SOT);
	CALL SUBOPT_0x19
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __PUTDP1
;   *humi=((L_D1+L_D2*SOT-25)*(L_T1+L_T2*SORH)+L_C1+L_C2*SORH+L_C3*SORH*SORH);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x15
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R18
	CALL SUBOPT_0x3
	__GETD2N 0x3AA7C5AC
	CALL SUBOPT_0x16
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL SUBOPT_0x17
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R18
	CALL SUBOPT_0x3
	__GETD2N 0x3F25E354
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R18
	CALL SUBOPT_0x3
	__GETD2N 0xBA3CBE62
	CALL SUBOPT_0x18
	POP  R26
	POP  R27
	POP  R24
	POP  R25
_0x1DD:
	CALL __ADDF12
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __PUTDP1
;   }
;}
	CALL __LOADLOCR4
_0x20A0004:
	ADIW R28,8
	RET
;//===========================
;
;
;// Declare your global variables here
;void main(void)
; 0000 0023 {
_main:
; 0000 0024 // Input/Output Ports initialization
; 0000 0025 // Port A initialization
; 0000 0026 PORTA=0xFC;
	LDI  R30,LOW(252)
	OUT  0x1B,R30
; 0000 0027 DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0028 
; 0000 0029 // Port B initialization
; 0000 002A PORTB=0x00;
	OUT  0x18,R30
; 0000 002B DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 002C 
; 0000 002D // Port C initialization
; 0000 002E PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 002F DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0030 
; 0000 0031 // Port D initialization
; 0000 0032 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0033 DDRD=0xF2;
	LDI  R30,LOW(242)
	OUT  0x11,R30
; 0000 0034 
; 0000 0035 // Timer/Counter 0 initialization
; 0000 0036 TCCR0=0;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0037 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0038 OCR0=0x00;
	OUT  0x3C,R30
; 0000 0039 
; 0000 003A // Timer/Counter 1 initialization
; 0000 003B TCCR1A=(1<<COM1A1)|(1<<COM1B1)|(1<<WGM11);
	LDI  R30,LOW(162)
	OUT  0x2F,R30
; 0000 003C TCCR1B=(1<<WGM13)|(1<<WGM12)|(1<<CS11);
	LDI  R30,LOW(26)
	OUT  0x2E,R30
; 0000 003D //TCCR1A=0;
; 0000 003E //TCCR1B=0;
; 0000 003F TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0040 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0041 ICR1=pwm_period;
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	OUT  0x26+1,R31
	OUT  0x26,R30
; 0000 0042 OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 0043 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0044 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0045 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0046 
; 0000 0047 // Timer/Counter 2 initialization
; 0000 0048 ASSR=0x00;
	OUT  0x22,R30
; 0000 0049 TCCR2|=(1<<CS21);
	IN   R30,0x25
	ORI  R30,2
	OUT  0x25,R30
; 0000 004A TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 004B OCR2=0x00;
	OUT  0x23,R30
; 0000 004C 
; 0000 004D // External Interrupt(s) initialization
; 0000 004E MCUCR=0x00;
	OUT  0x35,R30
; 0000 004F MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0050 
; 0000 0051 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0052 TIMSK|=(1<<TOIE2);
	IN   R30,0x39
	ORI  R30,0x40
	OUT  0x39,R30
; 0000 0053 
; 0000 0054 // Alphanumeric LCD initialization
; 0000 0055 // Connections specified in the
; 0000 0056 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0057 // RS - PORTB Bit 7
; 0000 0058 // RD - PORTB Bit 6
; 0000 0059 // EN - PORTB Bit 5
; 0000 005A // D4 - PORTB Bit 3
; 0000 005B // D5 - PORTB Bit 2
; 0000 005C // D6 - PORTB Bit 1
; 0000 005D // D7 - PORTB Bit 0
; 0000 005E // Characters/line: 20
; 0000 005F lcd_init(20);
	LDI  R26,LOW(20)
	CALL _lcd_init
; 0000 0060 lcd_clear();
	CALL _lcd_clear
; 0000 0061 
; 0000 0062 lcd_gotoxy(3,0);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0063 lcd_puts("Do An Mon Hoc");
	__POINTW2MN _0x76,0
	CALL SUBOPT_0x1A
; 0000 0064 //lcd_gotoxy(1,1);
; 0000 0065 //lcd_puts("Nguyen Thuy Duong");
; 0000 0066 //lcd_gotoxy(1,2);
; 0000 0067 //lcd_puts("Phuong Vo");
; 0000 0068 lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0069 lcd_puts("Thuy Duong 12141041");
	__POINTW2MN _0x76,14
	CALL SUBOPT_0x1A
; 0000 006A lcd_gotoxy(0,2);
	LDI  R26,LOW(2)
	CALL _lcd_gotoxy
; 0000 006B lcd_puts("Phuong Vo  12141174");
	__POINTW2MN _0x76,34
	CALL SUBOPT_0x1A
; 0000 006C lcd_gotoxy(0,3);
	LDI  R26,LOW(3)
	CALL _lcd_gotoxy
; 0000 006D lcd_puts("Dang Khoi Tao SHT...");
	__POINTW2MN _0x76,54
	CALL _lcd_puts
; 0000 006E SHT_Init(SHT_12_8_BIT);
	LDI  R26,LOW(1)
	RCALL _SHT_Init
; 0000 006F delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0070 
; 0000 0071 
; 0000 0072 //Subroutine call recording CGRAM character on the LCD
; 0000 0073 define_char(character_0,0x00);
	LDI  R30,LOW(_character_0*2)
	LDI  R31,HIGH(_character_0*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _define_char
; 0000 0074 
; 0000 0075 for(i=0;i<=3;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0x78:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,4
	BRSH _0x79
; 0000 0076 {
; 0000 0077     int_temp_ok[i]=eep_temp_ok[i];
	CALL SUBOPT_0x1B
	LDI  R26,LOW(_int_temp_ok)
	LDI  R27,HIGH(_int_temp_ok)
	CALL SUBOPT_0x1C
	LDI  R26,LOW(_eep_temp_ok)
	LDI  R27,HIGH(_eep_temp_ok)
	CALL SUBOPT_0x1D
; 0000 0078     int_humi_ok[i]=eep_humi_ok[i];
	LDI  R26,LOW(_int_humi_ok)
	LDI  R27,HIGH(_int_humi_ok)
	CALL SUBOPT_0x1C
	LDI  R26,LOW(_eep_humi_ok)
	LDI  R27,HIGH(_eep_humi_ok)
	CALL SUBOPT_0x1D
; 0000 0079     int_temp[i]=int_temp_ok[i];
	LDI  R26,LOW(_int_temp)
	LDI  R27,HIGH(_int_temp)
	CALL SUBOPT_0x1C
	LDI  R26,LOW(_int_temp_ok)
	LDI  R27,HIGH(_int_temp_ok)
	CALL SUBOPT_0x1E
; 0000 007A     int_humi[i]=int_humi_ok[i];
	CALL SUBOPT_0x1B
	LDI  R26,LOW(_int_humi)
	LDI  R27,HIGH(_int_humi)
	CALL SUBOPT_0x1C
	LDI  R26,LOW(_int_humi_ok)
	LDI  R27,HIGH(_int_humi_ok)
	CALL SUBOPT_0x1E
; 0000 007B }
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	CALL SUBOPT_0x10
	RJMP _0x78
_0x79:
; 0000 007C SHT_ReadTemHumi(&nhiet_do,&do_am);
	CALL SUBOPT_0x1F
; 0000 007D 
; 0000 007E while (1)
_0x7A:
; 0000 007F {
; 0000 0080     // Place your code here
; 0000 0081     //Phim cai dat
; 0000 0082     //set=1:run, set=2:set_temp, set=3:set_humi,
; 0000 0083     if(SETTING==0)
	SBIC 0x19,7
	RJMP _0x7D
; 0000 0084     {
; 0000 0085         while(SETTING==0);
_0x7E:
	SBIS 0x19,7
	RJMP _0x7E
; 0000 0086         falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 0087         set++;
	INC  R5
; 0000 0088         set=set>3?2:set;
	LDI  R30,LOW(3)
	CP   R30,R5
	BRSH _0x84
	LDI  R30,LOW(2)
	RJMP _0x85
_0x84:
	MOV  R30,R5
_0x85:
	MOV  R5,R30
; 0000 0089     }
; 0000 008A         //Set temp
; 0000 008B     if(set==2)
_0x7D:
	LDI  R30,LOW(2)
	CP   R30,R5
	BREQ PC+3
	JMP _0x87
; 0000 008C     {
; 0000 008D         if(MODE==0)
	SBIC 0x19,2
	RJMP _0x88
; 0000 008E         {
; 0000 008F             while(MODE==0);
_0x89:
	SBIS 0x19,2
	RJMP _0x89
; 0000 0090             falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 0091             mode_temp++;
	INC  R4
; 0000 0092             mode_temp=mode_temp>4?1:mode_temp;
	LDI  R30,LOW(4)
	CP   R30,R4
	BRSH _0x8F
	LDI  R30,LOW(1)
	RJMP _0x90
_0x8F:
	MOV  R30,R4
_0x90:
	MOV  R4,R30
; 0000 0093         }
; 0000 0094         if (mode_temp==1)
_0x88:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x92
; 0000 0095         {
; 0000 0096             if(UP==0)
	SBIC 0x19,6
	RJMP _0x93
; 0000 0097             {
; 0000 0098                 while(UP==0);
_0x94:
	SBIS 0x19,6
	RJMP _0x94
; 0000 0099                 if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0x97
; 0000 009A                 {
; 0000 009B                 delay=0;
	CALL SUBOPT_0x22
; 0000 009C                 falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 009D                 int_temp[0]++;
	LDI  R26,LOW(_int_temp)
	LDI  R27,HIGH(_int_temp)
	CALL SUBOPT_0x10
; 0000 009E                 int_temp[0]=int_temp[0]>1?0:int_temp[0];
	LDS  R26,_int_temp
	LDS  R27,_int_temp+1
	SBIW R26,2
	BRLT _0x9B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x9C
_0x9B:
	CALL SUBOPT_0x23
_0x9C:
	CALL SUBOPT_0x24
; 0000 009F                 lcd_gotoxy(3,3);
; 0000 00A0                 lcd_putchar(int_temp[0]+48);
; 0000 00A1                 }
; 0000 00A2             }
_0x97:
; 0000 00A3             if(DOWN==0)
_0x93:
	SBIC 0x19,3
	RJMP _0x9E
; 0000 00A4             {
; 0000 00A5                 while(DOWN==0);
_0x9F:
	SBIS 0x19,3
	RJMP _0x9F
; 0000 00A6                 if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0xA2
; 0000 00A7                 {
; 0000 00A8                 delay=0;
	CALL SUBOPT_0x22
; 0000 00A9                 falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 00AA                 int_temp[0]--;
	LDI  R26,LOW(_int_temp)
	LDI  R27,HIGH(_int_temp)
	CALL SUBOPT_0x25
; 0000 00AB                 int_temp[0]=int_temp[0]<0?1:int_temp[0];
	LDS  R26,_int_temp+1
	TST  R26
	BRPL _0xA6
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0xA7
_0xA6:
	CALL SUBOPT_0x23
_0xA7:
	CALL SUBOPT_0x24
; 0000 00AC                 lcd_gotoxy(3,3);
; 0000 00AD                 lcd_putchar(int_temp[0]+48);
; 0000 00AE                 }
; 0000 00AF             }
_0xA2:
; 0000 00B0         }
_0x9E:
; 0000 00B1         if(!int_temp[0])
_0x92:
	CALL SUBOPT_0x23
	SBIW R30,0
	BREQ PC+3
	JMP _0xA9
; 0000 00B2         {
; 0000 00B3             if (mode_temp==2)
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0xAA
; 0000 00B4             {
; 0000 00B5                 if(UP==0)
	SBIC 0x19,6
	RJMP _0xAB
; 0000 00B6                 {
; 0000 00B7                     while(UP==0)
_0xAC:
	SBIC 0x19,6
	RJMP _0xAE
; 0000 00B8                     {
; 0000 00B9                         if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0xAF
; 0000 00BA                         {
; 0000 00BB                         delay=0;
	CALL SUBOPT_0x22
; 0000 00BC                         int_temp[1]++;
	__POINTW2MN _int_temp,2
	CALL SUBOPT_0x10
; 0000 00BD                         int_temp[1]=int_temp[1]>9?0:int_temp[1];
	CALL SUBOPT_0x26
	SBIW R26,10
	BRLT _0xB0
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0xB1
_0xB0:
	CALL SUBOPT_0x27
_0xB1:
	CALL SUBOPT_0x28
; 0000 00BE                         lcd_gotoxy(4,3);
; 0000 00BF                         lcd_putchar(int_temp[1]+48);
; 0000 00C0                         }
; 0000 00C1                     }
_0xAF:
	RJMP _0xAC
_0xAE:
; 0000 00C2                     falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 00C3                 }
; 0000 00C4                 if(DOWN==0)
_0xAB:
	SBIC 0x19,3
	RJMP _0xB6
; 0000 00C5                 {
; 0000 00C6                     while(DOWN==0)
_0xB7:
	SBIC 0x19,3
	RJMP _0xB9
; 0000 00C7                     {
; 0000 00C8                         if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0xBA
; 0000 00C9                         {
; 0000 00CA                         delay=0;
	CALL SUBOPT_0x22
; 0000 00CB                         int_temp[1]--;
	__POINTW2MN _int_temp,2
	CALL SUBOPT_0x25
; 0000 00CC                         int_temp[1]=int_temp[1]<0?9:int_temp[1];
	__GETB2MN _int_temp,3
	TST  R26
	BRPL _0xBB
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0xBC
_0xBB:
	CALL SUBOPT_0x27
_0xBC:
	CALL SUBOPT_0x28
; 0000 00CD                         lcd_gotoxy(4,3);
; 0000 00CE                         lcd_putchar(int_temp[1]+48);
; 0000 00CF                         }
; 0000 00D0                     }
_0xBA:
	RJMP _0xB7
_0xB9:
; 0000 00D1                     falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 00D2                 }
; 0000 00D3             }
_0xB6:
; 0000 00D4             if (mode_temp==3)
_0xAA:
	LDI  R30,LOW(3)
	CP   R30,R4
	BRNE _0xC1
; 0000 00D5             {
; 0000 00D6                 if(UP==0)
	SBIC 0x19,6
	RJMP _0xC2
; 0000 00D7                 {
; 0000 00D8                     while(UP==0)
_0xC3:
	SBIC 0x19,6
	RJMP _0xC5
; 0000 00D9                     {
; 0000 00DA                         if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0xC6
; 0000 00DB                         {
; 0000 00DC                         delay=0;
	CALL SUBOPT_0x22
; 0000 00DD                         int_temp[2]++;
	__POINTW2MN _int_temp,4
	CALL SUBOPT_0x10
; 0000 00DE                         int_temp[2]=int_temp[2]>9?0:int_temp[2];
	__GETW2MN _int_temp,4
	SBIW R26,10
	BRLT _0xC7
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0xC8
_0xC7:
	CALL SUBOPT_0x29
_0xC8:
	CALL SUBOPT_0x2A
; 0000 00DF                         lcd_gotoxy(5,3);
; 0000 00E0                         lcd_putchar(int_temp[2]+48);
; 0000 00E1                         }
; 0000 00E2                     }
_0xC6:
	RJMP _0xC3
_0xC5:
; 0000 00E3                     falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 00E4                 }
; 0000 00E5                 if(DOWN==0)
_0xC2:
	SBIC 0x19,3
	RJMP _0xCD
; 0000 00E6                 {
; 0000 00E7                     while(DOWN==0)
_0xCE:
	SBIC 0x19,3
	RJMP _0xD0
; 0000 00E8                     {
; 0000 00E9                         if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0xD1
; 0000 00EA                         {
; 0000 00EB                         delay=0;
	CALL SUBOPT_0x22
; 0000 00EC                         int_temp[2]--;
	__POINTW2MN _int_temp,4
	CALL SUBOPT_0x25
; 0000 00ED                         int_temp[2]=int_temp[2]<0?9:int_temp[2];
	__GETB2MN _int_temp,5
	TST  R26
	BRPL _0xD2
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0xD3
_0xD2:
	CALL SUBOPT_0x29
_0xD3:
	CALL SUBOPT_0x2A
; 0000 00EE                         lcd_gotoxy(5,3);
; 0000 00EF                         lcd_putchar(int_temp[2]+48);
; 0000 00F0                         }
; 0000 00F1                     }
_0xD1:
	RJMP _0xCE
_0xD0:
; 0000 00F2                     falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 00F3                 }
; 0000 00F4             }
_0xCD:
; 0000 00F5             if (mode_temp==4)
_0xC1:
	LDI  R30,LOW(4)
	CP   R30,R4
	BRNE _0xD8
; 0000 00F6             {
; 0000 00F7                 if(UP==0)
	SBIC 0x19,6
	RJMP _0xD9
; 0000 00F8                 {
; 0000 00F9                     while(UP==0)
_0xDA:
	SBIC 0x19,6
	RJMP _0xDC
; 0000 00FA                     {
; 0000 00FB                         if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0xDD
; 0000 00FC                         {
; 0000 00FD                         delay=0;
	CALL SUBOPT_0x22
; 0000 00FE                         int_temp[3]++;
	__POINTW2MN _int_temp,6
	CALL SUBOPT_0x10
; 0000 00FF                         int_temp[3]=int_temp[3]>9?0:int_temp[3];
	__GETW2MN _int_temp,6
	SBIW R26,10
	BRLT _0xDE
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0xDF
_0xDE:
	CALL SUBOPT_0x2B
_0xDF:
	CALL SUBOPT_0x2C
; 0000 0100                         lcd_gotoxy(7,3);
; 0000 0101                         lcd_putchar(int_temp[3]+48);
; 0000 0102                         }
; 0000 0103                     }
_0xDD:
	RJMP _0xDA
_0xDC:
; 0000 0104                     falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 0105                 }
; 0000 0106                 if(DOWN==0)
_0xD9:
	SBIC 0x19,3
	RJMP _0xE4
; 0000 0107                 {
; 0000 0108                     while(DOWN==0)
_0xE5:
	SBIC 0x19,3
	RJMP _0xE7
; 0000 0109                     {
; 0000 010A                         if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0xE8
; 0000 010B                         {
; 0000 010C                         delay=0;
	CALL SUBOPT_0x22
; 0000 010D                         int_temp[3]--;
	__POINTW2MN _int_temp,6
	CALL SUBOPT_0x25
; 0000 010E                         int_temp[3]=int_temp[3]<0?9:int_temp[3];
	__GETB2MN _int_temp,7
	TST  R26
	BRPL _0xE9
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0xEA
_0xE9:
	CALL SUBOPT_0x2B
_0xEA:
	CALL SUBOPT_0x2C
; 0000 010F                         lcd_gotoxy(7,3);
; 0000 0110                         lcd_putchar(int_temp[3]+48);
; 0000 0111                         }
; 0000 0112                     }
_0xE8:
	RJMP _0xE5
_0xE7:
; 0000 0113                     falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 0114                 }
; 0000 0115             }
_0xE4:
; 0000 0116         }
_0xD8:
; 0000 0117         else
	RJMP _0xEF
_0xA9:
; 0000 0118         {
; 0000 0119             if (mode_temp==2)
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0xF0
; 0000 011A             {
; 0000 011B                 if(UP==0)
	SBIC 0x19,6
	RJMP _0xF1
; 0000 011C                 {
; 0000 011D                     while(UP==0);
_0xF2:
	SBIS 0x19,6
	RJMP _0xF2
; 0000 011E                     if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0xF5
; 0000 011F                     {
; 0000 0120                     delay=0;
	CALL SUBOPT_0x22
; 0000 0121                     falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 0122                     int_temp[1]++;
	__POINTW2MN _int_temp,2
	CALL SUBOPT_0x10
; 0000 0123                     int_temp[1]=int_temp[1]>2?0:int_temp[1];
	CALL SUBOPT_0x26
	SBIW R26,3
	BRLT _0xF9
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0xFA
_0xF9:
	CALL SUBOPT_0x27
_0xFA:
	CALL SUBOPT_0x28
; 0000 0124                     lcd_gotoxy(4,3);
; 0000 0125                     lcd_putchar(int_temp[1]+48);
; 0000 0126                     }
; 0000 0127 
; 0000 0128                 }
_0xF5:
; 0000 0129                 if(DOWN==0)
_0xF1:
	SBIC 0x19,3
	RJMP _0xFC
; 0000 012A                 {
; 0000 012B                     while(DOWN==0);
_0xFD:
	SBIS 0x19,3
	RJMP _0xFD
; 0000 012C                     if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0x100
; 0000 012D                     {
; 0000 012E                     delay=0;
	CALL SUBOPT_0x22
; 0000 012F                     falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 0130                     int_temp[1]--;
	__POINTW2MN _int_temp,2
	CALL SUBOPT_0x25
; 0000 0131                     int_temp[1]=int_temp[1]<0?2:int_temp[1];
	__GETB2MN _int_temp,3
	TST  R26
	BRPL _0x104
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x105
_0x104:
	CALL SUBOPT_0x27
_0x105:
	CALL SUBOPT_0x28
; 0000 0132                     lcd_gotoxy(4,3);
; 0000 0133                     lcd_putchar(int_temp[1]+48);
; 0000 0134                     }
; 0000 0135 
; 0000 0136                 }
_0x100:
; 0000 0137             }
_0xFC:
; 0000 0138             int_temp[1]=int_temp[1]>2?2:int_temp[1];
_0xF0:
	CALL SUBOPT_0x26
	SBIW R26,3
	BRLT _0x107
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x108
_0x107:
	CALL SUBOPT_0x27
_0x108:
	__PUTW1MN _int_temp,2
; 0000 0139 
; 0000 013A             if (int_temp[1]>=2)
	CALL SUBOPT_0x26
	SBIW R26,2
	BRLT _0x10A
; 0000 013B             {
; 0000 013C                 int_temp[2]=0;
	__POINTW1MN _int_temp,4
	CALL SUBOPT_0x2D
; 0000 013D                 int_temp[3]=0;
	__POINTW1MN _int_temp,6
	CALL SUBOPT_0x2D
; 0000 013E                 mode_temp=mode_temp>2?1:mode_temp;
	LDI  R30,LOW(2)
	CP   R30,R4
	BRSH _0x10B
	LDI  R30,LOW(1)
	RJMP _0x10C
_0x10B:
	MOV  R30,R4
_0x10C:
	MOV  R4,R30
; 0000 013F             }
; 0000 0140             else
	RJMP _0x10E
_0x10A:
; 0000 0141             {
; 0000 0142                 if (mode_temp==3)
	LDI  R30,LOW(3)
	CP   R30,R4
	BRNE _0x10F
; 0000 0143                 {
; 0000 0144                     if(UP==0)
	SBIC 0x19,6
	RJMP _0x110
; 0000 0145                     {
; 0000 0146                         while(UP==0)
_0x111:
	SBIC 0x19,6
	RJMP _0x113
; 0000 0147                         {
; 0000 0148                             if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0x114
; 0000 0149                             {
; 0000 014A                             delay=0;
	CALL SUBOPT_0x22
; 0000 014B                             int_temp[2]++;
	__POINTW2MN _int_temp,4
	CALL SUBOPT_0x10
; 0000 014C                             int_temp[2]=int_temp[2]>9?0:int_temp[2];
	__GETW2MN _int_temp,4
	SBIW R26,10
	BRLT _0x115
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x116
_0x115:
	CALL SUBOPT_0x29
_0x116:
	CALL SUBOPT_0x2A
; 0000 014D                             lcd_gotoxy(5,3);
; 0000 014E                             lcd_putchar(int_temp[2]+48);
; 0000 014F                             }
; 0000 0150 
; 0000 0151                         }
_0x114:
	RJMP _0x111
_0x113:
; 0000 0152                         falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 0153                     }
; 0000 0154                     if(DOWN==0)
_0x110:
	SBIC 0x19,3
	RJMP _0x11B
; 0000 0155                     {
; 0000 0156                         while(DOWN==0)
_0x11C:
	SBIC 0x19,3
	RJMP _0x11E
; 0000 0157                         {
; 0000 0158                             if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0x11F
; 0000 0159                             {
; 0000 015A                             delay=0;
	CALL SUBOPT_0x22
; 0000 015B                             int_temp[2]--;
	__POINTW2MN _int_temp,4
	CALL SUBOPT_0x25
; 0000 015C                             int_temp[2]=int_temp[2]<0?9:int_temp[2];
	__GETB2MN _int_temp,5
	TST  R26
	BRPL _0x120
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0x121
_0x120:
	CALL SUBOPT_0x29
_0x121:
	CALL SUBOPT_0x2A
; 0000 015D                             lcd_gotoxy(5,3);
; 0000 015E                             lcd_putchar(int_temp[2]+48);
; 0000 015F                             }
; 0000 0160                         }
_0x11F:
	RJMP _0x11C
_0x11E:
; 0000 0161                         falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 0162                     }
; 0000 0163                 }
_0x11B:
; 0000 0164                 if (mode_temp==4)
_0x10F:
	LDI  R30,LOW(4)
	CP   R30,R4
	BRNE _0x126
; 0000 0165                 {
; 0000 0166                     if(UP==0)
	SBIC 0x19,6
	RJMP _0x127
; 0000 0167                     {
; 0000 0168                         while(UP==0)
_0x128:
	SBIC 0x19,6
	RJMP _0x12A
; 0000 0169                         {
; 0000 016A                             if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0x12B
; 0000 016B                             {
; 0000 016C                             delay=0;
	CALL SUBOPT_0x22
; 0000 016D                             int_temp[3]++;
	__POINTW2MN _int_temp,6
	CALL SUBOPT_0x10
; 0000 016E                             int_temp[3]=int_temp[3]>9?0:int_temp[3];
	__GETW2MN _int_temp,6
	SBIW R26,10
	BRLT _0x12C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x12D
_0x12C:
	CALL SUBOPT_0x2B
_0x12D:
	CALL SUBOPT_0x2C
; 0000 016F                             lcd_gotoxy(7,3);
; 0000 0170                             lcd_putchar(int_temp[3]+48);
; 0000 0171                             }
; 0000 0172 
; 0000 0173                         }
_0x12B:
	RJMP _0x128
_0x12A:
; 0000 0174                         falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 0175                     }
; 0000 0176                     if(DOWN==0)
_0x127:
	SBIC 0x19,3
	RJMP _0x132
; 0000 0177                     {
; 0000 0178                         while(DOWN==0)
_0x133:
	SBIC 0x19,3
	RJMP _0x135
; 0000 0179                         {
; 0000 017A                             if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0x136
; 0000 017B                             {
; 0000 017C                             delay=0;
	CALL SUBOPT_0x22
; 0000 017D                             int_temp[3]--;
	__POINTW2MN _int_temp,6
	CALL SUBOPT_0x25
; 0000 017E                             int_temp[3]=int_temp[3]<0?9:int_temp[3];
	__GETB2MN _int_temp,7
	TST  R26
	BRPL _0x137
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0x138
_0x137:
	CALL SUBOPT_0x2B
_0x138:
	CALL SUBOPT_0x2C
; 0000 017F                             lcd_gotoxy(7,3);
; 0000 0180                             lcd_putchar(int_temp[3]+48);
; 0000 0181                             }
; 0000 0182                         }
_0x136:
	RJMP _0x133
_0x135:
; 0000 0183                         falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 0184                     }
; 0000 0185                 }
_0x132:
; 0000 0186             }
_0x126:
_0x10E:
; 0000 0187         }
_0xEF:
; 0000 0188     }
; 0000 0189     //Set humi
; 0000 018A     if (set==3)
_0x87:
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ PC+3
	JMP _0x13D
; 0000 018B     {
; 0000 018C         if(MODE==0)
	SBIC 0x19,2
	RJMP _0x13E
; 0000 018D         {
; 0000 018E             while(MODE==0);
_0x13F:
	SBIS 0x19,2
	RJMP _0x13F
; 0000 018F             falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 0190             mode_humi++;
	INC  R7
; 0000 0191             mode_humi=mode_humi>4?1:mode_humi;
	LDI  R30,LOW(4)
	CP   R30,R7
	BRSH _0x145
	LDI  R30,LOW(1)
	RJMP _0x146
_0x145:
	MOV  R30,R7
_0x146:
	MOV  R7,R30
; 0000 0192         }
; 0000 0193 
; 0000 0194         if (mode_humi==1)
_0x13E:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x148
; 0000 0195         {
; 0000 0196             if(UP==0)
	SBIC 0x19,6
	RJMP _0x149
; 0000 0197             {
; 0000 0198                 while(UP==0);
_0x14A:
	SBIS 0x19,6
	RJMP _0x14A
; 0000 0199                 if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0x14D
; 0000 019A                 {
; 0000 019B                 delay==0;
	LDS  R26,_delay
	LDS  R27,_delay+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EQW12
; 0000 019C                 falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 019D                 int_humi[0]++;
	LDI  R26,LOW(_int_humi)
	LDI  R27,HIGH(_int_humi)
	CALL SUBOPT_0x10
; 0000 019E                 int_humi[0]=int_humi[0]>1?0:int_humi[0];
	LDS  R26,_int_humi
	LDS  R27,_int_humi+1
	SBIW R26,2
	BRLT _0x151
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x152
_0x151:
	CALL SUBOPT_0x2E
_0x152:
	CALL SUBOPT_0x2F
; 0000 019F                 lcd_gotoxy(14,3);
; 0000 01A0                 lcd_putchar(int_humi[0]+48);
; 0000 01A1                 }
; 0000 01A2             }
_0x14D:
; 0000 01A3 
; 0000 01A4             if(DOWN==0)
_0x149:
	SBIC 0x19,3
	RJMP _0x154
; 0000 01A5             {
; 0000 01A6                 while(DOWN==0);
_0x155:
	SBIS 0x19,3
	RJMP _0x155
; 0000 01A7                 if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0x158
; 0000 01A8                 {
; 0000 01A9                 delay=0;
	CALL SUBOPT_0x22
; 0000 01AA                 falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 01AB                 int_humi[0]--;
	LDI  R26,LOW(_int_humi)
	LDI  R27,HIGH(_int_humi)
	CALL SUBOPT_0x25
; 0000 01AC                 int_humi[0]=int_humi[0]<0?1:int_humi[0];
	LDS  R26,_int_humi+1
	TST  R26
	BRPL _0x15C
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x15D
_0x15C:
	CALL SUBOPT_0x2E
_0x15D:
	CALL SUBOPT_0x2F
; 0000 01AD                 lcd_gotoxy(14,3);
; 0000 01AE                 lcd_putchar(int_humi[0]+48);
; 0000 01AF                 }
; 0000 01B0             }
_0x158:
; 0000 01B1         }
_0x154:
; 0000 01B2 
; 0000 01B3         if (!int_humi[0])
_0x148:
	CALL SUBOPT_0x2E
	SBIW R30,0
	BREQ PC+3
	JMP _0x15F
; 0000 01B4         {
; 0000 01B5             if (mode_humi==2)
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x160
; 0000 01B6             {
; 0000 01B7                 if(UP==0)
	SBIC 0x19,6
	RJMP _0x161
; 0000 01B8                 {
; 0000 01B9                     while(UP==0)
_0x162:
	SBIC 0x19,6
	RJMP _0x164
; 0000 01BA                     {
; 0000 01BB                         if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0x165
; 0000 01BC                         {
; 0000 01BD                         delay=0;
	CALL SUBOPT_0x22
; 0000 01BE                         int_humi[1]++;
	__POINTW2MN _int_humi,2
	CALL SUBOPT_0x10
; 0000 01BF                         int_humi[1]=int_humi[1]>9?0:int_humi[1];
	__GETW2MN _int_humi,2
	SBIW R26,10
	BRLT _0x166
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x167
_0x166:
	CALL SUBOPT_0x30
_0x167:
	CALL SUBOPT_0x31
; 0000 01C0                         lcd_gotoxy(15,3);
; 0000 01C1                         lcd_putchar(int_humi[1]+48);
; 0000 01C2                         }
; 0000 01C3                     }
_0x165:
	RJMP _0x162
_0x164:
; 0000 01C4                     falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 01C5                 }
; 0000 01C6                 if(DOWN==0)
_0x161:
	SBIC 0x19,3
	RJMP _0x16C
; 0000 01C7                 {
; 0000 01C8                     while(DOWN==0)
_0x16D:
	SBIC 0x19,3
	RJMP _0x16F
; 0000 01C9                     {
; 0000 01CA                         if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0x170
; 0000 01CB                         {
; 0000 01CC                         delay=0;
	CALL SUBOPT_0x22
; 0000 01CD                         int_humi[1]--;
	__POINTW2MN _int_humi,2
	CALL SUBOPT_0x25
; 0000 01CE                         int_humi[1]=int_humi[1]<0?9:int_humi[1];
	__GETB2MN _int_humi,3
	TST  R26
	BRPL _0x171
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0x172
_0x171:
	CALL SUBOPT_0x30
_0x172:
	CALL SUBOPT_0x31
; 0000 01CF                         lcd_gotoxy(15,3);
; 0000 01D0                         lcd_putchar(int_humi[1]+48);
; 0000 01D1                         }
; 0000 01D2                     }
_0x170:
	RJMP _0x16D
_0x16F:
; 0000 01D3                     falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 01D4                 }
; 0000 01D5             }
_0x16C:
; 0000 01D6             if (mode_humi==3)
_0x160:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0x177
; 0000 01D7             {
; 0000 01D8                 if(UP==0)
	SBIC 0x19,6
	RJMP _0x178
; 0000 01D9                 {
; 0000 01DA                     while(UP==0)
_0x179:
	SBIC 0x19,6
	RJMP _0x17B
; 0000 01DB                     {
; 0000 01DC                         if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0x17C
; 0000 01DD                         {
; 0000 01DE                         delay=0;
	CALL SUBOPT_0x22
; 0000 01DF                         int_humi[2]++;
	__POINTW2MN _int_humi,4
	CALL SUBOPT_0x10
; 0000 01E0                         int_humi[2]=int_humi[2]>9?0:int_humi[2];
	__GETW2MN _int_humi,4
	SBIW R26,10
	BRLT _0x17D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x17E
_0x17D:
	CALL SUBOPT_0x32
_0x17E:
	CALL SUBOPT_0x33
; 0000 01E1                         lcd_gotoxy(16,3);
; 0000 01E2                         lcd_putchar(int_humi[2]+48);
; 0000 01E3                         }
; 0000 01E4                     }
_0x17C:
	RJMP _0x179
_0x17B:
; 0000 01E5                     falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 01E6                 }
; 0000 01E7                 if(DOWN==0)
_0x178:
	SBIC 0x19,3
	RJMP _0x183
; 0000 01E8                 {
; 0000 01E9                     while(DOWN==0)
_0x184:
	SBIC 0x19,3
	RJMP _0x186
; 0000 01EA                     {
; 0000 01EB                         if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0x187
; 0000 01EC                         {
; 0000 01ED                         delay=0;
	CALL SUBOPT_0x22
; 0000 01EE                         int_humi[2]--;
	__POINTW2MN _int_humi,4
	CALL SUBOPT_0x25
; 0000 01EF                         int_humi[2]=int_humi[2]<0?9:int_humi[2];
	__GETB2MN _int_humi,5
	TST  R26
	BRPL _0x188
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0x189
_0x188:
	CALL SUBOPT_0x32
_0x189:
	CALL SUBOPT_0x33
; 0000 01F0                         lcd_gotoxy(16,3);
; 0000 01F1                         lcd_putchar(int_humi[2]+48);
; 0000 01F2                         }
; 0000 01F3                     }
_0x187:
	RJMP _0x184
_0x186:
; 0000 01F4                     falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 01F5                 }
; 0000 01F6             }
_0x183:
; 0000 01F7             if (mode_humi==4)
_0x177:
	LDI  R30,LOW(4)
	CP   R30,R7
	BRNE _0x18E
; 0000 01F8             {
; 0000 01F9                 if(UP==0)
	SBIC 0x19,6
	RJMP _0x18F
; 0000 01FA                 {
; 0000 01FB                     while(UP==0)
_0x190:
	SBIC 0x19,6
	RJMP _0x192
; 0000 01FC                     {
; 0000 01FD                         if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0x193
; 0000 01FE                         {
; 0000 01FF                         delay=0;
	CALL SUBOPT_0x22
; 0000 0200                         int_humi[3]++;
	__POINTW2MN _int_humi,6
	CALL SUBOPT_0x10
; 0000 0201                         int_humi[3]=int_humi[3]>9?0:int_humi[3];
	__GETW2MN _int_humi,6
	SBIW R26,10
	BRLT _0x194
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x195
_0x194:
	CALL SUBOPT_0x34
_0x195:
	CALL SUBOPT_0x35
; 0000 0202                         lcd_gotoxy(18,3);
; 0000 0203                         lcd_putchar(int_humi[3]+48);
; 0000 0204                         }
; 0000 0205                     }
_0x193:
	RJMP _0x190
_0x192:
; 0000 0206                     falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 0207                 }
; 0000 0208                 if(DOWN==0)
_0x18F:
	SBIC 0x19,3
	RJMP _0x19A
; 0000 0209                 {
; 0000 020A                     while(DOWN==0)
_0x19B:
	SBIC 0x19,3
	RJMP _0x19D
; 0000 020B                     {
; 0000 020C                         if(delay>=delay_bt)
	CALL SUBOPT_0x21
	BRLO _0x19E
; 0000 020D                         {
; 0000 020E                         delay=0;
	CALL SUBOPT_0x22
; 0000 020F                         int_humi[3]--;
	__POINTW2MN _int_humi,6
	CALL SUBOPT_0x25
; 0000 0210                         int_humi[3]=int_humi[3]<0?9:int_humi[3];
	__GETB2MN _int_humi,7
	TST  R26
	BRPL _0x19F
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RJMP _0x1A0
_0x19F:
	CALL SUBOPT_0x34
_0x1A0:
	CALL SUBOPT_0x35
; 0000 0211                         lcd_gotoxy(18,3);
; 0000 0212                         lcd_putchar(int_humi[3]+48);
; 0000 0213                         }
; 0000 0214                     }
_0x19E:
	RJMP _0x19B
_0x19D:
; 0000 0215                     falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 0216                 }
; 0000 0217             }
_0x19A:
; 0000 0218 
; 0000 0219         }
_0x18E:
; 0000 021A         else
	RJMP _0x1A5
_0x15F:
; 0000 021B         {
; 0000 021C             int_humi[1]=0;
	__POINTW1MN _int_humi,2
	CALL SUBOPT_0x2D
; 0000 021D             int_humi[2]=0;
	__POINTW1MN _int_humi,4
	CALL SUBOPT_0x2D
; 0000 021E             int_humi[3]=0;
	__POINTW1MN _int_humi,6
	CALL SUBOPT_0x2D
; 0000 021F             mode_humi=1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 0220         }
_0x1A5:
; 0000 0221     }
; 0000 0222 
; 0000 0223     //Ok chap nhan gia tri, CANCEL huy cai dat nhiet do va do am
; 0000 0224     if(set!=1)
_0x13D:
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE PC+3
	JMP _0x1A6
; 0000 0225     {
; 0000 0226         if(OK==0)
	SBIC 0x19,5
	RJMP _0x1A7
; 0000 0227         {
; 0000 0228             while(OK==0);
_0x1A8:
	SBIS 0x19,5
	RJMP _0x1A8
; 0000 0229             falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 022A 
; 0000 022B             int_temp_ok[0]=int_temp[0];
	CALL SUBOPT_0x23
	STS  _int_temp_ok,R30
	STS  _int_temp_ok+1,R31
; 0000 022C             int_temp_ok[1]=int_temp[1];
	CALL SUBOPT_0x27
	__PUTW1MN _int_temp_ok,2
; 0000 022D             int_temp_ok[2]=int_temp[2];
	CALL SUBOPT_0x29
	__PUTW1MN _int_temp_ok,4
; 0000 022E             int_temp_ok[3]=int_temp[3];
	CALL SUBOPT_0x2B
	__PUTW1MN _int_temp_ok,6
; 0000 022F 
; 0000 0230             int_humi_ok[0]=int_humi[0];
	CALL SUBOPT_0x2E
	STS  _int_humi_ok,R30
	STS  _int_humi_ok+1,R31
; 0000 0231             int_humi_ok[1]=int_humi[1];
	CALL SUBOPT_0x30
	__PUTW1MN _int_humi_ok,2
; 0000 0232             int_humi_ok[2]=int_humi[2];
	CALL SUBOPT_0x32
	__PUTW1MN _int_humi_ok,4
; 0000 0233             int_humi_ok[3]=int_humi[3];
	CALL SUBOPT_0x34
	__PUTW1MN _int_humi_ok,6
; 0000 0234 
; 0000 0235             //Save to EEPROM
; 0000 0236             eep_temp_ok[0]=int_temp_ok[0];
	CALL SUBOPT_0x36
	LDI  R26,LOW(_eep_temp_ok)
	LDI  R27,HIGH(_eep_temp_ok)
	CALL __EEPROMWRW
; 0000 0237             eep_temp_ok[1]=int_temp_ok[1];
	__POINTW2MN _eep_temp_ok,2
	CALL SUBOPT_0x37
	CALL __EEPROMWRW
; 0000 0238             eep_temp_ok[2]=int_temp_ok[2];
	__POINTW2MN _eep_temp_ok,4
	CALL SUBOPT_0x38
	CALL __EEPROMWRW
; 0000 0239             eep_temp_ok[3]=int_temp_ok[3];
	__POINTW2MN _eep_temp_ok,6
	CALL SUBOPT_0x39
	CALL __EEPROMWRW
; 0000 023A 
; 0000 023B             eep_humi_ok[0]=int_humi_ok[0];
	CALL SUBOPT_0x3A
	LDI  R26,LOW(_eep_humi_ok)
	LDI  R27,HIGH(_eep_humi_ok)
	CALL __EEPROMWRW
; 0000 023C             eep_humi_ok[1]=int_humi_ok[1];
	__POINTW2MN _eep_humi_ok,2
	CALL SUBOPT_0x3B
	CALL __EEPROMWRW
; 0000 023D             eep_humi_ok[2]=int_humi_ok[2];
	__POINTW2MN _eep_humi_ok,4
	CALL SUBOPT_0x3C
	CALL __EEPROMWRW
; 0000 023E             eep_humi_ok[3]=int_humi_ok[3];
	__POINTW2MN _eep_humi_ok,6
	CALL SUBOPT_0x3D
	CALL __EEPROMWRW
; 0000 023F 
; 0000 0240 
; 0000 0241             set=1;
	CALL SUBOPT_0x3E
; 0000 0242             mode_temp=1;
; 0000 0243             mode_humi=1;
; 0000 0244             //lcd_clear();
; 0000 0245         }
; 0000 0246 
; 0000 0247         if (CANCEL==0)
_0x1A7:
	SBIC 0x19,4
	RJMP _0x1AE
; 0000 0248         {
; 0000 0249             while(CANCEL==0);
_0x1AF:
	SBIS 0x19,4
	RJMP _0x1AF
; 0000 024A             falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 024B 
; 0000 024C             int_temp[0]=int_temp_ok[0];
	CALL SUBOPT_0x36
	STS  _int_temp,R30
	STS  _int_temp+1,R31
; 0000 024D             int_temp[1]=int_temp_ok[1];
	CALL SUBOPT_0x37
	__PUTW1MN _int_temp,2
; 0000 024E             int_temp[2]=int_temp_ok[2];
	CALL SUBOPT_0x38
	__PUTW1MN _int_temp,4
; 0000 024F             int_temp[3]=int_temp_ok[3];
	CALL SUBOPT_0x39
	__PUTW1MN _int_temp,6
; 0000 0250 
; 0000 0251             int_humi[0]=int_humi_ok[0];
	CALL SUBOPT_0x3A
	STS  _int_humi,R30
	STS  _int_humi+1,R31
; 0000 0252             int_humi[1]=int_humi_ok[1];
	CALL SUBOPT_0x3B
	__PUTW1MN _int_humi,2
; 0000 0253             int_humi[2]=int_humi_ok[2];
	CALL SUBOPT_0x3C
	__PUTW1MN _int_humi,4
; 0000 0254             int_humi[3]=int_humi_ok[3];
	CALL SUBOPT_0x3D
	__PUTW1MN _int_humi,6
; 0000 0255             set=1;
	CALL SUBOPT_0x3E
; 0000 0256             mode_temp=1;
; 0000 0257             mode_humi=1;
; 0000 0258             //lcd_clear();
; 0000 0259         }
; 0000 025A     }
_0x1AE:
; 0000 025B     else
	RJMP _0x1B5
_0x1A6:
; 0000 025C     {
; 0000 025D         if (CANCEL==0)
	SBIC 0x19,4
	RJMP _0x1B6
; 0000 025E         {
; 0000 025F             while(CANCEL==0);
_0x1B7:
	SBIS 0x19,4
	RJMP _0x1B7
; 0000 0260             falling_edge(SPEAK_PORT,SPEAK_PIN);
	CALL SUBOPT_0x20
; 0000 0261             set=1;
	CALL SUBOPT_0x3E
; 0000 0262             mode_temp=1;
; 0000 0263             mode_humi=1;
; 0000 0264             dao_pwm=~dao_pwm;
	LDI  R30,LOW(2)
	EOR  R2,R30
; 0000 0265             //lcd_clear();
; 0000 0266         }
; 0000 0267     }
_0x1B6:
_0x1B5:
; 0000 0268 
; 0000 0269 
; 0000 026A     #asm ("cli")
	cli
; 0000 026B     delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 026C     if(set==1)      SHT_ReadTemHumi(&nhiet_do,&do_am);
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x1BD
	CALL SUBOPT_0x1F
; 0000 026D     #asm ("sei")
_0x1BD:
	sei
; 0000 026E 
; 0000 026F     if(dao_pwm==0)
	SBRC R2,1
	RJMP _0x1BE
; 0000 0270     {
; 0000 0271         TCCR1A=(1<<COM1A1)|(1<<COM1B1)|(1<<WGM11);
	LDI  R30,LOW(162)
	OUT  0x2F,R30
; 0000 0272         TCCR1B=(1<<WGM13)|(1<<WGM12)|(1<<CS11);
	LDI  R30,LOW(26)
	CALL SUBOPT_0x3F
; 0000 0273         lcd_gotoxy(0,2);
; 0000 0274         lcd_puts("           Ctrl: On ");
	__POINTW2MN _0x76,75
	RJMP _0x1DE
; 0000 0275     }
; 0000 0276     else
_0x1BE:
; 0000 0277     {
; 0000 0278         TCCR1A=0;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0279         TCCR1B=0;
	CALL SUBOPT_0x3F
; 0000 027A         lcd_gotoxy(0,2);
; 0000 027B         lcd_puts("           Ctrl: Off");
	__POINTW2MN _0x76,96
_0x1DE:
	CALL _lcd_puts
; 0000 027C     }
; 0000 027D 
; 0000 027E     //Hien Thi Nhiet Do
; 0000 027F     lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
; 0000 0280     lcd_puts("Temp:");
	__POINTW2MN _0x76,117
	CALL _lcd_puts
; 0000 0281     lcd_display_sensor(nhiet_do);
	LDS  R26,_nhiet_do
	LDS  R27,_nhiet_do+1
	LDS  R24,_nhiet_do+2
	LDS  R25,_nhiet_do+3
	CALL _lcd_display_sensor
; 0000 0282     lcd_putchar(0x20);
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 0283     lcd_putchar(0xdf);
	LDI  R26,LOW(223)
	CALL _lcd_putchar
; 0000 0284     lcd_puts("C      ");
	__POINTW2MN _0x76,123
	CALL SUBOPT_0x1A
; 0000 0285 
; 0000 0286     //Hien thi Do Am
; 0000 0287     lcd_gotoxy(0,1);
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
; 0000 0288     lcd_puts("Humi:");
	__POINTW2MN _0x76,131
	CALL _lcd_puts
; 0000 0289     lcd_display_sensor(do_am);
	LDS  R26,_do_am
	LDS  R27,_do_am+1
	LDS  R24,_do_am+2
	LDS  R25,_do_am+3
	CALL _lcd_display_sensor
; 0000 028A     lcd_puts(" %       ");
	__POINTW2MN _0x76,137
	CALL _lcd_puts
; 0000 028B 
; 0000 028C //    lcd_gotoxy(0,2);
; 0000 028D //    lcd_puts("                    ");
; 0000 028E 
; 0000 028F     //Luu gia tri set nhiet do va set do am
; 0000 0290     set_temp_int= (int_temp[0]*1000 + int_temp[1]*100 + int_temp[2]*10 + int_temp[3]) ;
	CALL SUBOPT_0x23
	CALL SUBOPT_0x40
	CALL SUBOPT_0x27
	CALL SUBOPT_0x41
	CALL SUBOPT_0x29
	CALL SUBOPT_0x42
	CALL SUBOPT_0x2B
	ADD  R30,R26
	ADC  R31,R27
	MOVW R8,R30
; 0000 0291     set_humi_int= (int_humi[0]*1000 + int_humi[1]*100 + int_humi[2]*10 + int_humi[3]);
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x40
	CALL SUBOPT_0x30
	CALL SUBOPT_0x41
	CALL SUBOPT_0x32
	CALL SUBOPT_0x42
	CALL SUBOPT_0x34
	ADD  R30,R26
	ADC  R31,R27
	MOVW R10,R30
; 0000 0292     set_temp_int_ok= (int_temp_ok[0]*1000 + int_temp_ok[1]*100 + int_temp_ok[2]*10 + int_temp_ok[3]) ;
	CALL SUBOPT_0x36
	CALL SUBOPT_0x40
	CALL SUBOPT_0x37
	CALL SUBOPT_0x41
	CALL SUBOPT_0x38
	CALL SUBOPT_0x42
	CALL SUBOPT_0x39
	ADD  R30,R26
	ADC  R31,R27
	MOVW R12,R30
; 0000 0293     set_humi_int_ok= (int_humi_ok[0]*1000 + int_humi_ok[1]*100 + int_humi_ok[2]*10 + int_humi_ok[3]);
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x40
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x41
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x42
	CALL SUBOPT_0x3D
	ADD  R30,R26
	ADC  R31,R27
	STS  _set_humi_int_ok,R30
	STS  _set_humi_int_ok+1,R31
; 0000 0294 
; 0000 0295     set_temp = (float) set_temp_int/(float)10;
	MOVW R30,R8
	CALL SUBOPT_0x43
	STS  _set_temp,R30
	STS  _set_temp+1,R31
	STS  _set_temp+2,R22
	STS  _set_temp+3,R23
; 0000 0296     set_humi = (float) set_humi_int/(float)10;
	MOVW R30,R10
	CALL SUBOPT_0x43
	STS  _set_humi,R30
	STS  _set_humi+1,R31
	STS  _set_humi+2,R22
	STS  _set_humi+3,R23
; 0000 0297     set_temp_ok = (float) set_temp_int_ok/(float)10;
	MOVW R30,R12
	CALL SUBOPT_0x43
	STS  _set_temp_ok,R30
	STS  _set_temp_ok+1,R31
	STS  _set_temp_ok+2,R22
	STS  _set_temp_ok+3,R23
; 0000 0298     set_humi_ok = (float) set_humi_int_ok/(float)10;
	LDS  R30,_set_humi_int_ok
	LDS  R31,_set_humi_int_ok+1
	CALL SUBOPT_0x43
	STS  _set_humi_ok,R30
	STS  _set_humi_ok+1,R31
	STS  _set_humi_ok+2,R22
	STS  _set_humi_ok+3,R23
; 0000 0299 
; 0000 029A //    set_temp= (float)(int_temp[0]*1000 + int_temp[1]*100 + int_temp[2]*10 + int_temp[3])/((float)10);
; 0000 029B //    set_humi= (float)(int_humi[0]*1000 + int_humi[1]*100 + int_humi[2]*10 + int_humi[3])/((float)10);
; 0000 029C //
; 0000 029D //    set_temp_ok= (float)(int_temp_ok[0]*1000 + int_temp_ok[1]*100 + int_temp_ok[2]*10 + int_temp_ok[3])/((float)10);
; 0000 029E //    set_humi_ok= (float)(int_humi_ok[0]*1000 + int_humi_ok[1]*100 + int_humi_ok[2]*10 + int_humi_ok[3])/((float)10);
; 0000 029F 
; 0000 02A0    // Hien thi Set Temp
; 0000 02A1     lcd_gotoxy(0,3);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x44
; 0000 02A2     lcd_putsf("ST");
	__POINTW2FN _0x0,147
	CALL _lcd_putsf
; 0000 02A3     if(set==2)  lcd_putchar(0x00);
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x1C0
	LDI  R26,LOW(0)
	RJMP _0x1DF
; 0000 02A4     else        lcd_putchar('>');
_0x1C0:
	LDI  R26,LOW(62)
_0x1DF:
	CALL _lcd_putchar
; 0000 02A5 
; 0000 02A6     if(set==1)  lcd_display_set(set_temp_int_ok);
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x1C2
	MOVW R26,R12
	RJMP _0x1E0
; 0000 02A7     else  lcd_display_set(set_temp_int);
_0x1C2:
	MOVW R26,R8
_0x1E0:
	CALL _lcd_display_set
; 0000 02A8     lcd_gotoxy(8,3);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x44
; 0000 02A9     lcd_putchar(0xdf);
	LDI  R26,LOW(223)
	CALL _lcd_putchar
; 0000 02AA     lcd_putsf("C ");
	__POINTW2FN _0x0,150
	CALL _lcd_putsf
; 0000 02AB 
; 0000 02AC     //Hien thi Set Humi
; 0000 02AD     lcd_puts("SH");
	__POINTW2MN _0x76,147
	CALL _lcd_puts
; 0000 02AE     if(set==3)  lcd_putchar(0x00);
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x1C4
	LDI  R26,LOW(0)
	RJMP _0x1E1
; 0000 02AF     else        lcd_putchar('>');
_0x1C4:
	LDI  R26,LOW(62)
_0x1E1:
	CALL _lcd_putchar
; 0000 02B0 
; 0000 02B1     if(set==1)  lcd_display_set(set_humi_int_ok);
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x1C6
	LDS  R26,_set_humi_int_ok
	LDS  R27,_set_humi_int_ok+1
	RJMP _0x1E2
; 0000 02B2     else     lcd_display_set(set_humi_int);
_0x1C6:
	MOVW R26,R10
_0x1E2:
	CALL _lcd_display_set
; 0000 02B3     lcd_gotoxy(19,3);
	LDI  R30,LOW(19)
	CALL SUBOPT_0x44
; 0000 02B4     lcd_putchar('%');
	LDI  R26,LOW(37)
	CALL _lcd_putchar
; 0000 02B5 
; 0000 02B6 //    lcd_gotoxy(0,2);
; 0000 02B7 //    lcd_display_pwm(pwm_a);
; 0000 02B8 
; 0000 02B9     //Flashing for Set_Temp
; 0000 02BA     //vi tri con tro: 3.4.5.7 hang 3 //
; 0000 02BB     if (set==2)
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x1C8
; 0000 02BC     {
; 0000 02BD         if(mode_temp==1)
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x1C9
; 0000 02BE         {
; 0000 02BF             if(!state)
	SBRC R2,0
	RJMP _0x1CA
; 0000 02C0             {
; 0000 02C1                 lcd_gotoxy(3,3);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x44
; 0000 02C2                 lcd_putchar(0x20);
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 02C3             }
; 0000 02C4         }
_0x1CA:
; 0000 02C5         if(mode_temp==2)
_0x1C9:
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x1CB
; 0000 02C6         {
; 0000 02C7             if(!state)
	SBRC R2,0
	RJMP _0x1CC
; 0000 02C8             {
; 0000 02C9                 lcd_gotoxy(4,3);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x44
; 0000 02CA                 lcd_putchar(0x20);
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 02CB             }
; 0000 02CC         }
_0x1CC:
; 0000 02CD         if(mode_temp==3)
_0x1CB:
	LDI  R30,LOW(3)
	CP   R30,R4
	BRNE _0x1CD
; 0000 02CE         {
; 0000 02CF             if(!state)
	SBRC R2,0
	RJMP _0x1CE
; 0000 02D0             {
; 0000 02D1                 lcd_gotoxy(5,3);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x44
; 0000 02D2                 lcd_putchar(0x20);
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 02D3             }
; 0000 02D4         }
_0x1CE:
; 0000 02D5         if(mode_temp==4)
_0x1CD:
	LDI  R30,LOW(4)
	CP   R30,R4
	BRNE _0x1CF
; 0000 02D6         {
; 0000 02D7             if(!state)
	SBRC R2,0
	RJMP _0x1D0
; 0000 02D8             {
; 0000 02D9                 lcd_gotoxy(7,3);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x44
; 0000 02DA                 lcd_putchar(0x20);
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 02DB             }
; 0000 02DC         }
_0x1D0:
; 0000 02DD     }
_0x1CF:
; 0000 02DE     //Flashing for Set_Humi
; 0000 02DF     //vi tri con tro: 14.15.16.18 hang 3
; 0000 02E0     if(set==3)
_0x1C8:
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x1D1
; 0000 02E1     {
; 0000 02E2         if(mode_humi==1)
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x1D2
; 0000 02E3             if(!state)
	SBRC R2,0
	RJMP _0x1D3
; 0000 02E4             {
; 0000 02E5                 lcd_gotoxy(14,3);
	LDI  R30,LOW(14)
	CALL SUBOPT_0x44
; 0000 02E6                 lcd_putchar(0x20);
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 02E7             }
; 0000 02E8         if(mode_humi==2)
_0x1D3:
_0x1D2:
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0x1D4
; 0000 02E9             if(!state)
	SBRC R2,0
	RJMP _0x1D5
; 0000 02EA             {
; 0000 02EB                 lcd_gotoxy(15,3);
	LDI  R30,LOW(15)
	CALL SUBOPT_0x44
; 0000 02EC                 lcd_putchar(0x20);
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 02ED             }
; 0000 02EE         if(mode_humi==3)
_0x1D5:
_0x1D4:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0x1D6
; 0000 02EF             if(!state)
	SBRC R2,0
	RJMP _0x1D7
; 0000 02F0             {
; 0000 02F1                 lcd_gotoxy(16,3);
	LDI  R30,LOW(16)
	CALL SUBOPT_0x44
; 0000 02F2                 lcd_putchar(0x20);
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 02F3             }
; 0000 02F4         if(mode_humi==4)
_0x1D7:
_0x1D6:
	LDI  R30,LOW(4)
	CP   R30,R7
	BRNE _0x1D8
; 0000 02F5             if(!state)
	SBRC R2,0
	RJMP _0x1D9
; 0000 02F6             {
; 0000 02F7                 lcd_gotoxy(18,3);
	LDI  R30,LOW(18)
	CALL SUBOPT_0x44
; 0000 02F8                 lcd_putchar(0x20);
	LDI  R26,LOW(32)
	CALL _lcd_putchar
; 0000 02F9             }
; 0000 02FA     }
_0x1D9:
_0x1D8:
; 0000 02FB }
_0x1D1:
	RJMP _0x7A
; 0000 02FC }
_0x1DA:
	RJMP _0x1DA

	.DSEG
_0x76:
	.BYTE 0x96

	.CSEG
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

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
	ST   -Y,R26
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x18,3
	RJMP _0x2020005
_0x2020004:
	CBI  0x18,3
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x18,2
	RJMP _0x2020007
_0x2020006:
	CBI  0x18,2
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x18,1
	RJMP _0x2020009
_0x2020008:
	CBI  0x18,1
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x18,0
	RJMP _0x202000B
_0x202000A:
	CBI  0x18,0
_0x202000B:
	__DELAY_USB 11
	SBI  0x12,0
	__DELAY_USB 27
	CBI  0x12,0
	__DELAY_USB 27
	RJMP _0x20A0001
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RJMP _0x20A0001
_lcd_write_byte:
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL __lcd_write_data
	SBI  0x12,6
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x12,6
	RJMP _0x20A0003
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R6,Y+1
	LD   R30,Y
	STS  __lcd_y,R30
_0x20A0003:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	CALL SUBOPT_0x45
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0x45
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	MOV  R6,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	LDS  R30,__lcd_maxx
	CP   R6,R30
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x20A0001
_0x2020013:
_0x2020010:
	INC  R6
	SBI  0x12,6
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x12,6
	RJMP _0x20A0001
_lcd_puts:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020016
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	RJMP _0x20A0002
_lcd_putsf:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020019
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020017
_0x2020019:
_0x20A0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	SBI  0x17,3
	SBI  0x17,2
	SBI  0x17,1
	SBI  0x17,0
	SBI  0x11,0
	SBI  0x11,6
	SBI  0x11,1
	CBI  0x12,0
	CBI  0x12,6
	CBI  0x12,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0x46
	CALL SUBOPT_0x46
	CALL SUBOPT_0x46
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 400
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0001:
	ADIW R28,1
	RET

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_int_temp:
	.BYTE 0x8
_int_humi:
	.BYTE 0x8
_int_temp_ok:
	.BYTE 0x8
_int_humi_ok:
	.BYTE 0x8
_set_humi_int_ok:
	.BYTE 0x2
_set_temp:
	.BYTE 0x4
_set_humi:
	.BYTE 0x4
_set_temp_ok:
	.BYTE 0x4
_set_humi_ok:
	.BYTE 0x4
_i:
	.BYTE 0x2
_s:
	.BYTE 0x2
_delay:
	.BYTE 0x2
_nhiet_do:
	.BYTE 0x4
_do_am:
	.BYTE 0x4

	.ESEG
_eep_temp_ok:
	.BYTE 0x8
_eep_humi_ok:
	.BYTE 0x8

	.DSEG
_delay_sampling:
	.BYTE 0x2
_err:
	.BYTE 0x4
_pre_err:
	.BYTE 0x4
_kp:
	.BYTE 0x4
_kd:
	.BYTE 0x4
_ki:
	.BYTE 0x4
_p_part:
	.BYTE 0x4
_i_part:
	.BYTE 0x4
_pre_i_part:
	.BYTE 0x4
_d_part:
	.BYTE 0x4
_output:
	.BYTE 0x4
_humi_err:
	.BYTE 0x4
_humi_pre_err:
	.BYTE 0x4
_humi_kp:
	.BYTE 0x4
_humi_kd:
	.BYTE 0x4
_humi_ki:
	.BYTE 0x4
_humi_p_part:
	.BYTE 0x4
_humi_i_part:
	.BYTE 0x4
_humi_pre_i_part:
	.BYTE 0x4
_humi_d_part:
	.BYTE 0x4
_humi_output:
	.BYTE 0x4
_SHT_Resolution_G000:
	.BYTE 0x1
__base_y_G101:
	.BYTE 0x4
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	__GETD1S 14
	CALL __CFD1U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x3:
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	CALL __PUTPARD2
	__GETD2S 4
	CALL __GETD1S0
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDS  R30,_err
	LDS  R31,_err+1
	LDS  R22,_err+2
	LDS  R23,_err+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	CALL __MULF12
	__GETD2N 0x40C80000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETD1N 0x42800000
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x447A0000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	STS  _output,R30
	STS  _output+1,R31
	STS  _output+2,R22
	STS  _output+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDS  R26,_output
	LDS  R27,_output+1
	LDS  R24,_output+2
	LDS  R25,_output+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__GETD1N 0x459C4000
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	LDS  R30,_humi_err
	LDS  R31,_humi_err+1
	LDS  R22,_humi_err+2
	LDS  R23,_humi_err+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	STS  _humi_output,R30
	STS  _humi_output+1,R31
	STS  _humi_output+2,R22
	STS  _humi_output+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDS  R26,_humi_output
	LDS  R27,_humi_output+1
	LDS  R24,_humi_output+2
	LDS  R25,_humi_output+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x10:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	LDS  R26,_s
	LDS  R27,_s+1
	CPI  R26,LOW(0x898)
	LDI  R30,HIGH(0x898)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	__DELAY_USB 5
	SBI  0x12,2
	__DELAY_USB 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x14:
	MOVW R30,R16
	RCALL SUBOPT_0x3
	__GETD2N 0x3C23D70A
	CALL __MULF12
	__GETD2N 0xC2200000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41C80000
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	CALL __MULF12
	__GETD2N 0x3C23D70A
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	CALL __MULF12
	__GETD2N 0xC0800000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	MOVW R30,R18
	RCALL SUBOPT_0x3
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x19:
	MOVW R30,R16
	RCALL SUBOPT_0x3
	__GETD2N 0x3D23D70A
	CALL __MULF12
	__GETD2N 0xC2200000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1B:
	LDS  R30,_i
	LDS  R31,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1C:
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1D:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1E:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(_nhiet_do)
	LDI  R31,HIGH(_nhiet_do)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_do_am)
	LDI  R27,HIGH(_do_am)
	JMP  _SHT_ReadTemHumi

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0x20:
	SBI  0x18,4
	LDI  R26,LOW(40)
	LDI  R27,0
	CALL _delay_ms
	CBI  0x18,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:102 WORDS
SUBOPT_0x21:
	LDS  R26,_delay
	LDS  R27,_delay+1
	CPI  R26,LOW(0x5DC)
	LDI  R30,HIGH(0x5DC)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(0)
	STS  _delay,R30
	STS  _delay+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	LDS  R30,_int_temp
	LDS  R31,_int_temp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x24:
	STS  _int_temp,R30
	STS  _int_temp+1,R31
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _lcd_gotoxy
	LDS  R26,_int_temp
	SUBI R26,-LOW(48)
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x25:
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	__GETW2MN _int_temp,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x27:
	__GETW1MN _int_temp,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x28:
	__PUTW1MN _int_temp,2
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _lcd_gotoxy
	__GETB2MN _int_temp,2
	SUBI R26,-LOW(48)
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x29:
	__GETW1MN _int_temp,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2A:
	__PUTW1MN _int_temp,4
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _lcd_gotoxy
	__GETB2MN _int_temp,4
	SUBI R26,-LOW(48)
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2B:
	__GETW1MN _int_temp,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2C:
	__PUTW1MN _int_temp,6
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _lcd_gotoxy
	__GETB2MN _int_temp,6
	SUBI R26,-LOW(48)
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	STD  Z+0,R26
	STD  Z+1,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	LDS  R30,_int_humi
	LDS  R31,_int_humi+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2F:
	STS  _int_humi,R30
	STS  _int_humi+1,R31
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _lcd_gotoxy
	LDS  R26,_int_humi
	SUBI R26,-LOW(48)
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	__GETW1MN _int_humi,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x31:
	__PUTW1MN _int_humi,2
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _lcd_gotoxy
	__GETB2MN _int_humi,2
	SUBI R26,-LOW(48)
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	__GETW1MN _int_humi,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x33:
	__PUTW1MN _int_humi,4
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _lcd_gotoxy
	__GETB2MN _int_humi,4
	SUBI R26,-LOW(48)
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	__GETW1MN _int_humi,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x35:
	__PUTW1MN _int_humi,6
	LDI  R30,LOW(18)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _lcd_gotoxy
	__GETB2MN _int_humi,6
	SUBI R26,-LOW(48)
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	LDS  R30,_int_temp_ok
	LDS  R31,_int_temp_ok+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	__GETW1MN _int_temp_ok,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	__GETW1MN _int_temp_ok,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	__GETW1MN _int_temp_ok,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	LDS  R30,_int_humi_ok
	LDS  R31,_int_humi_ok+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	__GETW1MN _int_humi_ok,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	__GETW1MN _int_humi_ok,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	__GETW1MN _int_humi_ok,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3E:
	LDI  R30,LOW(1)
	MOV  R5,R30
	MOV  R4,R30
	MOV  R7,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	OUT  0x2E,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(2)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x40:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	MOVW R22,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x41:
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	__ADDWRR 22,23,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x42:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x43:
	RCALL SUBOPT_0x3
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41200000
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x44:
	ST   -Y,R30
	LDI  R26,LOW(3)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x46:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G101
	__DELAY_USW 400
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__BSTB1:
	CLT
	TST  R30
	BREQ PC+2
	SET
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
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
