/* This thread is not needed
#include "cmsis_os2.h"                                        // CMSIS RTOS header file
#include "rtx_os.h"
#include "lab_9.h"

 

void thdChar (void *argument);                                 // thread function
osThreadId_t tid_thdChar;                                      // thread id

int Init_thdChar (void) {
  tid_thdChar = osThreadNew (thdChar, NULL, NULL);
  if (!tid_thdChar) return(-1);
  return(0);
}

void thdChar (void *argument) {

  while (1) { // almost all threads loop forever, and block on an OS object, like a 
							// semaphore or mutex, until it is needed.
		osSemaphoreAcquire(semChar, osWaitForever);
		
		osMutexAcquire(mut1Display, osWaitForever);
			GLCD_DrawChar(10,100,treceiveChar);		
		osMutexRelease(mut1Display);
	
  }
}
*/