#line 1 "C:/Users/Kari/Desktop/embedded/TestMe.c"
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
#line 1 "c:/users/kari/desktop/embedded/testme.h"


void setLED(int state);


int readUARTData(char *buffer, int max_size);


void sendDataUART(char *buffer);


void setPORTC(int val);
void setPORTD(int val);


void initialize();


void initializeCAN();


void initializeUART();


void initializeLEDs();



void toggleLED();


char getdataCAN();


void senddataCAN(char *buffer, int maxLength);
#line 50 "c:/users/kari/desktop/embedded/testme.h"
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
#line 5 "C:/Users/Kari/Desktop/embedded/TestMe.c"
unsigned int Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;
unsigned int Rx_Data_Len;
char RxTx_Data[8];

const unsigned long ID_1st = 12111, ID_2nd = 0x3FC;
unsigned long Rx_ID;



char FIFObuffers[2*8*16] absolute 0xA0000000;

void main() {
 char msg_recieved;
 initialize();
 while(1)
 {
 msg_recieved = getdataCAN();
 if (msg_recieved)
 sendDataUART(RxTx_Data);
 }
}
#line 35 "C:/Users/Kari/Desktop/embedded/TestMe.c"
void senddataCAN(char *buffer, int buffer_len)
{
 AD1PCFG = 0;
 LATF = 0;
 TRISF = 0;

 CAN1Write(ID_1st, buffer, buffer_len, Can_Send_Flags);
 Delay_100ms();
}

char getdataCAN()
{
 char Msg_Rcvd;
 AD1PCFG = 0;
 LATB = 0;
 TRISB = 0;

 Msg_Rcvd = CAN1Read(&Rx_ID, &RxTx_Data, &Rx_Data_Len, &Can_Rcv_Flags);
 return Msg_Rcvd;
}
#line 65 "C:/Users/Kari/Desktop/embedded/TestMe.c"
void sendDataUART(char *buffer)
{
 UART1_Write_Text(buffer);
}

int readUARTData(char *buffer, int max_size)
{

 char recieve;
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
#line 107 "C:/Users/Kari/Desktop/embedded/TestMe.c"
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
#line 146 "C:/Users/Kari/Desktop/embedded/TestMe.c"
void initialize()
{
 initializeUART();
 initializeLEDs();
 initializeCAN();

}

void initializeLEDs()
{
 AD1PCFG = 0xFFFF;
 TRISB = 0;
 LATB = 0;
 TRISC = 0;
 LATC = 0;
 TRISD = 0;
 LATD = 0;
}

void initializeUART()
{
 UART1_Init(9600);
 delay_ms(100);

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
