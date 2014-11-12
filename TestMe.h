//Set LED to ON=1 or OFF=0
//Useful for toggling when receiving data to visually see stream
void setLED(int state);

//Read data from UART and place in given buffer with max_size to read
int readUARTData(char *buffer, int max_size);

//sends the given buffer over UART
void sendDataUART(char *buffer);

//Sets the PORT, similar to setLED
void setPORTC(int val);
void setPORTD(int val);

//Initialize CAN, UART and LEDs
void initialize();

//Initializes the CAN module
void initializeCAN();

//Initializes the UART module
void initializeUART();

//Initializes the LED module
void initializeLEDs();

//Toggles the LED from the last state called form toggleLED
//Will not work with setLED at the same time, use one or the other
void toggleLED();

//Read data from CAN, the data is placed in RxTx_Data
char getdataCAN();

//Sends the given buffer over the CAN bus
void senddataCAN(char *buffer, int maxLength);


/*
* --------------
*   CONSTANTS
* --------------
*/


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