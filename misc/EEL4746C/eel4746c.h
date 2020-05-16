#include <stdint.h>

#ifndef _EEL4746C_H_
#define _EEL4746C_H_

typedef struct gpio_port {
    uint8_t PIN;
    uint8_t DDR;
    uint8_t PORT;
} gpio_port_t;

gpio_port_t *portb=(gpio_port_t *) 0x0023;
gpio_port_t *portc=(gpio_port_t *) 0x0026;
gpio_port_t *portd=(gpio_port_t *) 0x0029;

typedef struct timer_counter_8bit {
    uint8_t TCCRA;
    uint8_t TCCRB;
    uint8_t TCNT;
    uint8_t OCRA;
    uint8_t OCRB;
} timer_counter_8bit_t;

volatile timer_counter_8bit_t *tc0=(timer_counter_8bit_t *) 0x0044;

volatile uint8_t *TIFR0= (uint8_t *) 0x0035;
volatile uint8_t *TIMSK0=(uint8_t *) 0x006e;


#endif
