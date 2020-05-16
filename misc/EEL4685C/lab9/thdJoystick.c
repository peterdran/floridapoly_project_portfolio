/* this thread not needed
#include "cmsis_os2.h"                                        // CMSIS RTOS header file
#include "lab_9.h"


void thdJoystick (void *argument);                                 // thread function
osThreadId_t tid_thdJoystick;                                      // thread id
 
int Init_thdJoystick (void) {
 
  tid_thdJoystick = osThreadNew (thdJoystick, NULL, NULL);
  if (!tid_thdJoystick) return(-1);
  
  return(0);
}
 
void thdJoystick (void *argument) {
 
	uint32_t newjoystick, joystick;
	uint32_t joychar;
	
  while (1) 
	{
	  osDelay(osKernelGetTickFreq()/10);
		
	  newjoystick = Joystick_GetState();
	  if (joystick != newjoystick)
	  {
		  switch (joystick)
		  {
			  case JOYSTICK_UP:
				  joychar = 'U';
				  break;
			  case JOYSTICK_DOWN:
				  joychar = 'D';
				  break;
			  default:
				  break;	
		  }
		  osMutexAcquire(mut1Display, osWaitForever);
			  GLCD_DrawChar(100,10,joychar);		
		  osMutexRelease(mut1Display);
	  }
	  joystick = newjoystick;		// suspend thread
  }
}
*/