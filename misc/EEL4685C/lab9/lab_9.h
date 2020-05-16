/**
	* Modified from assignment provided sources: 
	* Author of modifications: Peter A. Dranishnikov
	* Lab #: 9
	* Course: EEL4685C
	* Due date: April 23, Spring 2019
	*/
#ifndef __lab_9
	#define __lab_9
	#include "stdint.h"
	#include "Board_Joystick.h"
	#include "Board_GLCD.h"
	#include "Board_Accelerometer.h"
	#include "rtx_os.h"
	
	// shared variables
	extern uint32_t treceiveChar;
	
	// mutexes
	// Note, actual variable declarations are in main.c, since exactly one file must create the space.
	// The extern statements tell other files that the variable already exists, and they are allowed to access it.
	extern osMutexId_t mut1Display;  
	extern osMutexId_t mut2Serial;
	extern osMutexId_t mut3Accelerometer;
	
	// flag semaphores
	//extern osSemaphoreId_t semTick;
	extern osSemaphoreId_t semTick3_interval;
	extern osSemaphoreId_t semTick5_interval;
	

	//threads
	extern osThreadId_t tid_thdDisplay;
	int Init_thdDisplay (void);
	extern osThreadId_t tid_thdTick;
	int Init_thdTick (void);
	//extern osThreadId_t tid_thdChar;
	//int Init_thdChar (void);
	//extern osThreadId_t tid_thdJoystick;
	//int Init_thdJoystick (void);
	extern osThreadId_t tid_thdSerial;
	int Init_thdSerial(void);
	
	//helper functions
	extern void int2char(char *, int32_t);
#endif
