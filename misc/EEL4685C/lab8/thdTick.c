#include "cmsis_os2.h"                                        // CMSIS RTOS header file
#include "lab_8.h" 
/**
	* Modified from assignment provided sources: 
	* Author of modifications: Peter A. Dranishnikov
	* Lab #: 8
	* Course: EEL4685C
	* Due date: April 23, Spring 2019
	*/
/*----------------------------------------------------------------------------
 *      Thread 5 'Thread_tick': Ticker thread
 * This thread ticks. Thats it. 
 * This thread functions autonomously after init, but the delay can be adjusted
 * at compile time using the tickTime constant
 *---------------------------------------------------------------------------*/
 
void thdTick (void *argument);                                 // thread function
osThreadId_t tid_thdTick;                                      // thread id
const uint32_t tickTime = 100;
uint32_t ttimerSec;
 
int Init_thdTick (void) {
	tid_thdTick = osThreadNew (thdTick, NULL, NULL);
	if (!tid_thdTick) return(-1);
	ttimerSec = 0;
	return(0);
}
 
void thdTick (void *argument) {

	while (1) 
	{    
		osSemaphoreRelease(semTick);
		ttimerSec++;
		osDelay(osKernelGetTickFreq()/tickTime);
	
	}
}
