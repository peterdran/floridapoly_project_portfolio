#include <stdint.h>
#include <stdio.h>
#include "stm32f207xx.h"
#include "Board_LED.h"

int peopleIn = 0;
int peopleOut = 0;

void button_init (void)
{
	int i = 1;

    RCC-> AHB1ENR |=0x01;

    RCC->APB2ENR |=(i<<14);
    SYSCFG->EXTICR[3]=SYSCFG_EXTICR4_EXTI15_PG;
	SYSCFG->EXTICR[0]=SYSCFG_EXTICR1_EXTI0_PA;

    GPIOA->MODER &= ~0xC0000003;

    EXTI->FTSR |= 0x08001;

    EXTI->IMR |= 0x08001;

    NVIC_EnableIRQ(EXTI15_10_IRQn);
	NVIC_EnableIRQ(EXTI0_IRQn);

}

int main()
{
    LED_Initialize();
    button_init();
    while (1)
	{
		LED_SetOut(peopleIn - peopleOut);
	}
    return 0;
}
void EXTI0_IRQHandler(void) //people in
{
    if(EXTI->PR&0x01)
    {
        EXTI->PR = 0x01;
    }
    peopleIn++;
}
void EXTI15_10_IRQHandler(void) //people out
{
    if(EXTI->PR&0x08000)
    {
        EXTI->PR = 0x08000;
    }
    peopleOut++;
}
