#include <stdint.h>


typedef struct twi_struct {
  uint8_t twbr;
  uint8_t twsr;
  uint8_t twar;
  uint8_t twdr;
  uint8_t twcr;
  uint8_t twamr;
} twi_t;

#define twen 2
#define twsto 4
#define twsta 5
#define twint 7

#define timedelay  200 /* Delay Introduced for Protocol */

#define RGB_MODE_REGISTER1  0x00
#define RGB_MODE_REGISTER2  0x01
#define BLUE_REGISTER       0x02
#define GREEN_REGISTER      0x03
#define RED_REGISTER        0x04
#define RGB_OUTPUT_REGISTER 0x08


volatile twi_t *twi= (twi_t *) 0x00B8;

void i2c_init();
void i2c_start();
void i2c_write(uint8_t payload);
void i2c_stop();


int main()
{
    uint8_t address=0xC4;     // LCD RGB Address
    i2c_init();


    i2c_start();
    i2c_write(address);
    i2c_write(RGB_MODE_REGISTER1);
    i2c_write(0x00);
    i2c_stop();


    i2c_start();
    i2c_write(address);
    i2c_write(RGB_OUTPUT_REGISTER);
    i2c_write(0xFF);
    i2c_stop();


    i2c_start();
    i2c_write(address);
    i2c_write(RGB_MODE_REGISTER2);
    i2c_write(0x20);
    i2c_stop();


    i2c_start();
    i2c_write(address);
    i2c_write(RED_REGISTER);
    i2c_write(0x1F);
    i2c_stop();

    i2c_start();
    i2c_write(address);
    i2c_write(GREEN_REGISTER);
    i2c_write(0x0B);
    i2c_stop();

    i2c_start();
    i2c_write(address);
    i2c_write(BLUE_REGISTER);
    i2c_write(0x4B);
    i2c_stop();
    while(1);
  return 0;
}

void i2c_stop()
{
  twi->twcr=((1<<twen)|(1<<twint)|(1<<twsto));
}

void i2c_write(uint8_t payload)
{
  uint16_t i;
  twi->twdr=payload;
  twi->twcr=(1<<twen)|(1<<twint);
  while (((twi->twcr)&(1<<twint))==0x00);
  for (i=0;i<timedelay;i++);
}


void i2c_start()
{
  twi->twcr=0xA4;// or ((1<<twen)|(1<<twint)|(1<<twsta))
  while (((twi->twcr)&(1<<twint))==0x00);
}

void i2c_init()
{
  uint16_t i;
  /* Enable Internal Pullups */
  twi->twsr=0x00;
  volatile uint8_t *DDRC=(uint8_t *) 0x0027;
  *DDRC=0x00;
  volatile uint8_t *PORTC=(uint8_t *) 0x0028;
  *PORTC=0xFF;

  /* initialize TWI */
  twi->twbr=0x48;
  twi->twsr=0x00;
  twi->twcr=0x04;
}
