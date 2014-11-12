_sendDataBuffer:
;TestMe.c,78 :: 		void sendDataBuffer(char *buffer)
ADDIU	SP, SP, -20
SW	RA, 0(SP)
;TestMe.c,80 :: 		UART1_Write_Text(buffer);
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
JAL	_UART1_Write_Text+0
NOP	
;TestMe.c,81 :: 		AD1PCFG = 0;                                    // Configure AN pins as digital I/O
SW	R0, Offset(AD1PCFG+0)(GP)
;TestMe.c,82 :: 		LATF = 0;
SW	R0, Offset(LATF+0)(GP)
;TestMe.c,83 :: 		TRISF = 0;
SW	R0, Offset(TRISF+0)(GP)
;TestMe.c,84 :: 		CAN1Write(ID_1st, buffer, 8, Can_Send_Flags);
LHU	R28, Offset(_Can_Send_Flags+0)(GP)
ORI	R27, R0, 8
MOVZ	R26, R25, R0
ORI	R25, R0, 12111
JAL	_CAN1Write+0
NOP	
;TestMe.c,85 :: 		}
L_end_sendDataBuffer:
LW	R28, 16(SP)
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 20
JR	RA
NOP	
; end of _sendDataBuffer
_Move_Delay:
;TestMe.c,87 :: 		void Move_Delay() {                  // Function used for text moving
;TestMe.c,88 :: 		Delay_ms(750);                     // You can change the moving speed here
LUI	R24, 30
ORI	R24, R24, 33919
L_Move_Delay0:
ADDIU	R24, R24, -1
BNE	R24, R0, L_Move_Delay0
NOP	
NOP	
;TestMe.c,89 :: 		}
L_end_Move_Delay:
JR	RA
NOP	
; end of _Move_Delay
_main:
;TestMe.c,91 :: 		void main() {
ADDIU	SP, SP, -100
;TestMe.c,93 :: 		if (!buffer)
ADDIU	R2, SP, 0
BEQ	R2, R0, L__main38
NOP	
J	L_main2
NOP	
L__main38:
;TestMe.c,95 :: 		return;
J	L_end_main
NOP	
;TestMe.c,96 :: 		}
L_main2:
;TestMe.c,98 :: 		initialize();
JAL	_initialize+0
NOP	
;TestMe.c,105 :: 		*/     while(1)
L_main3:
;TestMe.c,107 :: 		getdataCAN();
JAL	_getdataCAN+0
NOP	
;TestMe.c,111 :: 		}
J	L_main3
NOP	
;TestMe.c,112 :: 		}
L_end_main:
L__main_end_loop:
J	L__main_end_loop
NOP	
; end of _main
_writeLCDRow1:
;TestMe.c,114 :: 		void writeLCDRow1(char *text)
ADDIU	SP, SP, -16
SW	RA, 0(SP)
;TestMe.c,116 :: 		Lcd_Out(1,1, text);
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
MOVZ	R27, R25, R0
ORI	R26, R0, 1
ORI	R25, R0, 1
JAL	_Lcd_Out+0
NOP	
;TestMe.c,117 :: 		}
L_end_writeLCDRow1:
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 16
JR	RA
NOP	
; end of _writeLCDRow1
_writeLCDRow2:
;TestMe.c,119 :: 		void writeLCDRow2(char *text)
ADDIU	SP, SP, -16
SW	RA, 0(SP)
;TestMe.c,121 :: 		Lcd_Out(2,1, text);
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
MOVZ	R27, R25, R0
ORI	R26, R0, 1
ORI	R25, R0, 2
JAL	_Lcd_Out+0
NOP	
;TestMe.c,122 :: 		}
L_end_writeLCDRow2:
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 16
JR	RA
NOP	
; end of _writeLCDRow2
_setPORTC:
;TestMe.c,124 :: 		void setPORTC(int val)
;TestMe.c,126 :: 		LATC = val;       // Invert PORTC value
SEH	R2, R25
SW	R2, Offset(LATC+0)(GP)
;TestMe.c,127 :: 		}
L_end_setPORTC:
JR	RA
NOP	
; end of _setPORTC
_setPORTD:
;TestMe.c,129 :: 		void setPORTD(int val)
;TestMe.c,131 :: 		LATD = val;
SEH	R2, R25
SW	R2, Offset(LATD+0)(GP)
;TestMe.c,132 :: 		}
L_end_setPORTD:
JR	RA
NOP	
; end of _setPORTD
_setLed:
;TestMe.c,133 :: 		void setLed(int state)
ADDIU	SP, SP, -8
SW	RA, 0(SP)
;TestMe.c,135 :: 		LATB = state;
SW	R25, 4(SP)
SEH	R2, R25
SW	R2, Offset(LATB+0)(GP)
;TestMe.c,136 :: 		setPORTD(0);
MOVZ	R25, R0, R0
JAL	_setPORTD+0
NOP	
;TestMe.c,137 :: 		setPORTC(0);
MOVZ	R25, R0, R0
JAL	_setPORTC+0
NOP	
;TestMe.c,138 :: 		}
L_end_setLed:
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 8
JR	RA
NOP	
; end of _setLed
_initialize:
;TestMe.c,139 :: 		void initialize()
ADDIU	SP, SP, -8
SW	RA, 0(SP)
;TestMe.c,141 :: 		UART1_Init(9600);
SW	R25, 4(SP)
ORI	R25, R0, 9600
JAL	_UART1_Init+0
NOP	
;TestMe.c,142 :: 		delay_ms(100);
LUI	R24, 4
ORI	R24, R24, 4522
L_initialize5:
ADDIU	R24, R24, -1
BNE	R24, R0, L_initialize5
NOP	
;TestMe.c,143 :: 		AD1PCFG = 0xFFFF;      // Configure AN pins as digital I/O
ORI	R2, R0, 65535
SW	R2, Offset(AD1PCFG+0)(GP)
;TestMe.c,144 :: 		TRISB = 0;             // Initialize PORTB as output
SW	R0, Offset(TRISB+0)(GP)
;TestMe.c,145 :: 		LATB = 0;              // Set PORTB to zero
SW	R0, Offset(LATB+0)(GP)
;TestMe.c,146 :: 		TRISC = 0;             // Initialize PORTC as output
SW	R0, Offset(TRISC+0)(GP)
;TestMe.c,147 :: 		LATC = 0;              // Set PORTC to zero
SW	R0, Offset(LATC+0)(GP)
;TestMe.c,148 :: 		TRISD = 0;
SW	R0, Offset(TRISD+0)(GP)
;TestMe.c,149 :: 		LATD = 0;
SW	R0, Offset(LATD+0)(GP)
;TestMe.c,152 :: 		AD1PCFG  = 0xFFFF;                 // Configure AN pins as digital I/O
ORI	R2, R0, 65535
SW	R2, Offset(AD1PCFG+0)(GP)
;TestMe.c,153 :: 		Lcd_Init();                        // Initialize LCD
JAL	_Lcd_Init+0
NOP	
;TestMe.c,154 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
ORI	R25, R0, 1
JAL	_Lcd_Cmd+0
NOP	
;TestMe.c,155 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
ORI	R25, R0, 12
JAL	_Lcd_Cmd+0
NOP	
;TestMe.c,157 :: 		initializeCAN();
JAL	_initializeCAN+0
NOP	
;TestMe.c,159 :: 		}
L_end_initialize:
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 8
JR	RA
NOP	
; end of _initialize
_toggleLED:
;TestMe.c,164 :: 		void toggleLED()
ADDIU	SP, SP, -8
SW	RA, 0(SP)
;TestMe.c,166 :: 		if (currLEDVal == 0)
SW	R25, 4(SP)
LH	R2, Offset(_currLEDVal+0)(GP)
BEQ	R2, R0, L__toggleLED47
NOP	
J	L_toggleLED7
NOP	
L__toggleLED47:
;TestMe.c,168 :: 		setLed(1);
ORI	R25, R0, 1
JAL	_setLed+0
NOP	
;TestMe.c,169 :: 		currLEDVal = 1;
ORI	R2, R0, 1
SH	R2, Offset(_currLEDVal+0)(GP)
;TestMe.c,170 :: 		}
J	L_toggleLED8
NOP	
L_toggleLED7:
;TestMe.c,173 :: 		setLed(0);
MOVZ	R25, R0, R0
JAL	_setLed+0
NOP	
;TestMe.c,174 :: 		currLEDVal = 0;
SH	R0, Offset(_currLEDVal+0)(GP)
;TestMe.c,175 :: 		}
L_toggleLED8:
;TestMe.c,176 :: 		}
L_end_toggleLED:
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 8
JR	RA
NOP	
; end of _toggleLED
_getdataCAN:
;TestMe.c,179 :: 		void getdataCAN(){
ADDIU	SP, SP, -20
SW	RA, 0(SP)
;TestMe.c,180 :: 		AD1PCFG = 0;                                    // Configure AN pins as digital I/O
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
SW	R0, Offset(AD1PCFG+0)(GP)
;TestMe.c,181 :: 		LATB = 0;
SW	R0, Offset(LATB+0)(GP)
;TestMe.c,182 :: 		TRISB = 0;
SW	R0, Offset(TRISB+0)(GP)
;TestMe.c,184 :: 		RxTx_Data[0] = 0xEF;
ORI	R2, R0, 239
SB	R2, Offset(_RxTx_Data+0)(GP)
;TestMe.c,186 :: 		CAN1Write(ID_1st, RxTx_Data, 1, Can_Send_Flags);
LHU	R28, Offset(_Can_Send_Flags+0)(GP)
ORI	R27, R0, 1
LUI	R26, #hi_addr(_RxTx_Data+0)
ORI	R26, R26, #lo_addr(_RxTx_Data+0)
ORI	R25, R0, 12111
JAL	_CAN1Write+0
NOP	
;TestMe.c,187 :: 		while(1)
L_getdataCAN9:
;TestMe.c,189 :: 		Rx_Data_Len = 0;
SH	R0, Offset(_Rx_Data_Len+0)(GP)
;TestMe.c,190 :: 		delay_ms(500);
LUI	R24, 20
ORI	R24, R24, 22612
L_getdataCAN11:
ADDIU	R24, R24, -1
BNE	R24, R0, L_getdataCAN11
NOP	
NOP	
NOP	
;TestMe.c,191 :: 		Msg_Rcvd = CAN1Read(&Rx_ID, &RxTx_Data, &Rx_Data_Len, &Can_Rcv_Flags);        // receive message
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
SB	R2, Offset(_Msg_Rcvd+0)(GP)
;TestMe.c,192 :: 		latd = Can_Rcv_Flags;
LHU	R3, Offset(_Can_Rcv_Flags+0)(GP)
SW	R3, Offset(LATD+0)(GP)
;TestMe.c,196 :: 		if ( Msg_Rcvd != 0 )
ANDI	R2, R2, 255
BNE	R2, R0, L__getdataCAN50
NOP	
J	L_getdataCAN13
NOP	
L__getdataCAN50:
;TestMe.c,203 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
ORI	R25, R0, 1
JAL	_Lcd_Cmd+0
NOP	
;TestMe.c,204 :: 		writeLCDRow1(RxTx_Data);
LUI	R25, #hi_addr(_RxTx_Data+0)
ORI	R25, R25, #lo_addr(_RxTx_Data+0)
JAL	_writeLCDRow1+0
NOP	
;TestMe.c,205 :: 		delay_ms(1000);
LUI	R24, 40
ORI	R24, R24, 45226
L_getdataCAN14:
ADDIU	R24, R24, -1
BNE	R24, R0, L_getdataCAN14
NOP	
;TestMe.c,206 :: 		UART1_Write_Text(RxTx_Data);
LUI	R25, #hi_addr(_RxTx_Data+0)
ORI	R25, R25, #lo_addr(_RxTx_Data+0)
JAL	_UART1_Write_Text+0
NOP	
;TestMe.c,208 :: 		CAN1Write(ID_1st, RxTx_Data, Rx_Data_Len, Can_Send_Flags);
LHU	R28, Offset(_Can_Send_Flags+0)(GP)
LHU	R27, Offset(_Rx_Data_Len+0)(GP)
LUI	R26, #hi_addr(_RxTx_Data+0)
ORI	R26, R26, #lo_addr(_RxTx_Data+0)
ORI	R25, R0, 12111
JAL	_CAN1Write+0
NOP	
;TestMe.c,210 :: 		}
J	L_getdataCAN16
NOP	
L_getdataCAN13:
;TestMe.c,211 :: 		else if ( Rx_Data_Len != 0)
LHU	R2, Offset(_Rx_Data_Len+0)(GP)
BNE	R2, R0, L__getdataCAN52
NOP	
J	L_getdataCAN17
NOP	
L__getdataCAN52:
;TestMe.c,213 :: 		RxTx_Data[0] = 0xEE;
ORI	R2, R0, 238
SB	R2, Offset(_RxTx_Data+0)(GP)
;TestMe.c,214 :: 		CAN1Write(ID_1st, RxTx_Data, 1, Can_Send_Flags);
LHU	R28, Offset(_Can_Send_Flags+0)(GP)
ORI	R27, R0, 1
LUI	R26, #hi_addr(_RxTx_Data+0)
ORI	R26, R26, #lo_addr(_RxTx_Data+0)
ORI	R25, R0, 12111
JAL	_CAN1Write+0
NOP	
;TestMe.c,215 :: 		}
J	L_getdataCAN18
NOP	
L_getdataCAN17:
;TestMe.c,218 :: 		RxTx_Data[0] = 0xAA;
ORI	R2, R0, 170
SB	R2, Offset(_RxTx_Data+0)(GP)
;TestMe.c,219 :: 		CAN1Write(ID_1st, RxTx_Data, 1, Can_Send_Flags);
LHU	R28, Offset(_Can_Send_Flags+0)(GP)
ORI	R27, R0, 1
LUI	R26, #hi_addr(_RxTx_Data+0)
ORI	R26, R26, #lo_addr(_RxTx_Data+0)
ORI	R25, R0, 12111
JAL	_CAN1Write+0
NOP	
;TestMe.c,220 :: 		}
L_getdataCAN18:
L_getdataCAN16:
;TestMe.c,221 :: 		}
J	L_getdataCAN9
NOP	
;TestMe.c,222 :: 		}
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
_senddataCAN:
;TestMe.c,224 :: 		int senddataCAN(char *buffer, int max_size){
ADDIU	SP, SP, -36
SW	RA, 0(SP)
;TestMe.c,228 :: 		AD1PCFG = 0;                                    // Configure AN pins as digital I/O
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
SW	R0, Offset(AD1PCFG+0)(GP)
;TestMe.c,229 :: 		LATF = 0;
SW	R0, Offset(LATF+0)(GP)
;TestMe.c,230 :: 		TRISF = 0;
SW	R0, Offset(TRISF+0)(GP)
;TestMe.c,233 :: 		dummy_buffer[0] = 0;
ADDIU	R2, SP, 28
SB	R0, 0(R2)
;TestMe.c,234 :: 		TxRx_Data[0] = 0xFE;
ORI	R2, R0, 254
SB	R2, Offset(_TxRx_Data+0)(GP)
;TestMe.c,235 :: 		CAN1Write(ID_1st, TxRx_Data, 1, Can_Send_Flags);
LHU	R28, Offset(_Can_Send_Flags+0)(GP)
ORI	R27, R0, 1
LUI	R26, #hi_addr(_TxRx_Data+0)
ORI	R26, R26, #lo_addr(_TxRx_Data+0)
ORI	R25, R0, 12111
JAL	_CAN1Write+0
NOP	
;TestMe.c,236 :: 		while(1)
L_senddataCAN19:
;TestMe.c,242 :: 		Msg_Rcvd = CAN1Read(&Rx_ID, &TxRx_Data, &Rx_Data_Len, &Can_Rcv_Flags);        // receive message
SH	R26, 20(SP)
SW	R25, 24(SP)
LUI	R28, #hi_addr(_Can_Rcv_Flags+0)
ORI	R28, R28, #lo_addr(_Can_Rcv_Flags+0)
LUI	R27, #hi_addr(_Rx_Data_Len+0)
ORI	R27, R27, #lo_addr(_Rx_Data_Len+0)
LUI	R26, #hi_addr(_TxRx_Data+0)
ORI	R26, R26, #lo_addr(_TxRx_Data+0)
LUI	R25, #hi_addr(_Rx_ID+0)
ORI	R25, R25, #lo_addr(_Rx_ID+0)
JAL	_CAN1Read+0
NOP	
LW	R25, 24(SP)
LH	R26, 20(SP)
SB	R2, Offset(_Msg_Rcvd+0)(GP)
;TestMe.c,243 :: 		if (Msg_Rcvd)
BNE	R2, R0, L__senddataCAN55
NOP	
J	L_senddataCAN21
NOP	
L__senddataCAN55:
;TestMe.c,245 :: 		CAN1Write(ID_1st, TxRx_Data, Rx_Data_Len, Can_Send_Flags);
SH	R26, 20(SP)
SW	R25, 24(SP)
LHU	R28, Offset(_Can_Send_Flags+0)(GP)
LHU	R27, Offset(_Rx_Data_Len+0)(GP)
LUI	R26, #hi_addr(_TxRx_Data+0)
ORI	R26, R26, #lo_addr(_TxRx_Data+0)
ORI	R25, R0, 12111
JAL	_CAN1Write+0
NOP	
LW	R25, 24(SP)
LH	R26, 20(SP)
;TestMe.c,246 :: 		}
J	L_senddataCAN22
NOP	
L_senddataCAN21:
;TestMe.c,249 :: 		dummy_buffer[0]++;
ADDIU	R3, SP, 28
LBU	R2, 0(R3)
ADDIU	R2, R2, 1
SB	R2, 0(R3)
;TestMe.c,250 :: 		CAN1Write(ID_1st, dummy_buffer, 1, Can_Send_Flags);
SH	R26, 20(SP)
SW	R25, 24(SP)
LHU	R28, Offset(_Can_Send_Flags+0)(GP)
ORI	R27, R0, 1
MOVZ	R26, R3, R0
ORI	R25, R0, 12111
JAL	_CAN1Write+0
NOP	
LW	R25, 24(SP)
LH	R26, 20(SP)
;TestMe.c,251 :: 		}
L_senddataCAN22:
;TestMe.c,253 :: 		Delay_100ms();
JAL	_Delay_100ms+0
NOP	
;TestMe.c,254 :: 		}
J	L_senddataCAN19
NOP	
;TestMe.c,255 :: 		}
L_end_senddataCAN:
LW	R28, 16(SP)
LW	R27, 12(SP)
LW	R26, 8(SP)
LW	R25, 4(SP)
LW	RA, 0(SP)
ADDIU	SP, SP, 36
JR	RA
NOP	
; end of _senddataCAN
_readUARTData:
;TestMe.c,257 :: 		int readUARTData(char *buffer, int max_size)
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;TestMe.c,259 :: 		int num_char = 0;
; num_char start address is: 16 (R4)
MOVZ	R4, R0, R0
; num_char end address is: 16 (R4)
;TestMe.c,261 :: 		while(num_char < max_size)
L_readUARTData23:
; num_char start address is: 16 (R4)
SEH	R3, R4
SEH	R2, R26
SLT	R2, R3, R2
BNE	R2, R0, L__readUARTData57
NOP	
J	L_readUARTData24
NOP	
L__readUARTData57:
;TestMe.c,263 :: 		if (UART1_Data_Ready() != 1)
JAL	_UART1_Data_Ready+0
NOP	
ANDI	R3, R2, 65535
ORI	R2, R0, 1
BNE	R3, R2, L__readUARTData59
NOP	
J	L_readUARTData25
NOP	
L__readUARTData59:
;TestMe.c,265 :: 		delay_ms(100);
LUI	R24, 4
ORI	R24, R24, 4522
L_readUARTData26:
ADDIU	R24, R24, -1
BNE	R24, R0, L_readUARTData26
NOP	
;TestMe.c,267 :: 		continue;
J	L_readUARTData23
NOP	
;TestMe.c,268 :: 		}
L_readUARTData25:
;TestMe.c,270 :: 		recieve = UART1_Read();
JAL	_UART1_Read+0
NOP	
SB	R2, Offset(_recieve+0)(GP)
;TestMe.c,272 :: 		if(recieve == '\r')
ANDI	R3, R2, 255
ORI	R2, R0, 13
BEQ	R3, R2, L__readUARTData60
NOP	
J	L_readUARTData28
NOP	
L__readUARTData60:
;TestMe.c,273 :: 		break;
J	L_readUARTData24
NOP	
L_readUARTData28:
;TestMe.c,275 :: 		*buffer = recieve;
LBU	R2, Offset(_recieve+0)(GP)
SB	R2, 0(R25)
;TestMe.c,277 :: 		buffer++;
ADDIU	R2, R25, 1
MOVZ	R25, R2, R0
;TestMe.c,278 :: 		num_char++;
ADDIU	R2, R4, 1
SEH	R4, R2
;TestMe.c,279 :: 		}
J	L_readUARTData23
NOP	
L_readUARTData24:
;TestMe.c,281 :: 		*buffer = 0;
SB	R0, 0(R25)
;TestMe.c,282 :: 		return num_char;
SEH	R2, R4
; num_char end address is: 16 (R4)
;TestMe.c,283 :: 		}
L_end_readUARTData:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
JR	RA
NOP	
; end of _readUARTData
_initializeCAN:
;TestMe.c,285 :: 		void initializeCAN()
ADDIU	SP, SP, -20
SW	RA, 0(SP)
;TestMe.c,287 :: 		Can_Init_Flags = 0;                             //
SW	R25, 4(SP)
SW	R26, 8(SP)
SW	R27, 12(SP)
SW	R28, 16(SP)
SH	R0, Offset(_Can_Init_Flags+0)(GP)
;TestMe.c,288 :: 		Can_Send_Flags = 0;                             // clear flags
SH	R0, Offset(_Can_Send_Flags+0)(GP)
;TestMe.c,289 :: 		Can_Rcv_Flags  = 0;                             //
SH	R0, Offset(_Can_Rcv_Flags+0)(GP)
;TestMe.c,293 :: 		_CAN_TX_NO_RTR_FRAME;
ORI	R2, R0, 247
SH	R2, Offset(_Can_Send_Flags+0)(GP)
;TestMe.c,297 :: 		CAN1Initialize(SJW, BRP, PHSEG1, PHSEG2, PROPSEG, CAN_CONFIG_FLAGS);
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
;TestMe.c,299 :: 		CAN1SetOperationMode(_CAN_MODE_NORMAL,0xFF);    // set CONFIGURATION mode
ORI	R26, R0, 255
MOVZ	R25, R0, R0
JAL	_CAN1SetOperationMode+0
NOP	
;TestMe.c,301 :: 		CAN1AssignBuffer(FIFObuffers); //assign the buffers
LUI	R25, 40960
ORI	R25, R25, 0
JAL	_CAN1AssignBuffer+0
NOP	
;TestMe.c,303 :: 		CAN1ConfigureFIFO(0, 8,_CAN_FIFO_RX & _CAN_FULL_MESSAGE); //RX buffer 8 messages deep
ORI	R27, R0, 65535
ORI	R26, R0, 8
MOVZ	R25, R0, R0
JAL	_CAN1ConfigureFIFO+0
NOP	
;TestMe.c,305 :: 		CAN1ConfigureFIFO(1, 8,_CAN_FIFO_TX & _CAN_TX_PRIORITY_3 & _CAN_TX_NO_RTR_FRAME);        // TX buffer 8 messages deep
ORI	R27, R0, 65407
ORI	R26, R0, 8
ORI	R25, R0, 1
JAL	_CAN1ConfigureFIFO+0
NOP	
;TestMe.c,308 :: 		CAN1SetMask(_CAN_MASK_0, -1, _CAN_CONFIG_MATCH_MSG_TYPE & _CAN_CONFIG_XTD_MSG);          // set all mask1 bits to ones
ORI	R27, R0, 247
LUI	R26, 65535
ORI	R26, R26, 65535
MOVZ	R25, R0, R0
JAL	_CAN1SetMask+0
NOP	
;TestMe.c,310 :: 		CAN1SetFilter(_CAN_FILTER_31, ID_2nd, _CAN_MASK_0, _CAN_BUFFER_0, _CAN_CONFIG_XTD_MSG);  // set id of filter1 to 2nd node ID
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
;TestMe.c,312 :: 		CAN1SetOperationMode(_CAN_MODE_NORMAL,0xFF);    // set NORMAL mode
ORI	R26, R0, 255
MOVZ	R25, R0, R0
JAL	_CAN1SetOperationMode+0
NOP	
;TestMe.c,313 :: 		}
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
_getDataBuffer:
;TestMe.c,316 :: 		int getDataBuffer(char *buffer, int max_size)
ADDIU	SP, SP, -4
SW	RA, 0(SP)
;TestMe.c,318 :: 		int num_char = 0;
; num_char start address is: 16 (R4)
MOVZ	R4, R0, R0
; num_char end address is: 16 (R4)
;TestMe.c,320 :: 		while(num_char < max_size)
L_getDataBuffer29:
; num_char start address is: 16 (R4)
SEH	R3, R4
SEH	R2, R26
SLT	R2, R3, R2
BNE	R2, R0, L__getDataBuffer63
NOP	
J	L_getDataBuffer30
NOP	
L__getDataBuffer63:
;TestMe.c,322 :: 		if (UART1_Data_Ready() != 1)
JAL	_UART1_Data_Ready+0
NOP	
ANDI	R3, R2, 65535
ORI	R2, R0, 1
BNE	R3, R2, L__getDataBuffer65
NOP	
J	L_getDataBuffer31
NOP	
L__getDataBuffer65:
;TestMe.c,324 :: 		delay_ms(100);
LUI	R24, 4
ORI	R24, R24, 4522
L_getDataBuffer32:
ADDIU	R24, R24, -1
BNE	R24, R0, L_getDataBuffer32
NOP	
;TestMe.c,325 :: 		toggleLED();
JAL	_toggleLED+0
NOP	
;TestMe.c,326 :: 		continue;
J	L_getDataBuffer29
NOP	
;TestMe.c,327 :: 		}
L_getDataBuffer31:
;TestMe.c,329 :: 		recieve = UART1_Read();
JAL	_UART1_Read+0
NOP	
SB	R2, Offset(_recieve+0)(GP)
;TestMe.c,331 :: 		if(recieve == '\r')
ANDI	R3, R2, 255
ORI	R2, R0, 13
BEQ	R3, R2, L__getDataBuffer66
NOP	
J	L_getDataBuffer34
NOP	
L__getDataBuffer66:
;TestMe.c,332 :: 		break;
J	L_getDataBuffer30
NOP	
L_getDataBuffer34:
;TestMe.c,334 :: 		*buffer = recieve;
LBU	R2, Offset(_recieve+0)(GP)
SB	R2, 0(R25)
;TestMe.c,336 :: 		buffer++;
ADDIU	R2, R25, 1
MOVZ	R25, R2, R0
;TestMe.c,337 :: 		num_char++;
ADDIU	R2, R4, 1
SEH	R4, R2
;TestMe.c,338 :: 		}
J	L_getDataBuffer29
NOP	
L_getDataBuffer30:
;TestMe.c,339 :: 		*buffer = 0;
SB	R0, 0(R25)
;TestMe.c,340 :: 		return num_char;
SEH	R2, R4
; num_char end address is: 16 (R4)
;TestMe.c,341 :: 		}
L_end_getDataBuffer:
LW	RA, 0(SP)
ADDIU	SP, SP, 4
JR	RA
NOP	
; end of _getDataBuffer
