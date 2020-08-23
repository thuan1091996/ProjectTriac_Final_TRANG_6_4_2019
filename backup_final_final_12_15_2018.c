/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
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
Development:
12-12-2018: Final version.     (OK)
                + 2 Modes
15-12-2018: Fix EEPROM Problem (OK)
            -Change store place temp0 (0>2), temp1 (1>5)
            -Change when save value (different -> save > pressed button -> save)
//Test Section///////////////////////
*******************************************************/

#include <mega8.h>
#include <delay.h>
#include "EEPROM.H"

#define SW_EMER     PINB.3
#define SW_ON       PINC.3
#define SW_EMER1    PIND.4   
#define SW_GIAM     PINC.5
#define SW_TANG     PINC.4
#define LED         PORTB.5
#define SIGNAL      PORTB.1
#define CLK         PORTC.2 //Chan 11 clock
#define SDI         PORTC.0 //Chan 14 data
#define STR         PORTC.1 //Chan 12 chot




/* ------Cac dinh nghia ve chuong trinh va cac bien--------*/
//-----------------------------------------------------------
//Dinh nghia cac bien toan cuc
unsigned int    count=99;           //Bien dem gia tri delay dau tien 99 -> hien thi 00
unsigned int    T_delay=0;         //Tang 1 moi khi ngat timer0 (100us)
unsigned int    T_Timer1=0;        //Tang 1 moi ngat timer1 de phuc vu kich B1
unsigned int    T_shift_delay=0;   //Dich de ve diem 0
unsigned char   Status=1;          //Vua bat nguon thi he thong se hoat dong
unsigned char   Mode=0;
unsigned int    count_temp1=99;
unsigned int    count_temp0=99;
unsigned char   MA_7SEG[10]={0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90};
//Dinh nghia cac chuong trinh
void INT0_INIT(void);                   //Khoi tao cho ngat ngoai
void Timer_INIT(void);                  //Khoi tao thong so va ngat cho Timer0
void GPIO_INIT(void);                   //Khoi tao cac input, output
void Delay_100us(unsigned int Time);    //Delay 100us ung voi moi don vi
void Display();                         //Hien thi gia tri ra 7segs
void CheckSW(void);                     //Doc gia tri nut nhan
void Power_Check(void);                 //Check nut nhan nguon
int Wait_Shift(void);                   //Doi de shift toi muc 0
/*---------------------Interrupt Service Routine-----------*/
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
//    60us - 65055,
//    65   - 65015, shift 47 - Lighter   - In use 12/8/2018
//    70us - 64975, shift 36 - Stronger 
//MAX 80us - 64895, shift 20 - Super strong

    // Reinitialize Timer1 value
    TCNT1H=65015 >> 8;                 //FFB0-80us - (2^16-80)
    TCNT1L=65015 & 0xFF;
    //------------------------------------------------------//
    T_shift_delay++;
    if (Wait_Shift()==1)
    {   
        if((99-count)==0) DDRB&=~0x02;
        else            
        {
        if(T_Timer1>=count)
        {
            SIGNAL=1;
        }
        T_Timer1++;
        }
    }
};
////////////////////////////////////////////////////////////////                                                                                                                /*------------Cac chuong trinh ngat----------------------*/
interrupt [EXT_INT0] void ext_int0_isr(void)
{// External Interrupt 0 service routine
    //Reset count value 
    SIGNAL=0;
    T_shift_delay=0;
    T_Timer1=0;
    if(LED==1)
    {
         TIMSK&=(~0x04);
         SIGNAL=0;
    }
    else if (LED==0)
    { 
        TIMSK|=0x04;                        //Enable Timer1 Overflow interrupt
        // Reinitialize Timer1 value
        TCNT1H=65015 >> 8;                 //80us - (2^16-80)
        TCNT1L=65015 & 0xFF;                                
    }
}
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
count_temp0=eepromRead(2);   //Load value from EEPROM
count_temp1=eepromRead(5);
if(count_temp0==0) count_temp0=99; //If read EEPROM=0 -> run at 99 dangerous ->down to 0
if(count_temp1==0) count_temp1=99; //If read EEPROM=0 -> run at 99 dangerous ->down to 0
SIGNAL=0;
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
    // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=In Bit2=In Bit1=In Bit0=Out
    DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (1<<DDB1) | (1<<DDB0);
    // State: Bit7=T Bit6=T Bit5=1 Bit4=T Bit3=T Bit2=T Bit1=T Bit0=0
    PORTB=(0<<PORTB7) | (0<<PORTB6) | (1<<PORTB5) | (0<<PORTB4) | (1<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
    // Port C initialization
    // Function: Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In
    DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
    // State: Bit6=T Bit5=T Bit4=0 Bit3=0 Bit2=0 Bit1=T Bit0=T
    PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
    DDRD=0x00;    // Cac chan cua PORTD la cac chan INPUT
    PORTD=0xFF;    // Co tro noi keo len cho chan 5,6,7
};
///////////////////////////////////////////////////////////
int Wait_Shift(void)     //TEST DONE
{
    if(T_shift_delay>=47)           //sau 8*80us ve diem 0
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
    if(Mode==1)
    {
        if(!SW_GIAM)
        {
            Delay_100us(2000);
            if(count_temp1>0) {count_temp1--;      Delay_100us(5);} //Store count in EEPROM, EEPROM have only 100,000 write
            else        count_temp1=0;
            eepromWrite(5,count_temp1);
        }
        if(!SW_TANG)
        {
            Delay_100us(2000);
            if(count_temp1<99) { count_temp1++;     Delay_100us(5);} //Store count in EEPROM, EEPROM have only 100,000 write
            else        count_temp1=99;
            eepromWrite(5,count_temp1);
        }
    }
    if(Mode==0)
    {
        if(!SW_GIAM)
        {
            Delay_100us(2000);
            if(count_temp0>0) {count_temp0--;      Delay_100us(5);   } //Store count in EEPROM, EEPROM have only 100,000 write
            else        count_temp0=0;
            eepromWrite(2,count_temp0);
        }
        if(!SW_TANG)
        {
            Delay_100us(2000);
            if(count_temp0<99) {count_temp0++;     Delay_100us(5);} //Store count in EEPROM, EEPROM have only 100,000 write
            else        count_temp0=99;
            eepromWrite(2,count_temp0);
        }
    
    }
    if(Mode==0) count=count_temp0;
    if(Mode==1) count=count_temp1;
}
///////////////////////////////////////////////////////////
void Display()  //TEST DONE
{
    unsigned char i,Q;
    unsigned char Dvi,Chuc;
    Dvi=MA_7SEG[(99-count)%10];
    Chuc=MA_7SEG[(99-count)/10];
    Q=Dvi; for(i=0;i<8;i++){SDI=Q&0x80;CLK=0;CLK=1;Q<<=1;}
    Q=Chuc; for(i=0;i<8;i++){SDI=Q&0x80;CLK=0;CLK=1;Q<<=1;}
    STR=0; STR=1;
}
///////////////////////////////////////////////////////////
void Power_Check(void) //Test done
{
/* Check the power button to allow system operating normally
SW_EMER - Emergency switch if this button was switched on (=0), lock the output signal
SW_ON - On/Off button, if this button was pressed toggle on/off the output signal
Status =0 -> Signal was disable
Status = 1 -> Signal was enable
*/
    if((SW_EMER==0)&&(SW_EMER1==1))     
    {
        Mode=0;   //Mode 0
    } 
    if((SW_EMER==0)&&(SW_EMER1==0))     
    {
        Mode=1;   //Mode 1
    } 
    if(SW_EMER==1)                          //LOCK
    {
            Status=0;                       //Signal disable
            Delay_100us(50);                //Wait for bound
            if(SW_EMER==0)                  //UNLOCK
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
    if(Status==1) {LED=0; DDRB|=0x02;}      //System ON, on LED and enable SIGNAL
    else          {LED=1; DDRB&=~0x02;}     //System OFF, Off LED and disable SIGNAL
}
/*--------------------------------------------------------*/
