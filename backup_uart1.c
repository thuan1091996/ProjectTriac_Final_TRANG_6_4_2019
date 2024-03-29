/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Project_Triac
Version : 1.0
Date    : 7/19/2018
Author  : Tran Minh Thuan
Company : VM Machine
Comments:
Supported by: Nguyen Van Quyen  
Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256


//Test Section///////////////////////
*******************************************************/

#include <mega8.h>
#include <delay.h>
#include "eeprom.h"

#define SIGNAL      PORTB.1
#define SW_EMER     PINB.3
#define SW_ON       PINB.5
#define SW_GIAM     PINC.1
#define SW_TANG     PINC.0
#define STR         PORTC.2
#define CLK         PORTC.3
#define SDI         PORTC.4
#define LED         PORTC.5

/* ------Cac dinh nghia ve chuong trinh va cac bien--------*/
//-----------------------------------------------------------
//Dinh nghia cac bien toan cuc
char    count=99;                  //Bien dem gia tri delay dau tien 99 -> hien thi 00 
unsigned int    T_delay=0;         //Tang 1 moi khi ngat timer0 (100us)
int             T_Timer1=0;        //Tang 1 moi ngat timer1 de phuc vu kich B1
unsigned int    T_shift_delay=0;   //Dich de ve diem 0
unsigned char   Status=1;          //Vua bat nguon thi he thong se hoat dong
unsigned char   MA_7SEG[10]={0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90};
char    count_pre;
//Dinh nghia cac chuong trinh
void INT0_INIT(void);                   //Khoi tao cho ngat ngoai
void Timer_INIT(void);                  //Khoi tao thong so va ngat cho Timer0
void GPIO_INIT(void);                   //Khoi tao cac input, output
void Delay_100us(unsigned int Time);    //Delay 100us ung voi moi don vi
void Display();                         //Hien thi gia tri ra 7segs                             
void CheckSW(void);                     //Doc gia tri nut nhan
void Power_Check(void);                 //Check nut nhan nguon
int Wait_Shift(void);                   //Doi de shift toi muc 0
void UART_INIT(void);                   //Thiet lap UART, 9600, no parity, 1 stop bit
void TransmitByte(unsigned char data);  //UART transmit 1 byte
/*---------------------Interrupt Service Routine-----------*/
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
    // Reinitialize Timer1 value
    TCNT1H=0xFE20 >> 8;                 //FFB0-80us - (2^16-80)
    TCNT1L=0xFE20 & 0xFF;
    //------------------------------------------------------//
    T_shift_delay++;
    if (Wait_Shift()==1)
    {
        
        if((T_Timer1>=count)&&(T_Timer1<(count+3)))
        {
            SIGNAL=1;
        }
        if(T_Timer1>=(count+3))
        {
            SIGNAL=0;
            TIMSK&=~0x04;
        }
        T_Timer1++; 
    }
}; 
////////////////////////////////////////////////////////////////                                                                                                                /*------------Cac chuong trinh ngat----------------------*/
interrupt [EXT_INT0] void ext_int0_isr(void)
{// External Interrupt 0 service routine
    //Reset count value
    T_shift_delay=0;
    T_Timer1=0;
    TIMSK|=0x04;                        //Enable Timer1 Overflow interrupt
    // Reinitialize Timer1 value
    TCNT1H=0xFE20 >> 8;                 //80us - (2^16-80)
    TCNT1L=0xFE20 & 0xFF;    
};
////////////////////////////////////////////////////////////////
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    /*---------- Timer0 Overflow ISR------------------------------
    // First Reinitialize timer0 value
    // Increase count (T_delay) value
    */   
    TCNT0=0x9D;    //Tinh toan = 0x9D(100), nhung bu sai so nen A0   
    T_delay++;
    //------------------------------------------------------//
          
};
/*----------------------------------------------*/
void main(void)
{
GPIO_INIT();
Timer_INIT();
INT0_INIT();
UART_INIT();
//count=eeprom_read_byte(0);   //Load value from EEPROM
#asm("sei")
while (1)
      {
        Power_Check();
        CheckSW();
        Display();
      }     
};
/*--------------Cac chuong trinh con--------------------*/
void INT0_INIT(void)     //TEST DONE
{
    // External Interrupt(s) initialization
    // INT0: On
    // INT0 Mode: Rising Edge
    // INT1: Off
    GICR|=(0<<INT1) | (1<<INT0);                                //Enable interrupt
    MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (1<<ISC00);    //Rising edge
    GIFR=(0<<INTF1) | (1<<INTF0);                               //Clear the flag  
};   
//////////////////////////////////////////////////////////
void Timer_INIT(void)    //TEST DONE
{
//----------------Timer0--------------------------------//
    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 8000.000 kHz
    // Prescaler: 8 
    TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);  //Prescaler - 8
    TCNT0=0x9D;                               // 100us
//----------------Timer1--------------------------------//
    // Timer/Counter 1 initialization
    // Clock source: System Clock
    // Clock value: 8000.000 kHz
    // Mode: Normal top=0xFFFF
    // OC1A output: Disconnected
    // OC1B output: Disconnected
    // Noise Canceler: Off
    // Input Capture on Falling Edge
    // Timer Period: 0.8 ms
    // Timer1 Overflow Interrupt: On
    // Input Capture Interrupt: Off
    // Compare A Match Interrupt: Off
    // Compare B Match Interrupt: Off
    TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
    TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
    TCNT1H=0xFE20 >> 8;                 //80us - (2^16-80)
    TCNT1L=0xFE20 & 0xff;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=0x00;
    OCR1AL=0x00;
    OCR1BH=0x00;
    OCR1BL=0x00;
};
///////////////////////////////////////////////////////////
void GPIO_INIT(void)     //TEST DONE
{
    // Input/Output Ports initialization
    // Port B initialization
    // Function: Bit7=Out Bit6=Out Bit5=In Bit4=Out Bit3=IN Bit2=Out Bit1=Out Bit0=Out 
    DDRB=(1<<DDB7) | (1<<DDB6) | (0<<DDB5) | (1<<DDB4) | (0<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
    // State: Bit7=0 Bit6=0 Bit5=1 Bit4=0 Bit3=1 Bit2=0 Bit1=0 Bit0=0 
    PORTB=(0<<PORTB7) | (0<<PORTB6) | (1<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

    // Port C initialization
    // Function: Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In 
    DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
    // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=1 Bit0=1 
    PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);

    // Port D initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
};
///////////////////////////////////////////////////////////
int Wait_Shift(void)     //TEST DONE
{
    if(T_shift_delay>=55)            //sau 8*80us ve diem 0
    return 1;                       //Ve diem 0
    else                            //Chua ve diem 0  
    return 0; 
};
///////////////////////////////////////////////////////////
void Delay_100us(unsigned int Time)  //TEST DONE
{
/* Create delay function with 100us corresponding to each value */
    TCNT0=0x9D;         //Tinh toan = 0x9D, nhung bu sai so nen A0
    TIMSK|=0x01;        //Cho phep ngat tran timer0
    T_delay=0;          //Reset gia tri dem
    while(T_delay<Time);//Chua du
    TIMSK&=~0x01;       //Du thoi gian, tat ngat tran timer0
};
///////////////////////////////////////////////////////////
void CheckSW(void)  //TEST DONE
{
    if(!SW_GIAM)
    {
        Delay_100us(2500);
        if(count>0) count--; 
        else        count=0;
    }
    if(!SW_TANG)
    {
        Delay_100us(2500);  
        if(count<99) count++;
        else         count=99;
    }
    if(count!=count_pre)
    {
         
//        DDRB&=~0x02;
//        Delay_100us(500);
//        DDRB|=0x02;
//        Delay_100us(1000);
//        eeprom_write_byte(0,count); //Store count in EEPROM, EEPROM have only 100,000 write
        TransmitByte(99-count);
    }
    count_pre=count;
};                                                      
///////////////////////////////////////////////////////////
void Display()  //TEST DONE
{
    unsigned char i,Q;
    unsigned char Dvi,Chuc;
    Dvi=MA_7SEG[(99-count)%10];
    Chuc=MA_7SEG[(99-count)/10];
    Q=Chuc; for(i=0;i<8;i++){SDI=Q&0x80;CLK=0;CLK=1;Q<<=1;} 
    Q=Dvi; for(i=0;i<8;i++){SDI=Q&0x80;CLK=0;CLK=1;Q<<=1;} 
    STR=0; STR=1; 
};
///////////////////////////////////////////////////////////
void Power_Check(void) //Test done
{
/* Check the power button to allow system operating normally
SW_EMER - Emergency switch if this button was switched on (=0), lock the output signal
SW_ON - On/Off button, if this button was pressed toggle on/off the output signal
Status =0 -> Signal was disable
Status = 1 -> Signal was enable
*/
    if(SW_EMER==0)                          //LOCK
        {   
            Status=0;                       //Signal disable
            Delay_100us(5000);              //Wait for bound
            if(SW_EMER==1)                  //UNLOCK
            Status=1;                       //Signal enable
        }
    else
        {
            if(SW_ON==0)                    //Switch press toggle the power
                {
                    Delay_100us(5000);      //Wait for bound
                    Status=(Status+1)%2;    //Toggle     
                }
        }
    if(Status==1)  //System ON, on LED and enable SIGNAL
    {
        LED=0; 
        DDRB|=0x02;
        if(count==0)   DDRB&=~0x02; //Voi count =0 chan ngo ra
    }     
    else          {LED=1; DDRB&=~0x02;}     //System OFF, Off LED and disable SIGNAL
};
///////////////////////////////////////////////////////////
void UART_INIT(void)
{
// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Sync. Master UCPOL=0
// USART Baud Rate: 9600
UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
/* UCSRA - UART Control and Status Register A
RXC -  Receive complete flag
       +0 - Receive buffer empty
       +1 - There are unread data in receive buffer
TXC -  Transmit complete flag 
       +0 - Transmit ISR complete or write 1 the its location
       +1 - There are no data in transmit buffer
UDRE-  USART data register empty
FE  -  Frame error
DOR -  Data OveRun
PE  -  Parity error
U2X -  Double the USART transmission speed
MPCM-  Multi-processor Communication mod  */
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
/* USART Control and status register B
RXCIE   -   RX Complete Interrupt Enable            - 0 Diasble interrupt       
TXCIE   -   Transmit Complete Interrupt Enable      - 0 Disable interrupt
UDRIE   -   Data Register Empty Interrupt Enable    - 0 Disable interrupt
RXEN    -   Receiver Enable                         - 1 Enable USART receiver
TXEN    -   Transmitter Enable                      - 1 Enable USART transmitter
USCZ    -   Character size                          - 011 8 bits data
RXB8    -   Receive Data Bit 8                      
TXB8    -   Transmit Data Bit 8
*/
UCSRC=(1<<URSEL)|(1<<UMSEL)|(0<<UPM1)|(0<<UPM0)|(0<<USBS)|(1<<UCSZ1)|(1<<UCSZ0)|(0<<UCPOL);
/*
URSEL   -   Register Select         - Must be 1 when write to UCSRC
UMSEL   -   Mode Select     - 1     - Asynchronous   
UPM     -   Parity Mode     - 00    - Disable
USBS    -   Stop Bit Select - 0     - 1 bit
UCSZ    -   Character Size  - 110   - 8 bit
UCPOL   -   Clock Polarity  - 0     - Transmit Rising edge- Receive Falling edge  
*/
UBRRH=0x00; //Set baud rate at 9600
UBRRL=0x33; //UBRR_value=(ClockSpeed/16/Baud_rate)-1 max 2^12-1
};
///////////////////////////////////////////////////////////
void TransmitByte(unsigned char data )
{
    while ((UCSRA & (1<<UDRE))==0); /* Wait for empty (UDRE==1) to write to transmit buffer */
    UDR = data;                     /* Start transmittion */
}
/*--------------------------------------------------------*/
