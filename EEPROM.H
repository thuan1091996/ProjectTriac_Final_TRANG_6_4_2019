#define EEPROM_H

void eepromWrite(unsigned short address,  unsigned char data);
unsigned char eepromRead(unsigned short address);

//TRANG 22 TRONG DATASHEET ATMEGA8
void eepromWrite(unsigned short address,  unsigned char data)
{                         
    //EEARH & EEARL: the EEPROM address register     
    //-    |-    |-    |-    |-    |-    |-    |EEAR8
    //EEAR7|EEAR6|EEAR5|EEAR4|EEAR3|EEAR2|EEAR1|EEAR0
//The EEPROM Address Registers – EEARH and EEARL – specify the EEPROM address in the
//512bytes EEPROM space. The EEPROM data bytes are addressed linearly between 0 and 511.
//The initial value of EEAR is undefined. A proper value must be written before the EEPROM may
//be accessed.    

    //EEDR: the EEPROM data register
//For the EEPROM write operation, the EEDR Register contains the data to be written to the
//EEPROM in the address given by the EEAR Register. For the EEPROM read operation, the
//EEDR contains the data read out from the EEPROM at the address given by EEAR.

    //EECR:the EEPROM control register
    //-    |-    |-    |-    |EERIE|EEMWE|EEWE|EERE
    //Bit 3 – EERIE: EEPROM Ready Interrupt Enable
    //Bit 2 – EEMWE: EEPROM Master Write Enable       
    //Bit 1 – EEWE: EEPROM Write Enable

    //EECR=(0<<EERIE)|(1<<EEMWE)|(1<<EEWE); //start EEPROM write
         
    // Wait for completion of previous write
    while(EECR && (1<<EEWE));               
    //Set up address and data registers    
    EEAR=address;
    EEDR=data;
    //Write logical one to EEMWE
    EECR=(1<<EEMWE);
    //Start eeprom write by setting EEWE
    EECR=(1<<EEWE);        
}

unsigned char eepromRead(unsigned short address)
{
    unsigned char data;
    // Wait for completion of previous write
    while(EECR && (1<<EEWE));               
    //Set up address and data registers    
    EEAR=address;
    //Start eeprom read by writing EERE
    EECR=(1<<EERE);
    //Return data from data register    
    data=EEDR;
    if(EEDR>254)
    {
        data=0;
    }
    return data;        
}


