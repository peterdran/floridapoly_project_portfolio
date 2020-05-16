#include "lab_8.h"

/**
	* Modified from assignment provided sources: 
	* Author of modifications: Peter A. Dranishnikov
	* Lab #: 8
	* Course: EEL4685C
	* Due date: April 23, Spring 2019
	*/
/*----------------------------------------------------------------------------
 *      Thread 1 'Thread_Char': Display character thread
 * Displays the current gear to the main onboard display. Initializes on boot
 * to display the current gear (at initialization, 0)
 * Triggers on the character semaphore
 *---------------------------------------------------------------------------*/

void thdChar (void *argument);                                 // thread function
osThreadId_t tid_thdChar;                                      // thread id

int Init_thdChar (void) {
  tid_thdChar = osThreadNew (thdChar, NULL, NULL);
  if (!tid_thdChar) return(-1);
  
  osMutexAcquire(mut1Display, osWaitForever);
	GLCD_DrawChar(100,100,(tgear + 48));
  osMutexRelease(mut1Display);
  
  return(0);
}

void thdChar (void *argument) 
{

	while (1) 
	{ 
		osSemaphoreAcquire(semChar, osWaitForever);
		
		
		osMutexAcquire(mut1Display, osWaitForever);
			GLCD_DrawChar(100,100,(tgear + 48));
		osMutexRelease(mut1Display);
		
	}
}
