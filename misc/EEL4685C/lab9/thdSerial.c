/**
	* Modified from assignment provided sources: 
	* Author of modifications: Peter A. Dranishnikov
	* Lab #: 9
	* Course: EEL4685C
	* Due date: April 23, Spring 2019
	*/
#include "lab_9.h"
#include "serial.h"

/*----------------------------------------------------------------------------
 *      Thread 3 'Thread_Serial': Display thread
 * This thread outputs to the serial port in format x,y,z0
 * (no spaces, comma-separated, null (\0) terminated)
 * Acts on semaphore of tick interval 1/5 second
 *---------------------------------------------------------------------------*/

void thdSerial(void *argument);
osThreadId_t tid_thdSerial;
//uint32_t sampleCount;

int Init_thdSerial (void) {
 
	tid_thdSerial = osThreadNew (thdSerial, NULL, NULL);
	if (!tid_thdSerial) return(-1);
	//sampleCount = 1;
	
	return(0);
}

void thdSerial(void *argument)
{
	//declare stuff
	ACCELEROMETER_STATE accel;
	char accelx[6] = "      ";
	char accely[6] = "      ";
	char accelz[6] = "      ";
	while(1)
	{
		osSemaphoreAcquire(semTick5_interval, osWaitForever);
		
		osMutexAcquire(mut3Accelerometer,osWaitForever);
		Accelerometer_GetState(&accel);
		osMutexRelease(mut3Accelerometer);
		
		int2char(accelx, accel.x);
		int2char(accely, accel.y);
		int2char(accelz, accel.z);
		
		
		osMutexAcquire(mut2Serial,osWaitForever);
		//SER_PutChar(sampleCount + 0x30);
		//SER_PutChar(',');
		for(uint32_t i = 0; i < 3; i++)
		{
			SER_PutChar(accelx[5 - i]);
		}
		SER_PutChar('.');
		for(uint32_t i = 3; i < 6; i++)
		{
			SER_PutChar(accelx[5 - i]);
		}
		SER_PutChar(',');
		
		for(uint32_t i = 0; i < 3; i++)
		{
			SER_PutChar(accely[5 - i]);
		}
		SER_PutChar('.');
		for(uint32_t i = 3; i < 6; i++)
		{
			SER_PutChar(accely[5 - i]);
		}
		SER_PutChar(',');
		
		for(uint32_t i = 0; i < 3; i++)
		{
			SER_PutChar(accelz[5 - i]);
		}
		SER_PutChar('.');
		for(uint32_t i = 3; i < 6; i++)
		{
			SER_PutChar(accelz[5 - i]);
		}
		//if needed, add a line ending sequence of your choice here
		//SER_PutChar('\r');
		SER_PutChar('\0');
		osMutexRelease(mut2Serial);
		
	}
}
