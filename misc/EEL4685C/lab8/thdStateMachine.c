#include "lab_8.h"
/**
	* Modified from assignment provided sources: 
	* Author of modifications: Peter A. Dranishnikov
	* Lab #: 8
	* Course: EEL4685C
	* Due date: April 23, Spring 2019
	*/
/*----------------------------------------------------------------------------
 *      Thread 4 'Thread_StateMachine': State Machine thread
 * This thread is the primary state machine of a supposed gear shifter
 * Triggers on the statemachine semaphore
 * 
 *---------------------------------------------------------------------------*/

void thdStateMachine(void *argument);
void fsm_reaction(bool up, bool down);
osThreadId_t tid_thdStateMachine;
uint32_t tgear;

int Init_thdStateMachine(void)
{
	tid_thdStateMachine = osThreadNew(thdStateMachine, NULL, NULL);
	if(!tid_thdStateMachine) return(-1);
	tgear = 0;
	return(0);
}

void thdStateMachine(void *argument)
{
	while(1)
	{
		osSemaphoreAcquire(semSM, osWaitForever);
		bool u = joychar == 'D' || (treceiveChar == 'U' || treceiveChar == 'u');
		bool d = joychar == 'U' || (treceiveChar == 'D' || treceiveChar == 'd');
		fsm_reaction(u, d);
		//IMPORTANT: these values must be set to zero for the state machine to transition correctly
		treceiveChar = 0x00;
		joychar = 0x00;
	}
}

void fsm_reaction(bool up, bool down)
{
	
	switch (tgear)
	{
		
		case 0:
			if (up && !down)
			{
				tgear = 1;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			else if (up && down)
			{
				tgear = 0;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			else if (!up && down)
			{
				tgear = 0;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
				
			}
			else
			{
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			break;
		case 1:
			if (up && !down)
			{
				tgear = 2;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
				
			}
			else if (up && down)
			{
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
				tgear = 1;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			else if (!up && down)
			{
				tgear = 0;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			else;
			break;
		case 2:
			if (up && !down)
			{
				tgear = 3;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			} 
			else if (up && down) 
			{
				tgear = 2;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			else if (!up && down)
			{
				tgear = 1;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			else;
			break;
		case 3:
			if (up && !down)
			{
				tgear = 4;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			} 
			else if (up && down) 
			{
				tgear = 3;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			else if (!up && down)
			{
				tgear = 2;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			else;
			break;
		case 4:
			if (up && !down)
			{
				tgear = 5;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			} 
			else if (up && down) 
			{
				tgear = 4;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			else if (!up && down)
			{
				tgear = 3;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			else;
			break;
		case 5:
			if (up && !down)
			{
				tgear = 6;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			} 
			else if (up && down) 
			{
				tgear = 5;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			else if (!up && down)
			{
				tgear = 4;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			else;
			break;
		case 6:
			if (up && !down)
			{
				tgear = 6;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			} 
			else if (up && down) 
			{
				tgear = 6;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			else if (!up && down)
			{
				tgear = 5;
				osSemaphoreRelease(semChar);
				osSemaphoreRelease(semTick);
			}
			else;
			break;
		default:
			for(;;){}
	}
}
