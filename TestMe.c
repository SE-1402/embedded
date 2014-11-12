#include <stdio.h>
#include <string.h>
#include "TestMe.h"

unsigned int Can_Init_Flags, Can_Send_Flags, Can_Rcv_Flags;  // can flags
unsigned int Rx_Data_Len;                                    // received data length in bytes
char RxTx_Data[8];
//char Msg_Send;                                          // reception flag
const unsigned long ID_1st = 12111, ID_2nd = 0x3FC;   //TODO: we should get rid of these           // node IDs
unsigned long Rx_ID; //TODO: Do we need this?

// reserve space for 2 buffers with 8 messages (each message is 16 bytes)
// beggining of the buffer must be 32bit aligned
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

   /*
  * -------------------------
  *
  *   CAN
  *
  * -------------------------
  */
  
void senddataCAN(char *buffer, int buffer_len)
{
   AD1PCFG = 0;                                    // Configure AN pins as digital I/O
   LATF = 0;
   TRISF = 0;

   CAN1Write(ID_1st, buffer, buffer_len, Can_Send_Flags);
   Delay_100ms(); //TODO: REMOVE?
}

char getdataCAN()
{
  char Msg_Rcvd;
  AD1PCFG = 0;                                    // Configure AN pins as digital I/O
  LATB = 0;
  TRISB = 0;

   Msg_Rcvd = CAN1Read(&Rx_ID, &RxTx_Data, &Rx_Data_Len, &Can_Rcv_Flags);        // receive message
   return Msg_Rcvd;
}


  /*
  * -------------------------
  *
  *   UART
  *
  * -------------------------
  */
  
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

  /*
  * -------------------------
  *
  *   DEBUG ASSIST FUNCTIONS
  *
  * -------------------------
  */

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

  /*
  *  ------------------------
  *
  *  INITILIZATION FUNCTIONS
  *
  *  ------------------------
  */

void initialize()
{
     initializeUART();
     initializeLEDs();
     initializeCAN();

}

void initializeLEDs()  //Used for debugging
{
     AD1PCFG = 0xFFFF;      // Configure AN pins as digital I/O
     TRISB = 0;             // Initialize PORTB as output
     LATB = 0;              // Set PORTB to zero
     TRISC = 0;             // Initialize PORTC as output
     LATC = 0;              // Set PORTC to zero
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