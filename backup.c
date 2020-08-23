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
#define LED         PORTB.1
#define SW_TANG     PINC.1
#define SW_GIAM     PINC.0
#define CLK         PORTC.3
#define SDI         PORTC.4
#define STR         PORTC.2

/* ------Cac dinh nghia ve chuong trinh va cac bien--------*/
//-----------------------------------------------------------
//Dinh nghia cac bien toan cuc
unsigned int count=0;                   //Count for the system value
unsigned char Maled[10]={0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90};
//Dinh nghia cac chuong trinh
void INT0_INIT(void);                   //Khoi tao cho ngat ngoai
void Timer0_INIT(void);                 //Khoi tao thong so va ngat cho Timer0
void GPIO_INIT(void);                   //Khoi tao cac input, output
void Delay_100us(unsigned int Time);    //Delay 100us ung voi moi don vi
void Display();
void CheckSW(void);
/*---------------------Interrupt Service Routine-----------*/                                                                                                                 /*------------Cac chuong trinh ngat----------------------*/
interrupt [EXT_INT0] void ext_int0_isr(void)
{// External Interrupt 0 service routine
//----------------Cach0--------------------  
//    Execute++;
//----------------Cach1---------------------
    Delay_100us(count);   
    LED=1;
    Delay_100us(2);
    LED=0; 
};
////////////////////////////////////////////////////////////////
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{

}
/*----------------------------------------------*/
void main(void)
{
GPIO_INIT();
Timer0_INIT();
INT0_INIT();
#asm("sei")
while (1)
      {
      CheckSW();
      Display();
      }     
};
/*--------------Cac chuong trinh con--------------------*/
void INT0_INIT(void)
{
    // External Interrupt(s) initialization
    // INT0: On
    // INT0 Mode: Rising Edge
    // INT1: Off
    GICR|=(0<<INT1) | (1<<INT0);
    MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (1<<ISC00);
    GIFR=(0<<INTF1) | (1<<INTF0);
    
};   
//////////////////////////////////////////////////////////
void Timer0_INIT(void)
{
    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 8000.000 kHz
    // Prescaler: 8
    TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);  //Prescaler - 8
};
///////////////////////////////////////////////////////////
void GPIO_INIT(void)
{
    // Input/Output Ports initialization
    // Port B initialization
    // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
    DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
    // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
    PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

    // Port C initialization
    // Function: Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In 
    DDRC=(0<<DDC6) | (0<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
    // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);

    // Port D initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
};
///////////////////////////////////////////////////////////
void Delay_100us(unsigned int Time) 
{   
    unsigned long T_delay=0;
    while(T_delay<Time)
    {
        TCNT0=0;         
        while(TCNT0<100); 
        T_delay++;
    }  
    // Timer(s)/Counter(s) Interrupt(s) initialization
    //TIMSK= 0x01; //Set TOIE0 to enable timer0 overflow interrupt
    //LED=~LED;  //For TEST
    //TIMSK= 0x00; //Disable timer0 overflow interrupt           
};
///////////////////////////////////////////////////////////
void CheckSW(void)
{
    if(!SW_GIAM)
    {
        Delay_100us(50);
        if(count>0) count--;
        else        count=0;
         
    }
    if(!SW_TANG)
    {
        Delay_100us(50);  
        if(count<90) count++;
        else         count=90;
    }
};                                                      
///////////////////////////////////////////////////////////
void Display()
{
    unsigned char i,Q;
    unsigned char Dvi,Chuc;
    Dvi=Maled[count%10];
    Chuc=Maled[count/10];
    Q=Chuc; for(i=0;i<8;i++){SDI=Q&0x80;CLK=0;CLK=1;Q<<=1;} 
    Q=Dvi; for(i=0;i<8;i++){SDI=Q&0x80;CLK=0;CLK=1;Q<<=1;} 
    STR=0; STR=1; 
};
/*--------------------------------------------------------*/





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
#define LED         PORTB.1
#define SW_TANG     PINC.1
#define SW_GIAM     PINC.0
#define CLK         PORTC.3
#define SDI         PORTC.4
#define STR         PORTC.2

/* ------Cac dinh nghia ve chuong trinh va cac bien--------*/
//-----------------------------------------------------------
//Dinh nghia cac bien toan cuc
unsigned int count=0;                   //Count for the system value
unsigned int T_delay=0;                 //Tang 1 moi khi ngat timer0 (100us)
unsigned char Maled[10]={0xC0, 0xF9, 0xA4, 0xB0, 0x99, 0x92, 0x82, 0xF8, 0x80, 0x90};
//Dinh nghia cac chuong trinh
void INT0_INIT(void);                   //Khoi tao cho ngat ngoai
void Timer0_INIT(void);                 //Khoi tao thong so va ngat cho Timer0
void GPIO_INIT(void);                   //Khoi tao cac input, output
//void Delay_100us(unsigned int Time);    //Delay 100us ung voi moi don vi
void Display();
void CheckSW(void);
/*---------------------Interrupt Service Routine-----------*/                                                                                                                 /*------------Cac chuong trinh ngat----------------------*/
interrupt [EXT_INT0] void ext_int0_isr(void)
{// External Interrupt 0 service routine
//----------------Cach0--------------------  
    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK|= 0x01;   //Set TOIE0 to enable timer0 overflow interrupt
    if(T_delay==count)
    {
    LED=1;
   // delay_us(200);
    LED=0;
    TIMSK&=~0x01; //Disable timer0 overflow interrupt
    }
    TCNT0=  0x9C;    //Load 100 to Timer0
//----------------Cach1---------------------
//    Delay_100us(count);   
//    LED=1;
//    Delay_100us(2);
//    LED=0; 
};
////////////////////////////////////////////////////////////////
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    T_delay++;
    TCNT0=  0x9C;    //Load 100 to Timer0
};
/*----------------------------------------------*/
void main(void)
{
GPIO_INIT();
Timer0_INIT();
INT0_INIT();
#asm("sei")
while (1)
      {
      CheckSW();
      Display();
      }     
};
/*--------------Cac chuong trinh con--------------------*/
void INT0_INIT(void)
{
    // External Interrupt(s) initialization
    // INT0: On
    // INT0 Mode: Rising Edge
    // INT1: Off
    GICR|=(0<<INT1) | (1<<INT0);
    MCUCR=(0<<ISC11) | (0<<ISC10) | (1<<ISC01) | (1<<ISC00);
    GIFR=(0<<INTF1) | (1<<INTF0);
    
};   
//////////////////////////////////////////////////////////
void Timer0_INIT(void)
{
    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: 8000.000 kHz
    // Prescaler: 8
    TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);  //Prescaler - 8
};
///////////////////////////////////////////////////////////
void GPIO_INIT(void)
{
    // Input/Output Ports initialization
    // Port B initialization
    // Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
    DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
    // State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
    PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

    // Port C initialization
    // Function: Bit6=In Bit5=In Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In 
    DDRC=(0<<DDC6) | (0<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (0<<DDC1) | (0<<DDC0);
    // State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);

    // Port D initialization
    // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
    // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
};
///////////////////////////////////////////////////////////
//void Delay_100us(unsigned int Time) 
//{   
//    unsigned long T_delay=0;
//    while(T_delay<Time)
//    {
//        TCNT0=0;         
//        while(TCNT0<100); 
//        T_delay++;
//    }             
//};
///////////////////////////////////////////////////////////
void CheckSW(void)
{
    if(!SW_GIAM)
    {
        //delay_ms(50);
        if(count>0) count--;
        else        count=0;
         
    }
    if(!SW_TANG)
    {
        //delay_ms(50);  
        if(count<90) count++;
        else         count=90;
    }
};                                                      
///////////////////////////////////////////////////////////
void Display()
{
    unsigned char i,Q;
    unsigned char Dvi,Chuc;
    Dvi=Maled[count%10];
    Chuc=Maled[count/10];
    Q=Chuc; for(i=0;i<8;i++){SDI=Q&0x80;CLK=0;CLK=1;Q<<=1;} 
    Q=Dvi; for(i=0;i<8;i++){SDI=Q&0x80;CLK=0;CLK=1;Q<<=1;} 
    STR=0; STR=1; 
};
/*--------------------------------------------------------*/
