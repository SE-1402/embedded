#line 1 "C:/Users/Kari/Desktop/TestMe/TestMe.c"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic32/include/stdio.h"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for pic32/include/string.h"





void * memchr(void *p, char n, unsigned int v);
int memcmp(void *s1, void *s2, int n);
void * memcpy(void * d1, void * s1, int n);
void * memmove(void * to, void * from, int n);
void * memset(void * p1, char character, int n);
char * strcat(char * to, char * from);
char * strchr(char * ptr, char chr);
int strcmp(char * s1, char * s2);
char * strcpy(char * to, char * from);
int strlen(char * s);
char * strncat(char * to, char * from, int size);
char * strncpy(char * to, char * from, int size);
int strspn(char * str1, char * str2);
char strcspn(char * s1, char * s2);
int strncmp(char * s1, char * s2, char len);
char * strpbrk(char * s1, char * s2);
char * strrchr(char *ptr, char chr);
char * strstr(char * s1, char * s2);
char * strtok(char * s1, char * s2);
#line 5 "C:/Users/Kari/Desktop/TestMe/TestMe.c"
void setLED(int state);
int readUARTData(char *buffer, int max_size);
void printError(char *buffer);

void setPORTC(int val);
void setPORTD(int val);
void writeLCDRow1(char *text);
void writeLCDRow2(char *text);
void initialize();
void initializeCAN();
void sendDataBuffer(char *buffer);
void toggleLED();
void getdataCAN();
int getDataBuffer(char *buffer, int max_size);
int senddataCAN(char *buffer, int maxLength);
char data;
char recieve;

unsigned int Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;
unsigned int Rx_Data_Len;
unsigned int Tx_Data_Len;
char RxTx_Data[8];
char TxRx_Data[8];
char Msg_Rcvd;
char Msg_Send;
const unsigned long ID_1st = 12111, ID_2nd = 0x3FC;
unsigned long Rx_ID;
unsigned long Tx_ID;



sbit LCD_RS at LATB2_bit;
sbit LCD_EN at LATB3_bit;
sbit LCD_D4 at LATB4_bit;
sbit LCD_D5 at LATB5_bit;
sbit LCD_D6 at LATB6_bit;
sbit LCD_D7 at LATB7_bit;

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;


char txt1[] = "Hello";
char txt2[] = "World";
char txt3[] = "Lcd4bit";
char txt4[] = "example";



char FIFObuffers[2*8*16] absolute 0xA0000000;






const unsigned int SJW = 1;
const unsigned int BRP = 2;
const unsigned int PHSEG1 = 5;
const unsigned int PHSEG2 = 2;
const unsigned int PROPSEG = 8;
const unsigned int CAN_CONFIG_FLAGS =
 _CAN_CONFIG_SAMPLE_ONCE &
 _CAN_CONFIG_PHSEG2_PRG_ON &
 _CAN_CONFIG_XTD_MSG &
 _CAN_CONFIG_MATCH_MSG_TYPE &
 _CAN_CONFIG_LINE_FILTER_OFF;


 void sendDataBuffer(char *buffer)
{
 UART1_Write_Text(buffer);
 AD1PCFG = 0;
 LATF = 0;
 TRISF = 0;
 CAN1Write(ID_1st, buffer, 8, Can_Send_Flags);
}

void Move_Delay() {
 Delay_ms(750);
}
char i;
void main() {
 char buffer[100];
 if (!buffer)
 {
 return;
 }

 initialize();
#line 105 "C:/Users/Kari/Desktop/TestMe/TestMe.c"
 while(1)
 {
 getdataCAN();



 }
}

void writeLCDRow1(char *text)
{
 Lcd_Out(1,1, text);
}

void writeLCDRow2(char *text)
{
 Lcd_Out(2,1, text);
}

void setPORTC(int val)
{
 LATC = val;
}

void setPORTD(int val)
{
 LATD = val;
}
void setLed(int state)
{
 LATB = state;
 setPORTD(0);
 setPORTC(0);
}
void initialize()
{
 UART1_Init(9600);
 delay_ms(100);
 AD1PCFG = 0xFFFF;
 TRISB = 0;
 LATB = 0;
 TRISC = 0;
 LATC = 0;
 TRISD = 0;
 LATD = 0;


 AD1PCFG = 0xFFFF;
 Lcd_Init();
 Lcd_Cmd(_LCD_CLEAR);
 Lcd_Cmd(_LCD_CURSOR_OFF);

 initializeCAN();

}



int currLEDVal = 0;
void toggleLED()
{
 if (currLEDVal == 0)
 {
 setLed(1);
 currLEDVal = 1;
 }
 else
 {
 setLed(0);
 currLEDVal = 0;
 }
}


void getdataCAN(){
 AD1PCFG = 0;
 LATB = 0;
 TRISB = 0;

 RxTx_Data[0] = 0xEF;

 CAN1Write(ID_1st, RxTx_Data, 1, Can_Send_Flags);
 while(1)
 {
 Rx_Data_Len = 0;
 delay_ms(500);
 Msg_Rcvd = CAN1Read(&Rx_ID, &RxTx_Data, &Rx_Data_Len, &Can_Rcv_Flags);
 latd = Can_Rcv_Flags;



 if ( Msg_Rcvd != 0 )
 {





 Lcd_Cmd(_LCD_CLEAR);
 writeLCDRow1(RxTx_Data);
 delay_ms(1000);
 UART1_Write_Text(RxTx_Data);

 CAN1Write(ID_1st, RxTx_Data, Rx_Data_Len, Can_Send_Flags);

 }
 else if ( Rx_Data_Len != 0)
 {
 RxTx_Data[0] = 0xEE;
 CAN1Write(ID_1st, RxTx_Data, 1, Can_Send_Flags);
 }
 else
 {
 RxTx_Data[0] = 0xAA;
 CAN1Write(ID_1st, RxTx_Data, 1, Can_Send_Flags);
 }
 }
}

int senddataCAN(char *buffer, int max_size){
 int num_char;
 int index;
 char dummy_buffer[8];
 AD1PCFG = 0;
 LATF = 0;
 TRISF = 0;


 dummy_buffer[0] = 0;
 TxRx_Data[0] = 0xFE;
 CAN1Write(ID_1st, TxRx_Data, 1, Can_Send_Flags);
 while(1)
 {




 Msg_Rcvd = CAN1Read(&Rx_ID, &TxRx_Data, &Rx_Data_Len, &Can_Rcv_Flags);
 if (Msg_Rcvd)
 {
 CAN1Write(ID_1st, TxRx_Data, Rx_Data_Len, Can_Send_Flags);
 }
 else
 {
 dummy_buffer[0]++;
 CAN1Write(ID_1st, dummy_buffer, 1, Can_Send_Flags);
 }

 Delay_100ms();
 }
}

int readUARTData(char *buffer, int max_size)
{
 int num_char = 0;

 while(num_char < max_size)
 {
 if (UART1_Data_Ready() != 1)
 {
 delay_ms(100);

 continue;
 }

 recieve = UART1_Read();

 if(recieve == '\r')
 break;

 *buffer = recieve;

 buffer++;
 num_char++;
 }

 *buffer = 0;
 return num_char;
}

void initializeCAN()
{
 Can_Init_Flags = 0;
 Can_Send_Flags = 0;
 Can_Rcv_Flags = 0;

 Can_Send_Flags =
 _CAN_TX_XTD_FRAME &
 _CAN_TX_NO_RTR_FRAME;



 CAN1Initialize(SJW, BRP, PHSEG1, PHSEG2, PROPSEG, CAN_CONFIG_FLAGS);

 CAN1SetOperationMode(_CAN_MODE_NORMAL,0xFF);

 CAN1AssignBuffer(FIFObuffers);

 CAN1ConfigureFIFO(0, 8,_CAN_FIFO_RX & _CAN_FULL_MESSAGE);

 CAN1ConfigureFIFO(1, 8,_CAN_FIFO_TX & _CAN_TX_PRIORITY_3 & _CAN_TX_NO_RTR_FRAME);


 CAN1SetMask(_CAN_MASK_0, -1, _CAN_CONFIG_MATCH_MSG_TYPE & _CAN_CONFIG_XTD_MSG);

 CAN1SetFilter(_CAN_FILTER_31, ID_2nd, _CAN_MASK_0, _CAN_BUFFER_0, _CAN_CONFIG_XTD_MSG);

 CAN1SetOperationMode(_CAN_MODE_NORMAL,0xFF);
}


int getDataBuffer(char *buffer, int max_size)
{
 int num_char = 0;

 while(num_char < max_size)
 {
 if (UART1_Data_Ready() != 1)
 {
 delay_ms(100);
 toggleLED();
 continue;
 }

 recieve = UART1_Read();

 if(recieve == '\r')
 break;

 *buffer = recieve;

 buffer++;
 num_char++;
 }
 *buffer = 0;
 return num_char;
}
