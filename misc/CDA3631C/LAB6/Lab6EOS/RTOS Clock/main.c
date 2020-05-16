/*----------------------------------------------------------------------------
 * CMSIS-RTOS 'main' function template
 *---------------------------------------------------------------------------*/
 
#include "RTE_Components.h"
#include  CMSIS_device_header
#include "cmsis_os2.h"
#include "Board_GLCD.h"
#include "Board_LED.h"
#include "Board_Buttons.h"
#include "GLCD_Config.h"
#include "stm32f2xx_hal.h"
#include "rtx_os.h"
#include "rtosClockObjects.h"    // specific to this project
 extern GLCD_FONT GLCD_Font_16x24;

// Note that the main file declares the space for all the system's variables (someone has to),
// and "extern" declarations are in the rtosClockObjects.h file so other files can find them
uint32_t hour=21, minute=37, second=59;
osMutexId_t mutHour, mutMinute, mutSecond;
osSemaphoreId_t semDisplayTime;

/********************************************/
// The RTOS and HAL need the SysTick for timing. The RTOS wins and gets control
// of SysTick, so we need to route the HAL's tick call to the RTOS's tick.
uint32_t HAL_GetTick(void) { 
  return osKernelGetTickCount();
}


/*----------------------------------------------------------------------------
 * HW Init - since the HAL depends on a periodic timer, we need the RTOS
 * in order for several HW devices to initialize correctly, like the GLCD
 *---------------------------------------------------------------------------*/
void app_hw_init (void *argument) {
	
	GLCD_Initialize();
	GLCD_SetBackgroundColor(GLCD_COLOR_PURPLE);
	GLCD_SetForegroundColor(GLCD_COLOR_WHITE);
	GLCD_ClearScreen(); 
	GLCD_SetFont(&GLCD_Font_16x24);
	
	// Create other threads here so that all initialization is done before others get scheduled.
	Init_thdDisplayTime();
	osThreadSetPriority(tid_thdDisplayTime, osPriorityBelowNormal); // No need other than to have an example
	
	
  osThreadExit(); // job is done, thread suicide. There better be other threads created...
}
 
int main (void) {
 
 	SystemCoreClockUpdate();	// always first, make sure the clock freq. is current
	osKernelInitialize();     // Initialize CMSIS-RTOS
	HAL_Init();   			
	Buttons_Initialize();			// Does NOT use a HAL tick during initialization
	LED_Initialize();
	
		// To configure the USER button to generate an interrupt...
		EXTI->IMR |= 1<<15;     	// Enable EXTI15 - Edge interrupt for all pin 15's
		EXTI->FTSR |= 1<<15;  		// configure for rising edge
		RCC->APB2ENR |= 1<<14; 		// Turn on bus clock for the system configuration to turn on edge detector
														// Set the EXTI control register to look at Port G's pin 15
		SYSCFG->EXTICR[3] =	(SYSCFG->EXTICR[3] & ~0x0000F000) | SYSCFG_EXTICR4_EXTI15_PG;
														
		/* The EXTI, or external interrupt module, is now sending flags to the NVIC for the interrupts
		coming from pins 10-15 (it routes all 6 to one IRQ to save space). Next, we have to enable the
		NVIC to pay attention to this interrupt.   */

		NVIC->ISER[EXTI15_10_IRQn/32] |= 1<< (EXTI15_10_IRQn%32);
		// USER edge triggered interrupt is now active. NOTE: The line above can be moved anywhere to enable the 
		// USER button interrupt.   Don't mess with anything else.
	
	
		mutHour = osMutexNew(NULL);
			if (mutHour==NULL) while(1){} // failed, scream and die
		mutMinute = osMutexNew(NULL);
			if (mutHour==NULL) while(1){} // failed, scream and die
		mutSecond = osMutexNew(NULL);
			if (mutHour==NULL) while(1){} // failed, scream and die
	
  osThreadNew(app_hw_init, NULL, NULL); // Create application main thread
  osKernelStart();                      // Start thread execution
  for (;;) {}  													// should never get here
}




void EXTI15_10_IRQHandler(void)
{
	static int32_t i;  // Reminder that an ISR can create local memory with a "static" modifier
	// The NVIC automatically clears the flag bit in NVIC for EXTI15_10_IRQHandler by jumping to this vector address
	// However, we must also manually clear the interrupt flag for EXTI15
	if (EXTI->PR & 1<<15)  // flag bit for EXTI15 is set
	{
		EXTI->PR = 1<<15;   // Acknowledge flag bit by storing a 1 into the flag bit, 0's in other bits are ignored.
		// code for EXTI15 - USER button goes here
		minute = (minute+1)%60; // proof the ISR ran...but violates data access principles!!!
		return;	
	}		
	else { // EXTI interrupts for pins 10-14 can be sequentially checked for here if they are enabled/configured
		// otherwise this NVIC interrupt should have been triggered, so
		while(1) {i++;} // scream and die	
	}
	
}
