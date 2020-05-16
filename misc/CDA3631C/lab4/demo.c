#include <stdint.h>
#include <stdio.h>
#include "stm32f207xx.h"
#include "Board_LED.h"                  // ::Board Support:LED

// Configuring WAKEUP button using External Interrupt EXTI0 //
void button_init(void)
{
	/*1. Enable GPIOA clock as WAKEUP button is connected to GPIOA port in pin 0 */
	
	RCC->AHB1ENR |= 0x01;
	
	/* 2. Set SYSCFG EXTI REG*/
	RCC->APB2ENR |= (1 <<14); // enables the clock to configure SYSCFG registers.
	SYSCFG->EXTICR[0]= SYSCFG_EXTICR1_EXTI0_PA; // Configures the EXTI0 line with PA0
	
	/* 3. set the mode of GPIOA pin0 to "INPUT" using GPIOx_MODER register*/
	GPIOA->MODER &= ~03; 
	
	/*4. set the interrupt triggering level : Falling edge */
	//(EXTI_FTSR
	EXTI->FTSR |= 0X01;
	

	/*5. enable the interrupt over EXTI0 : Unmasking the EXTI0 interrupt so that it is not ignored*/
	EXTI-> IMR|= 0X01;
	

	/*6. the interrupt on NVIC for IRQ6 */

	NVIC_EnableIRQ(EXTI0_IRQn);
	
	
}

void delay (void)
{
	for (int i=0; i<5000000; i++);
}

int main()
{
	LED_Initialize();	
	button_init();

	/*infinite loop */
	while(1)
	{
	}

	return 0;
}

void EXTI0_IRQHandler(void)
{
	/*clear the pending bit for exti0 */
		if( (EXTI->PR & 0x01) )
	{
		EXTI->PR = 0x01;//Writing 1 , clears the pending bit for exti0
	}
	while(1)
	{
		LED_Off(0);
		delay();
		LED_On(0);
		delay();
	}
}

