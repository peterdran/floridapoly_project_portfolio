/**
	* Modified from assignment provided sources: 
	* Author of modifications: Peter A. Dranishnikov
	* Lab #: 9
	* Course: EEL4685C
	* Due date: April 23, Spring 2019
	*/
#include "cmsis_os2.h"
#include "rtx_os.h"
#include "lab_9.h"
 
 
/*----------------------------------------------------------------------------
 *      Thread 1 'Thread_Display': Display thread
 * Displays the current acceleration vectors on the onboard display
 * Acts on semaphore of tick interval 1/3 second
 *---------------------------------------------------------------------------*/

void thdDisplay (void *argument);
osThreadId_t tid_thdDisplay;

int Init_thdDisplay (void) {
  tid_thdDisplay = osThreadNew (thdDisplay, NULL, NULL);
  if (!tid_thdDisplay) return(-1);
  return(0);
}
 
void int2char(char [], int32_t);

void thdDisplay (void *argument) 
{
	
	ACCELEROMETER_STATE accel;
	char accelx[6] = "      ";
	char accely[6] = "      ";
	char accelz[6] = "      ";
	
	GLCD_DrawChar(20, 10, 'x');
	GLCD_DrawChar(20, 40, 'y');
	GLCD_DrawChar(20, 70, 'z');
	
	for(uint32_t i = 10; i <= 70; i += 30)
	{
		GLCD_DrawChar(40, i, ':');
		GLCD_DrawChar(120, i, '.');
		GLCD_DrawChar(200, i, 'g');
	}
	
	//TODO draw all axes to onboard display
	while (1) 
	{ 
		osSemaphoreAcquire(semTick3_interval, osWaitForever);
		
		osMutexAcquire(mut3Accelerometer,osWaitForever);
		
		Accelerometer_GetState(&accel);
		
		osMutexRelease(mut3Accelerometer);
		
		

		int2char(accelx, accel.x);
		int2char(accely, accel.y);
		int2char(accelz, accel.z);
		
		osMutexAcquire(mut1Display,osWaitForever);
		
		for(uint32_t i = 0; i < 6; i++)
		{
			if(i < 3)
				GLCD_DrawChar(180 - i * 20, 10, accelx[i]);
			else
				GLCD_DrawChar(100 - (i-3) * 20, 10, accelx[i]);
		}
		/*
		GLCD_DrawChar(60,  10, accelx[5]);
		GLCD_DrawChar(80,  10, accelx[4]);
		GLCD_DrawChar(100, 10, accelx[3]);

		GLCD_DrawChar(140, 10, accelx[2]);
		GLCD_DrawChar(160, 10, accelx[1]);
		GLCD_DrawChar(180, 10, accelx[0]);
		*/
		
		for(uint32_t i = 0; i < 6; i++)
		{
			if(i < 3)
				GLCD_DrawChar(180 - i * 20, 40, accely[i]);
			else
				GLCD_DrawChar(100 - (i-3) * 20, 40, accely[i]);
		}
		
		for(uint32_t i = 0; i < 6; i++)
		{
			if(i < 3)
				GLCD_DrawChar(180 - i * 20, 70, accelz[i]);
			else
				GLCD_DrawChar(100 - (i-3) * 20, 70, accelz[i]);
		}
		osMutexRelease(mut1Display);
		
		
	
	}
}

void int2char(char text[], int32_t data)
{
	uint32_t i;
	
	if (data < 0)
	{	
		text[5] = '-';
		data = -data;
	} 
	else
	{ 
	   text[5] = '+';
	}
	
	for (i = 0; i<5; i++)
	{
		text[i] = (data % 10)+0x30;
		data /= 10;
	}
}
