/**
	* Modified from assignment provided sources: 
	* Author of modifications: Peter A. Dranishnikov
	* Lab #: 9
	* Course: EEL4685C
	* Due date: April 23, Spring 2019
	*/
/*----------------------------------------------------------------------------
 * CMSIS-RTOS 'main' function
 * This is the main function for initializing the serial, display, and ticker
 * threads
 * Mutexes: display, serial, accelerometer
 * Semaphores: tick 1/3 of second, tick 1/5 of second
 *---------------------------------------------------------------------------*/
 
#include "RTE_Components.h"
#include  CMSIS_device_header
#include "serial.h"
#include "cmsis_os2.h"
#include "GLCD_Config.h"
#include "stm32f2xx_hal.h"
#include "rtx_os.h"
#include "lab_9.h"    // specific to this project
extern GLCD_FONT GLCD_Font_16x24;

// Note that the main file declares the space for all the system's variables (someone has to),
// and "extern" declarations are in the rtosClockObjects.h file so other files can find them

osMutexId_t mut1Display;
osMutexId_t mut2Serial;
osMutexId_t mut3Accelerometer;
osSemaphoreId_t semTick3_interval;
osSemaphoreId_t semTick5_interval;


//osSemaphoreId_t semChar;

uint32_t treceiveChar;

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
	Accelerometer_Initialize();
	
	SER_Init(115200);  	// 115200 baud, 8 data bits, 1 stop bits, no flow control
	// configures and enables the interrupt for the USART 3 serial port. 
	USART3->CR1 |= USART_CR1_RXNEIE;
	NVIC->ISER[ USART3_IRQn/32] =  (1UL << (USART3_IRQn%32));
	NVIC->IP[USART3_IRQn] = 0x80;
	
	
	// Create other threads here so that all initialization is done before others get scheduled.
	Init_thdDisplay();
	Init_thdTick();
	//Init_thdChar();
	//Init_thdJoystick();
	Init_thdSerial();
	
  osThreadExit(); // job is done, thread suicide. There better be other threads created above...
}
 
int main (void) {
 
 	SystemCoreClockUpdate();	// always first, make sure the clock freq. is current
	osKernelInitialize();     // Initialize CMSIS-RTOS
	HAL_Init();
	
	mut1Display = osMutexNew(NULL);
		if (mut1Display==NULL) while(1){} // failed, scream and die
	mut2Serial = osMutexNew(NULL);
		if (mut2Serial == NULL) while(1){}
	mut3Accelerometer = osMutexNew(NULL);
		if (mut3Accelerometer == NULL) while(1) {}
	
	semTick3_interval = osSemaphoreNew(1000, 1, NULL);
		if (semTick3_interval==NULL) while(1){} // failed, scream and die
	semTick5_interval = osSemaphoreNew(1000, 1, NULL);
		if (semTick5_interval==NULL) while(1){} //AAAAAAAAAAAAAAAAAAAAAAA
	//semChar = osSemaphoreNew(1000, 0, NULL);
	//	if (semChar==NULL) while(1){} // failed, its a comment doh!
			
	osThreadNew(app_hw_init, NULL, NULL); // Create application's main thread to init HW now that HAL is running
	osKernelStart();                      // Start thread execution
	for (;;) {}  						// should never get here
}


// Interrupt service routine for the serial port. It is triggered upon receiving any character
void USART3_IRQHandler(void)
{
		
	treceiveChar = SER_GetChar();//value not used, but needed to prevent OS freeze upon character receive
	/*
	if (treceiveChar >= 'A' && treceiveChar <= 'Z')
	{
		osSemaphoreRelease(semChar);
	}
	*/
	
}

