//*************************************************************
//
// File Name:     eel4746c.h
//
// Version:       1.0
//
// Description:   Arduino UNO header I/O structures
//
// Author:        Youssif Al-Nashif
//
// Target:        Arduino UNO
//
// Compiler:      avr-gcc
//
// Last Modified: 12-04-2018 @ 9:02 AM
//
// ************************************************************


#include <stdint.h>

#ifndef _EEL4746C_H_
#define _EEL4746C_H_


// Structure for GPIO ports
typedef struct gpio_port_struct {
    uint8_t PIN;          // Input Register
    uint8_t DDR;          // Data Directional Register
    uint8_t PORT;         // Output Register
} gpio_port_t;

// The three GPIO ports (B,C, and D)
volatile gpio_port_t *portb=(gpio_port_t *) 0x0023;
volatile gpio_port_t *portc=(gpio_port_t *) 0x0026;
volatile gpio_port_t *portd=(gpio_port_t *) 0x0029;


// 8-bit Time/Counter Structure
typedef struct timer_counter_8bit_struct {
    uint8_t TCCRA;        // Control Register A
    uint8_t TCCRB;        // Control Register B
    uint8_t TCNT;         // Counter (value)
    uint8_t OCRA;         // Output Compare Register A
    uint8_t OCRB;         // Output Compare Register B
} timer_counter_8bit_t;

// Timer/Counter 0
volatile timer_counter_8bit_t *tc0=(timer_counter_8bit_t *) 0x0044;

// Timer/Counter 0 Interrupt Flag Register
volatile uint8_t *TIFR0= (uint8_t *) 0x0035;

// Timer/Counter 0 Interrupt Mask Register
volatile uint8_t *TIMSK0=(uint8_t *) 0x006e;

// Analog to Digital Converter Structure
typedef struct adc_struct {
  uint8_t ADCL;           // ADC Data Register Low
  uint8_t ADCH;           // ADC Data Register High
  uint8_t ADCSRA;         // ADC Control and Status Register A
  uint8_t ADCSRB;         // ADC Control and Status Register B
  uint8_t ADMUX;          // ADC Multiplexer Selection Register
  uint8_t not_used;
  uint8_t DIDR0;          // Digital Input Disable Register 0
  uint8_t DIDR1;          // Digital Input Disable Register 1
} adc_t;

// ADC 
volatile adc_t *adc=(adc_t *) 0x0078;

#endif
