#ifndef __rtosClockObjects
	#define __rtosClockObjects
	
	// shared variables and mutexes
	extern uint32_t hour; 
	extern uint32_t minute; 
	extern uint32_t second;
	extern osMutexId_t mutHour; 
	extern osMutexId_t mutMinute; 
	extern osMutexId_t mutSecond;
	
	
	// flag semaphores
	extern osSemaphoreId_t semDisplayTime;
	
	
	//threads
	extern osThreadId_t tid_thdDisplayTime;
	int Init_thdDisplayTime (void);
#endif
