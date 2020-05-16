/****************************************************
* Filename: lab7.c
* Version 1.0
* Description: Selectable pulse-width generator
* Author: Peter Dranishnikov
* Target: Atmel AtMega328p
* Compiler: avr-gcc
* Last modified: Wednesday, November 28th, 2018
*****************************************************/
#include <stdint.h>

typedef struct port_struct
{
    volatile uint8_t PIN;
    volatile uint8_t DDR;
    volatile uint8_t PORT;
} GPIO_PORT_t;

volatile GPIO_PORT_t *portd = (GPIO_PORT_t *) 0x29;

/*
* n measured in 100 usec
* attempt to achieve 0.1% of true value
*/
volatile void delay(register uint8_t n)
{
    for(++n; n > 0; n--)
    {
        register uint8_t i;
        for(i = 0; i < 255; i++);
    }
    return;
}
int main()
{
    portd->DDR = 0x08;
    volatile uint8_t x;
    uint8_t scale_delay;
    
    while(1)
    {
        x = portd->PIN & 0x07; //read switch val
        portd->PORT = 0x08; //switch on
        scale_delay = 207;
        switch(x)
        {
            case(0x00):
                scale_delay = 5;
                delay(scale_delay);
                break;
            case(0x01):
                scale_delay = 10;
                delay(scale_delay);
                break;
            case(0x02):
                scale_delay = 13;
                delay(scale_delay);
                break;
            case(0x03):
                scale_delay = 17;
                delay(scale_delay);
                break;
            case(0x04):
                scale_delay = 20;
                delay(scale_delay);
                break;
            case(0x05):
                scale_delay = 40;
                delay(scale_delay);
                break;
            case(0x06):
                scale_delay = 80;
                delay(scale_delay);
                break;
            case(0x07):
                scale_delay = 120;
                delay(scale_delay);
                break;
        }
        scale_delay = 207 - scale_delay;
        portd->PORT = 0x00; //turn off
        delay(scale_delay);
    }
    return 0;
}
