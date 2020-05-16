#include "lab_8.h"
#include "serial.h" 
 /**
	* Modified from assignment provided sources: 
	* Author of modifications: Peter A. Dranishnikov
	* Lab #: 8
	* Course: EEL4685C
	* Due date: April 23, Spring 2019
	*/
/*----------------------------------------------------------------------------
 *      Thread 2 'Thread_Display': Serial log thread
 * This may sound like a misnomer, but it indeed "displays" to the serial port.
 * Data displayed include the thread timer's value and the current gear
 * Triggers on the tick semaphore
 *---------------------------------------------------------------------------*/

void thdDisplay (void *argument);                                 // thread function
osThreadId_t tid_thdDisplay;                                      // thread id

int Init_thdDisplay (void) {
  tid_thdDisplay = osThreadNew(thdDisplay, NULL, NULL);
  if (!tid_thdDisplay) return(-1);
  return(0);
}

void thdDisplay (void *argument) 
{
	//placeholder text, first 8 characters overritten
	uint32_t text[11] = {'0','0','0','.','0','0',' ','g','\r','\n','\0'}; 
	uint32_t timerDecomp[6];
	while (1) 
	{
		osSemaphoreAcquire(semTick, osWaitForever);
		
		//isolate decimal digits for display
		timerDecomp[5] = ttimerSec % 10;
		timerDecomp[4] = (ttimerSec % 100) / 10;
		timerDecomp[2] = (ttimerSec % 1000) / 100;
		timerDecomp[1] = (ttimerSec % 10000) / 1000;
		timerDecomp[0] = (ttimerSec % 100000) / 10000; //don't know of a better way
		
		//convert to ascii
		for(uint32_t i = 0; i < 6; i++)
		{
			if(i != 3)
			{
				text[i] = timerDecomp[i] + 48;
			}
		}
		text[7] = tgear + 48;
		
		//dump to serial
		osMutexAcquire(mut2Ser, osWaitForever);
		for(uint32_t i = 0; text[i] != '\0'; i++)
			SER_PutChar(text[i]);
		osMutexRelease(mut2Ser);
		
	}
}
