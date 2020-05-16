/**
	* Modified from assignment provided sources: 
	* Author of modifications: Peter A. Dranishnikov
	* Lab #: 8
	* Course: EEL4685C
	* Due date: April 23, Spring 2019
	*/
/*----------------------------------------------------------------------------
 * CMSIS-RTOS 'main' function
 * Contains all thread initialization (with support function), mutexes, 
 * semaphores, and an IRQHandler for serial input
 *---------------------------------------------------------------------------*/
 
 
#include "RTE_Components.h"
#include  CMSIS_device_header
#include "serial.h"
#include "GLCD_Config.h"
#include "stm32f2xx_hal.h"

#include "lab_8.h"    // specific to this project
extern GLCD_FONT GLCD_Font_16x24;

// Note that the main file declares the space for all the system's variables (someone has to),
// and "extern" declarations are in the lab_8.h file so other files can find them

osMutexId_t mut1Display;
osMutexId_t mut2Ser;
osSemaphoreId_t semTick;
osSemaphoreId_t semChar;
osSemaphoreId_t semSM;
//osSemaphoreId_t semDisp;

uint32_t treceiveChar;

void serial_first_message(void);

/********************************************/
// The RTOS and HAL need the SysTick for timing. The RTOS wins and gets control
// of SysTick, so we need to route the HAL's tick call to the RTOS's tick.
// Don't mess with this code.
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
	
	Joystick_Initialize();  // Note: Joystick now uses HAL functions
	
	SER_Init(115200);  	// 115200 baud, 8 data bits, 1 stop bits, no flow control
	// configures and enables the interrupt for the USART 3 serial port. 
	USART3->CR1 |= USART_CR1_RXNEIE;
	NVIC->ISER[ USART3_IRQn/32] =  (1UL << (USART3_IRQn%32));
	NVIC->IP[USART3_IRQn] = 0x80;
	serial_first_message();//print first serial message
	
	// Create other threads here so that all initialization is done before others get scheduled.
	Init_thdStateMachine();
	Init_thdDisplay();
	Init_thdTick();
	Init_thdChar();
	Init_thdJoystick();
	
  osThreadExit(); // job is done, thread suicide. There better be other threads created above...
}
 
int main (void) {
 
 	SystemCoreClockUpdate();	// always first, make sure the clock freq. is current
	osKernelInitialize();     // Initialize CMSIS-RTOS
	HAL_Init();
	
	mut1Display = osMutexNew(NULL);
		if (mut1Display==NULL) while(1){} // failed, scream and die
	mut2Ser = osMutexNew(NULL);
		if (mut2Ser == NULL) while(1){} //surrender on failure
	
	semTick = osSemaphoreNew(1000, 1, NULL);
		if (semTick==NULL) while(1){} // failed, scream and die
	semChar = osSemaphoreNew(1000, 0, NULL);
		if (semChar==NULL) while(1){} // failed, scream and die	
	semSM = osSemaphoreNew(1000, 1, NULL);
		if (semSM == NULL) while(1){} // surrender on failure
	
			
			
  osThreadNew(app_hw_init, NULL, NULL); // Create application's main thread to init HW now that HAL is running
  osKernelStart();                      // Start thread execution
  for (;;) {}  													// should never get here
}


// Interrupt serv routine for the serial port. Triggered upon receiving any character or space
void USART3_IRQHandler(void)
{
		
	treceiveChar = SER_GetChar();
	if (treceiveChar == 'D' || treceiveChar == 'd' || treceiveChar == 'U' || treceiveChar == 'u')
	{
		osSemaphoreRelease(semSM);
	}
	else; //do nothing
}

void serial_first_message(void)
{
	//"Time\tGear\r\n"; equivalent null-terminated string
	const uint32_t init_message[] = {'T', 'i', 'm', 'e', '\t', 'G', 'e', 'a', 'r', '\r', '\n', '\0'};
	
	osMutexAcquire(mut2Ser, osWaitForever);
	for(uint32_t i = 0; init_message[i] != '\0'; i++)
	{
		SER_PutChar(init_message[i]);
	}
	osMutexRelease(mut2Ser);
}
