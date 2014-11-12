_main:
;TestMe.c,16 :: 		void main() {
;TestMe.c,18 :: 		initialize();
JAL	_initialize+0
NOP	
;TestMe.c,19 :: 		while(1)
L_main0:
;TestMe.c,21 :: 		msg_recieved = getdataCAN();
JAL	_getdataCAN+0
NOP	
;TestMe.c,22 :: 		if (msg_recieved)
BNE	R2, R0, L__main15
NOP	
J	L_main2
NOP	
L__main15:
;TestMe.c,23 :: 		sendDataUART(RxTx_Data);
LUI	R25, #hi_addr(_RxTx_Data+0)
ORI	R25, R25, #lo_addr(_RxTx_Data+0)
JAL	_sendDataUART+0
NOP	
L_main2:
;TestMe.c,24 :: 		}
J	L_main0
NOP	
;TestMe.c,25 :: 		}
L_end_main:
L__main_end_loop:
J	L__main_end_loop
NOP	
; end of _main
_senddataCAN:
;TestMe.c,35 :: 		void senddataCAN(char *buffer, int buffer_len)
ADDIU	SP, SP, -20
SW	RA, 0(SP)
;TestMe.c,37 :: 		AD1PCFG = 0;                                    // Configure AN pins as digital I/O
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
SW	R0, Offset(AD1PCFG+0)(GP)
;TestMe.c,38 :: 		LATF = 0;
SW	R0, Offset(LATF+0)(GP)
;TestMe.c,39 :: 		TRISF = 0;
SW	R0, Offset(TRISF+0)(GP)
;TestMe.c,41 :: 		CAN1Write(ID_1st, buffer, buffer_len, Can_Send_Flags);
LHU	R28, Offset(_Can_Send_Flags+0)(GP)
SEH	R27, R26
MOVZ	R26, R25, R0
ORI	R25, R0, 12111
JAL	_CAN1Write+0
NOP	
;TestMe.c,42 :: 		Delay_100ms(); //TODO: REMOVE?
JAL	_Delay_100ms+0
NOP	
;TestMe.c,43 :: 		}
L_end_senddataCAN:
LW	R28, 16(SP)
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 20
JR	RA
NOP	
; end of _senddataCAN
_getdataCAN:
;TestMe.c,45 :: 		char getdataCAN()
ADDIU	SP, SP, -20
SW	RA, 0(SP)
;TestMe.c,48 :: 		AD1PCFG = 0;                                    // Configure AN pins as digital I/O
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
SW	R0, Offset(AD1PCFG+0)(GP)
;TestMe.c,49 :: 		LATB = 0;
SW	R0, Offset(LATB+0)(GP)
;TestMe.c,50 :: 		TRISB = 0;
SW	R0, Offset(TRISB+0)(GP)
;TestMe.c,52 :: 		Msg_Rcvd = CAN1Read(&Rx_ID, &RxTx_Data, &Rx_Data_Len, &Can_Rcv_Flags);        // receive message
LUI	R28, #hi_addr(_Can_Rcv_Flags+0)
ORI	R28, R28, #lo_addr(_Can_Rcv_Flags+0)
LUI	R27, #hi_addr(_Rx_Data_Len+0)
ORI	R27, R27, #lo_addr(_Rx_Data_Len+0)
LUI	R26, #hi_addr(_RxTx_Data+0)
ORI	R26, R26, #lo_addr(_RxTx_Data+0)
LUI	R25, #hi_addr(_Rx_ID+0)
ORI	R25, R25, #lo_addr(_Rx_ID+0)
JAL	_CAN1Read+0
NOP	
;TestMe.c,53 :: 		return Msg_Rcvd;
;TestMe.c,54 :: 		}
;TestMe.c,53 :: 		return Msg_Rcvd;
;TestMe.c,54 :: 		}
L_end_getdataCAN:
LW	R28, 16(SP)
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 20
JR	RA
NOP	
; end of _getdataCAN
_sendDataUART:
;TestMe.c,65 :: 		void sendDataUART(char *buffer)
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;TestMe.c,67 :: 		UART1_Write_Text(buffer);
JAL	_UART1_Write_Text+0
NOP	
;TestMe.c,68 :: 		}
L_end_sendDataUART:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
JR	RA
NOP	
; end of _sendDataUART
_readUARTData:
;TestMe.c,70 :: 		int readUARTData(char *buffer, int max_size)
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;TestMe.c,74 :: 		int num_char = 0;
; num_char start address is: 16 (R4)
MOVZ	R4, R0, R0
; num_char end address is: 16 (R4)
;TestMe.c,76 :: 		while(num_char < max_size)
L_readUARTData3:
; num_char start address is: 16 (R4)
SEH	R3, R4
SEH	R2, R26
SLT	R2, R3, R2
BNE	R2, R0, L__readUARTData21
NOP	
J	L_readUARTData4
NOP	
L__readUARTData21:
;TestMe.c,78 :: 		if (UART1_Data_Ready() != 1)
JAL	_UART1_Data_Ready+0
NOP	
ANDI	R3, R2, 65535
ORI	R2, R0, 1
BNE	R3, R2, L__readUARTData23
NOP	
J	L_readUARTData5
NOP	
L__readUARTData23:
;TestMe.c,80 :: 		delay_ms(100);
LUI	R24, 4
ORI	R24, R24, 4522
L_readUARTData6:
ADDIU	R24, R24, -1
BNE	R24, R0, L_readUARTData6
NOP	
;TestMe.c,81 :: 		continue;
J	L_readUARTData3
NOP	
;TestMe.c,82 :: 		}
L_readUARTData5:
;TestMe.c,84 :: 		recieve = UART1_Read();
JAL	_UART1_Read+0
NOP	
; recieve start address is: 20 (R5)
ANDI	R5, R2, 65535
;TestMe.c,86 :: 		if(recieve == '\r')
ANDI	R3, R2, 255
ORI	R2, R0, 13
BEQ	R3, R2, L__readUARTData24
NOP	
J	L_readUARTData8
NOP	
L__readUARTData24:
; recieve end address is: 20 (R5)
;TestMe.c,87 :: 		break;
J	L_readUARTData4
NOP	
L_readUARTData8:
;TestMe.c,89 :: 		*buffer = recieve;
; recieve start address is: 20 (R5)
SB	R5, 0(R25)
; recieve end address is: 20 (R5)
;TestMe.c,91 :: 		buffer++;
ADDIU	R2, R25, 1
MOVZ	R25, R2, R0
;TestMe.c,92 :: 		num_char++;
ADDIU	R2, R4, 1
SEH	R4, R2
;TestMe.c,93 :: 		}
J	L_readUARTData3
NOP	
L_readUARTData4:
;TestMe.c,95 :: 		*buffer = 0;
SB	R0, 0(R25)
;TestMe.c,96 :: 		return num_char;
SEH	R2, R4
; num_char end address is: 16 (R4)
;TestMe.c,97 :: 		}
L_end_readUARTData:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
JR	RA
NOP	
; end of _readUARTData
_setPORTC:
;TestMe.c,107 :: 		void setPORTC(int val)
;TestMe.c,109 :: 		LATC = val;       // Invert PORTC value
SEH	R2, R25
SW	R2, Offset(LATC+0)(GP)
;TestMe.c,110 :: 		}
L_end_setPORTC:
JR	RA
NOP	
; end of _setPORTC
_setPORTD:
;TestMe.c,112 :: 		void setPORTD(int val)
;TestMe.c,114 :: 		LATD = val;
SEH	R2, R25
SW	R2, Offset(LATD+0)(GP)
;TestMe.c,115 :: 		}
L_end_setPORTD:
JR	RA
NOP	
; end of _setPORTD
_setLed:
;TestMe.c,116 :: 		void setLed(int state)
ADDIU	SP, SP, -8
SW	RA, 0(SP)
;TestMe.c,118 :: 		LATB = state;
SW	R25, 4(SP)
SEH	R2, R25
SW	R2, Offset(LATB+0)(GP)
;TestMe.c,119 :: 		setPORTD(0);
MOVZ	R25, R0, R0
JAL	_setPORTD+0
NOP	
;TestMe.c,120 :: 		setPORTC(0);
MOVZ	R25, R0, R0
JAL	_setPORTC+0
NOP	
;TestMe.c,121 :: 		}
L_end_setLed:
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 8
JR	RA
NOP	
; end of _setLed
_toggleLED:
;TestMe.c,124 :: 		void toggleLED()
ADDIU	SP, SP, -8
SW	RA, 0(SP)
;TestMe.c,126 :: 		if (currLEDVal == 0)
SW	R25, 4(SP)
LH	R2, Offset(_currLEDVal+0)(GP)
BEQ	R2, R0, L__toggleLED29
NOP	
J	L_toggleLED9
NOP	
L__toggleLED29:
;TestMe.c,128 :: 		setLed(1);
ORI	R25, R0, 1
JAL	_setLed+0
NOP	
;TestMe.c,129 :: 		currLEDVal = 1;
ORI	R2, R0, 1
SH	R2, Offset(_currLEDVal+0)(GP)
;TestMe.c,130 :: 		}
J	L_toggleLED10
NOP	
L_toggleLED9:
;TestMe.c,133 :: 		setLed(0);
MOVZ	R25, R0, R0
JAL	_setLed+0
NOP	
;TestMe.c,134 :: 		currLEDVal = 0;
SH	R0, Offset(_currLEDVal+0)(GP)
;TestMe.c,135 :: 		}
L_toggleLED10:
;TestMe.c,136 :: 		}
L_end_toggleLED:
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 8
JR	RA
NOP	
; end of _toggleLED
_initialize:
;TestMe.c,146 :: 		void initialize()
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;TestMe.c,148 :: 		initializeUART();
JAL	_initializeUART+0
NOP	
;TestMe.c,149 :: 		initializeLEDs();
JAL	_initializeLEDs+0
NOP	
;TestMe.c,150 :: 		initializeCAN();
JAL	_initializeCAN+0
NOP	
;TestMe.c,152 :: 		}
L_end_initialize:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
JR	RA
NOP	
; end of _initialize
_initializeLEDs:
;TestMe.c,154 :: 		void initializeLEDs()  //Used for debugging
;TestMe.c,156 :: 		AD1PCFG = 0xFFFF;      // Configure AN pins as digital I/O
ORI	R2, R0, 65535
SW	R2, Offset(AD1PCFG+0)(GP)
;TestMe.c,157 :: 		TRISB = 0;             // Initialize PORTB as output
SW	R0, Offset(TRISB+0)(GP)
;TestMe.c,158 :: 		LATB = 0;              // Set PORTB to zero
SW	R0, Offset(LATB+0)(GP)
;TestMe.c,159 :: 		TRISC = 0;             // Initialize PORTC as output
SW	R0, Offset(TRISC+0)(GP)
;TestMe.c,160 :: 		LATC = 0;              // Set PORTC to zero
SW	R0, Offset(LATC+0)(GP)
;TestMe.c,161 :: 		TRISD = 0;
SW	R0, Offset(TRISD+0)(GP)
;TestMe.c,162 :: 		LATD = 0;
SW	R0, Offset(LATD+0)(GP)
;TestMe.c,163 :: 		}
L_end_initializeLEDs:
JR	RA
NOP	
; end of _initializeLEDs
_initializeUART:
;TestMe.c,165 :: 		void initializeUART()
ADDIU	SP, SP, -8
SW	RA, 0(SP)
;TestMe.c,167 :: 		UART1_Init(9600);
SW	R25, 4(SP)
ORI	R25, R0, 9600
JAL	_UART1_Init+0
NOP	
;TestMe.c,168 :: 		delay_ms(100);
LUI	R24, 4
ORI	R24, R24, 4522
L_initializeUART11:
ADDIU	R24, R24, -1
BNE	R24, R0, L_initializeUART11
NOP	
;TestMe.c,170 :: 		}
L_end_initializeUART:
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 8
JR	RA
NOP	
; end of _initializeUART
_initializeCAN:
;TestMe.c,172 :: 		void initializeCAN()
ADDIU	SP, SP, -20
SW	RA, 0(SP)
;TestMe.c,174 :: 		Can_Init_Flags = 0;                             //
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
SH	R0, Offset(_Can_Init_Flags+0)(GP)
;TestMe.c,175 :: 		Can_Send_Flags = 0;                             // clear flags
SH	R0, Offset(_Can_Send_Flags+0)(GP)
;TestMe.c,176 :: 		Can_Rcv_Flags  = 0;                             //
SH	R0, Offset(_Can_Rcv_Flags+0)(GP)
;TestMe.c,180 :: 		_CAN_TX_NO_RTR_FRAME;
ORI	R2, R0, 247
SH	R2, Offset(_Can_Send_Flags+0)(GP)
;TestMe.c,184 :: 		CAN1Initialize(SJW, BRP, PHSEG1, PHSEG2, PROPSEG, CAN_CONFIG_FLAGS);
ORI	R28, R0, 2
ORI	R27, R0, 5
ORI	R26, R0, 2
ORI	R25, R0, 1
ORI	R2, R0, 245
ADDIU	SP, SP, -4
SH	R2, 2(SP)
ORI	R2, R0, 8
SH	R2, 0(SP)
JAL	_CAN1Initialize+0
NOP	
ADDIU	SP, SP, 4
;TestMe.c,186 :: 		CAN1SetOperationMode(_CAN_MODE_NORMAL,0xFF);    // set CONFIGURATION mode
ORI	R26, R0, 255
MOVZ	R25, R0, R0
JAL	_CAN1SetOperationMode+0
NOP	
;TestMe.c,188 :: 		CAN1AssignBuffer(FIFObuffers); //assign the buffers
LUI	R25, 40960
ORI	R25, R25, 0
JAL	_CAN1AssignBuffer+0
NOP	
;TestMe.c,190 :: 		CAN1ConfigureFIFO(0, 8,_CAN_FIFO_RX & _CAN_FULL_MESSAGE); //RX buffer 8 messages deep
ORI	R27, R0, 65535
ORI	R26, R0, 8
MOVZ	R25, R0, R0
JAL	_CAN1ConfigureFIFO+0
NOP	
;TestMe.c,192 :: 		CAN1ConfigureFIFO(1, 8,_CAN_FIFO_TX & _CAN_TX_PRIORITY_3 & _CAN_TX_NO_RTR_FRAME);        // TX buffer 8 messages deep
ORI	R27, R0, 65407
ORI	R26, R0, 8
ORI	R25, R0, 1
JAL	_CAN1ConfigureFIFO+0
NOP	
;TestMe.c,195 :: 		CAN1SetMask(_CAN_MASK_0, -1, _CAN_CONFIG_MATCH_MSG_TYPE & _CAN_CONFIG_XTD_MSG);          // set all mask1 bits to ones
ORI	R27, R0, 247
LUI	R26, 65535
ORI	R26, R26, 65535
MOVZ	R25, R0, R0
JAL	_CAN1SetMask+0
NOP	
;TestMe.c,197 :: 		CAN1SetFilter(_CAN_FILTER_31, ID_2nd, _CAN_MASK_0, _CAN_BUFFER_0, _CAN_CONFIG_XTD_MSG);  // set id of filter1 to 2nd node ID
MOVZ	R28, R0, R0
MOVZ	R27, R0, R0
ORI	R26, R0, 1020
ORI	R25, R0, 31
ORI	R2, R0, 247
ADDIU	SP, SP, -4
SH	R2, 0(SP)
JAL	_CAN1SetFilter+0
NOP	
ADDIU	SP, SP, 4
;TestMe.c,199 :: 		CAN1SetOperationMode(_CAN_MODE_NORMAL,0xFF);    // set NORMAL mode
ORI	R26, R0, 255
MOVZ	R25, R0, R0
JAL	_CAN1SetOperationMode+0
NOP	
;TestMe.c,200 :: 		}
L_end_initializeCAN:
LW	R28, 16(SP)
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 20
JR	RA
NOP	
; end of _initializeCAN
