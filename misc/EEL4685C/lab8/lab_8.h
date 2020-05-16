#ifndef example_lab_8
	#define example_lab_8
	
	#include "stdint.h"
	#include "Board_Joystick.h"
  #include "Board_GLCD.h"
	
	#include "cmsis_os2.h"
	#include "rtx_os.h"
	
	/**
	* Modified from assignment provided sources: 
	* Author of modifications: Peter A. Dranishnikov
	* Lab #: 8
	* Course: EEL4685C
	* Due date: April 23, Spring 2019
	*/
	
	// shared variables
	extern uint32_t treceiveChar; 
	extern uint32_t ttimerSec;
	extern uint32_t tgear;
	extern uint32_t joychar;

	
	// mutexes
	// Note, actual variable declarations are in main.c, since exactly one file must create the space.
	// The extern statements tell other files that the variable already exists, and they are allowed to access it.
	extern osMutexId_t mut1Display;
	extern osMutexId_t mut2Ser; //mutex for serial output
	
	// flag semaphores
	extern osSemaphoreId_t semTick;
	extern osSemaphoreId_t semChar;
	extern osSemaphoreId_t semSM;
	//extern osSemaphoreId_t semDisp; //not needed, semTick handles display thread
	

	//threads
	extern osThreadId_t tid_thdDisplay;
	int Init_thdDisplay (void);
	
	extern osThreadId_t tid_thdTick;
	int Init_thdTick (void);
	
	extern osThreadId_t tid_thdChar;
	int Init_thdChar (void);
	
	extern osThreadId_t tid_thdJoystick;
	int Init_thdJoystick (void);
	//New: sm thread declaration
	extern osThreadId_t tid_thdStateMachine;
	int Init_thdStateMachine (void);
	
#endif
