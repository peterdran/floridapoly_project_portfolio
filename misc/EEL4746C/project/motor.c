//*************************************************************
//
// File Name:     motor.c
//
// Version:       1.0
//
// Description:   The code is used to find the pulse width
//                required to set the motor to the maximum
//                and minimum angles
//
// Author:        Youssif Al-Nashif
//
// Target:        Arduino UNO
//
// Compiler:      avr-gcc
//
// Last Modified: 12-04-2018 @ 10:58 AM
//
// ************************************************************

#include <stdlib.h>
#include "eel4746c.h"

void delay_8us()
{
  tc0->TCCRA=0x00;
  tc0->TCCRB=0x03;
  tc0->TCNT=255;
  *TIFR0=1;
  while((*TIFR0&0x01)==0);
}

void delay_in_8us(uint16_t x)
{
  uint16_t i;
  for (i=0;i<x;i++) delay_8us();
}

int main()
{
  // To set the period of the PWM to 20ms (2500x8us=20ms)
  uint16_t T=2500;

  // Find the values that will set the motor to
  // minimum angle and maximum angle. This will
  // differ from one motor to another. The motor
  // that I tested has 75 as the minimum value
  // and 325 is the maximum value. The angles from
  //0 deg to 190 deg
  uint16_t value=320;

  // Using port D pin 2 as the output
  portd->DDR=0x04;

  while(1)
  {
    // Set pin 2 of port D to high
    portd->PORT=4;

    // Length of the high time
    delay_in_8us(value);

    // Set pin 2 of port D to low
    portd->PORT=0;

    // Length of the low time
    delay_in_8us(T-value);
  }

  return 0;
}
