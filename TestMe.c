#include <stdio.h>
#include <string.h>


void setLED(int state);
int readUARTData(char *buffer, int max_size);
void printError(char *buffer);
//void handleLED(char *buffer);
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
//char *dat1;
unsigned int Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;  // can flags
unsigned int Rx_Data_Len;                                    // received data length in bytes
unsigned int Tx_Data_Len;
char RxTx_Data[8];
char TxRx_Data[8];
char Msg_Rcvd;
char Msg_Send;                                           // reception flag
const unsigned long ID_1st = 12111, ID_2nd = 0x3FC;              // node IDs
unsigned long Rx_ID;
unsigned long Tx_ID;


// LCD COG module connections
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
// End LCD COG module connections

char txt1[] = "Hello";
char txt2[] = "World";
char txt3[] = "Lcd4bit";
char txt4[] = "example";

// reserve space for 2 buffers with 8 messages (each message is 16 bytes)
// beggining of the buffer must be 32bit aligned
char FIFObuffers[2*8*16] absolute 0xA0000000;

// CAN Initializations constants
// Baud rate is set according to following formula
// Fbaud = Fosc/(2*N*BRP),  N = SYNC + PHSEG1 + PHSEG2 + PROPSEG = 16
// In this case Fbaud = 125000
/*Place/Copy this part in declaration section*/
const unsigned int SJW = 1;
const unsigned int BRP = 2;
const unsigned int PHSEG1 = 5;
const unsigned int PHSEG2 = 2;
const unsigned int PROPSEG = 8;
const unsigned int CAN_CONFIG_FLAGS =
                                       _CAN_CONFIG_SAMPLE_ONCE &
                                       _CAN_CONFIG_PHSEG2_PRG_ON &
                                       _CAN_CONFIG_XTD_MSG       &
                                       _CAN_CONFIG_MATCH_MSG_TYPE &
                                       _CAN_CONFIG_LINE_FILTER_OFF;


 void sendDataBuffer(char *buffer)
{
    UART1_Write_Text(buffer);
    AD1PCFG = 0;                                    // Configure AN pins as digital I/O
    LATF = 0;
    TRISF = 0;
    CAN1Write(ID_1st, buffer, 8, Can_Send_Flags);
}

void Move_Delay() {                  // Function used for text moving
  Delay_ms(750);                     // You can change the moving speed here
}
char i;
void main() {
     char buffer[100];
     if (!buffer)
     {
       return;
     }

     initialize();
/*     while(1)
     {
             getDataBuffer(buffer, 100);
             sendDataBuffer(buffer);
     }
//      char dat1[5]= {"hello"};
*/     while(1)
     {
          getdataCAN();
//        senddataCAN(buffer, 100);
          //sendDataBuffer(buffer);
//          handleLED(buffer);
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
     LATC = val;       // Invert PORTC value
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
     AD1PCFG = 0xFFFF;      // Configure AN pins as digital I/O
     TRISB = 0;             // Initialize PORTB as output
     LATB = 0;              // Set PORTB to zero
     TRISC = 0;             // Initialize PORTC as output
     LATC = 0;              // Set PORTC to zero
     TRISD = 0;
     LATD = 0;

//     LCD init
     AD1PCFG  = 0xFFFF;                 // Configure AN pins as digital I/O
     Lcd_Init();                        // Initialize LCD
     Lcd_Cmd(_LCD_CLEAR);               // Clear display
     Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off

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
  AD1PCFG = 0;                                    // Configure AN pins as digital I/O
  LATB = 0;
  TRISB = 0;

  RxTx_Data[0] = 0xEF;
 // RxTx_Data[1] = 0xAB;
  CAN1Write(ID_1st, RxTx_Data, 1, Can_Send_Flags);
  while(1)
  {
    Rx_Data_Len = 0;
    delay_ms(500);
    Msg_Rcvd = CAN1Read(&Rx_ID, &RxTx_Data, &Rx_Data_Len, &Can_Rcv_Flags);        // receive message
    latd = Can_Rcv_Flags;
   // sendDataBuffer(RxTx_Data);
    //if (Msg_Rcvd != 0)

    if ( Msg_Rcvd != 0 )
    {
//       delay_ms(10);
//       toggleLED();



       Lcd_Cmd(_LCD_CLEAR);               // Clear display
       writeLCDRow1(RxTx_Data);
       delay_ms(100);
       UART1_Write_Text(RxTx_Data);
    //   RxTx_Data[0] = 0xDD;
       CAN1Write(ID_1st, RxTx_Data, Rx_Data_Len, Can_Send_Flags);
       // send incremented data back
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
  AD1PCFG = 0;                                    // Configure AN pins as digital I/O
  LATF = 0;
  TRISF = 0;


  dummy_buffer[0] = 0;
  TxRx_Data[0] = 0xFE;
  CAN1Write(ID_1st, TxRx_Data, 1, Can_Send_Flags);
  while(1)
  {
//          readUARTData(buffer, 10);
//          UART1_Write_Text(buffer);
//          writeLCDRow1(buffer);
//          break;
            Msg_Rcvd = CAN1Read(&Rx_ID, &TxRx_Data, &Rx_Data_Len, &Can_Rcv_Flags);        // receive message
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
//             toggleLED();
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
     Can_Init_Flags = 0;                             //
     Can_Send_Flags = 0;                             // clear flags
     Can_Rcv_Flags  = 0;                             //

     Can_Send_Flags =            // form value to be used
                   _CAN_TX_XTD_FRAME &            // with CAN2Write
                   _CAN_TX_NO_RTR_FRAME;
                   

  /*Place/Copy this part in init section*/
  CAN1Initialize(SJW, BRP, PHSEG1, PHSEG2, PROPSEG, CAN_CONFIG_FLAGS);

  CAN1SetOperationMode(_CAN_MODE_NORMAL,0xFF);    // set CONFIGURATION mode

  CAN1AssignBuffer(FIFObuffers); //assign the buffers
  //configure rx fifo
  CAN1ConfigureFIFO(0, 8,_CAN_FIFO_RX & _CAN_FULL_MESSAGE); //RX buffer 8 messages deep
  //configure tx fifo
  CAN1ConfigureFIFO(1, 8,_CAN_FIFO_TX & _CAN_TX_PRIORITY_3 & _CAN_TX_NO_RTR_FRAME);        // TX buffer 8 messages deep

  //set mask 0
  CAN1SetMask(_CAN_MASK_0, -1, _CAN_CONFIG_MATCH_MSG_TYPE & _CAN_CONFIG_XTD_MSG);          // set all mask1 bits to ones
  //set filter 1
  CAN1SetFilter(_CAN_FILTER_31, ID_2nd, _CAN_MASK_0, _CAN_BUFFER_0, _CAN_CONFIG_XTD_MSG);  // set id of filter1 to 2nd node ID

  CAN1SetOperationMode(_CAN_MODE_NORMAL,0xFF);    // set NORMAL mode
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