#include "lab_8.h"
/**
	* Modified from assignment provided sources: 
	* Author of modifications: Peter A. Dranishnikov
	* Lab #: 8
	* Course: EEL4685C
	* Due date: April 23, Spring 2019
	*/
/*----------------------------------------------------------------------------
 *      Thread 3 'Thread_Joystick': Joystick thread
 * This thread is on a perpetual poll for new joystick positions
 * This thread does not trigger on any semaphore
 * This file used to have a drunk indentation format, which should be corrected
 * However, there may be a remaining combination of tabs and spaces
 * I apologize for any inconvenience this may cause when parsing
 *---------------------------------------------------------------------------*/
 
void thdJoystick (void *argument);                                 // thread function
osThreadId_t tid_thdJoystick;                                      // thread id
uint32_t joychar = ' ';
 
int Init_thdJoystick (void) {
 
  tid_thdJoystick = osThreadNew (thdJoystick, NULL, NULL);
  if (!tid_thdJoystick) return(-1);
  
  return(0);
}
 
void thdJoystick (void *argument) {
 
	uint32_t newjoystick, joystick;
	
	while (1) 
	{
		osDelay(osKernelGetTickFreq()/10);
		
		newjoystick = Joystick_GetState();
		if (joystick != newjoystick)
		{
			switch (newjoystick)
			{
				case JOYSTICK_UP:
				{
					joychar = 'U';
					osSemaphoreRelease(semSM);
					break;
				}
				case JOYSTICK_DOWN:
				{
					joychar = 'D';
					osSemaphoreRelease(semSM);
					break;
				}
				default:
					break;	
			}
		
		
		}
		joystick = newjoystick;		
	}
}
