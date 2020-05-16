#include "eel4746c.h"

void delay()
{

}


int main(){
  portb->DDR=0xFF;
  tc0->TCCRA=0x42;
  tc0->TCCRB,0x03;
  tc0->OCRA=124;
  while(1)
  {


  }
}
