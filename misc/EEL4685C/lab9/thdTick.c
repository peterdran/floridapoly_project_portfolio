/**
	* Modified from assignment provided sources: 
	* Author of modifications: Peter A. Dranishnikov
	* Lab #: 9
	* Course: EEL4685C
	* Due date: April 23, Spring 2019
	*/
#include "cmsis_os2.h"
#include "lab_9.h" 


#define UPDATEFREQ 15 //lcm of 3 and 5
/*----------------------------------------------------------------------------
 *      Thread 2 'Thread_ticker': Tick generator thread
 * This thread generates a combined tick and flags a semaphore based on the
 * multiple of the master frequency
 *---------------------------------------------------------------------------*/
 
void thdTick (void *argument);                                 // thread function
osThreadId_t tid_thdTick;                                      // thread id
 
int Init_thdTick (void) {
  tid_thdTick = osThreadNew (thdTick, NULL, NULL);
  if (!tid_thdTick) return(-1);
  return(0);
}
//The embedded version of fizzbuzz
void thdTick (void *argument) {
	uint32_t timerCount = 0;
	
	while (1) 
	{
		osDelay(osKernelGetTickFreq()/UPDATEFREQ);
		
		if(timerCount % 3 == 0)
			osSemaphoreRelease(semTick5_interval);
		if(timerCount % 5 == 0)
			osSemaphoreRelease(semTick3_interval);
		if(timerCount == UPDATEFREQ)
			timerCount = 0;
		timerCount++;
	}
}
