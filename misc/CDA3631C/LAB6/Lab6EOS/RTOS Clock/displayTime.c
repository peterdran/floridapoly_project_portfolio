#include "cmsis_os2.h"                                        // CMSIS RTOS header file
#include "rtx_os.h"
#include "rtosClockObjects.h"
#include "Board_GLCD.h" 
 
/*----------------------------------------------------------------------------
 *      Thread 1 'Thread_Name': Sample thread
 *---------------------------------------------------------------------------*/
 
#define XOFFSET 4  // time horizontal offset from left in characters
#define YOFFSET 3	// time vertical offset from top in characters
 
#define LCDWIDTH 320
#define LCDHEIGHT 240
#define CHARWIDTH 16
#define CHARHEIGHT 24
 
#define BORING
 
void thdDisplayTime (void *argument);                                 // thread function
osThreadId_t tid_thdDisplayTime;                                      // thread id

int Init_thdDisplayTime (void) {
 
  tid_thdDisplayTime = osThreadNew (thdDisplayTime, NULL, NULL);
  if (!tid_thdDisplayTime) return(-1);
  return(0);
}
 
void thdDisplayTime (void *argument) {
	uint32_t lhour, lminute, lsecond;		// local copies of global values so that mutexes may be released faster
	uint32_t hourMSD, hourLSD, minuteMSD, minuteLSD, secondMSD, secondLSD; // calculated digits for display

#ifndef BORING	 // avoids warnings about unused variables
	int x=115, right = 1, y = 57, down = 1;  // for the non-boring option
#endif
	
  while (1) {
		
		osDelay(osKernelGetTickFreq()/30);		// update screen 30 times per second
		
		osMutexAcquire(mutSecond, osWaitForever);
		osMutexAcquire(mutMinute, osWaitForever);
		osMutexAcquire(mutHour, osWaitForever);
			// Since these all relate, get all three at once before making local copies
			lhour = hour;
			lminute = minute;
			lsecond = second;
		osMutexRelease(mutHour);
		osMutexRelease(mutMinute);
		osMutexRelease(mutSecond);
		
		// convert values to ASCII characters
		hourMSD = (lhour > 9)?0x30+hour/10:0x20;  // if the hour has only one digit, print a space for the MSD
		hourLSD = 0x30 + lhour % 10;	
		minuteMSD = 0x30 + lminute/10;
		minuteLSD = 0x30 + lminute%10;
		secondMSD = 0x30 + lsecond/10;
		secondLSD = 0x30 + lsecond%10;
		
		//display time using local copies  (drawing a string repeatedly calls DrawChar, so this isn't too inefficient)
#ifdef BORING  // This was originally all that was in the lab...
		GLCD_DrawChar( (XOFFSET+0)*CHARWIDTH,YOFFSET*CHARHEIGHT, hourMSD);
		GLCD_DrawChar( (XOFFSET+1)*CHARWIDTH,YOFFSET*CHARHEIGHT, hourLSD);
		GLCD_DrawChar( (XOFFSET+2)*CHARWIDTH,YOFFSET*CHARHEIGHT, ':'    );
		GLCD_DrawChar( (XOFFSET+3)*CHARWIDTH,YOFFSET*CHARHEIGHT, minuteMSD);
		GLCD_DrawChar( (XOFFSET+4)*CHARWIDTH,YOFFSET*CHARHEIGHT, minuteLSD);
		GLCD_DrawChar( (XOFFSET+5)*CHARWIDTH,YOFFSET*CHARHEIGHT, ':');		
		GLCD_DrawChar( (XOFFSET+6)*CHARWIDTH,YOFFSET*CHARHEIGHT, secondMSD);
		GLCD_DrawChar( (XOFFSET+7)*CHARWIDTH,YOFFSET*CHARHEIGHT, secondLSD);
#else	// ... but this made my kids happy....
		if ( (x + 8*CHARWIDTH<LCDWIDTH-1) && right==1) x++;
		if ( (x > 0) && right==0) x--;
		if (x==0) right = 1;
		if (x+8*CHARWIDTH==LCDWIDTH-1) right = 0;
		if ( (y+CHARHEIGHT<LCDHEIGHT-1) && down==1) y++;
		if ( (y > 0) && down==0) y--;
		if (y==0) down = 1;
		if (y+CHARHEIGHT==LCDHEIGHT-1) down = 0;
		GLCD_DrawChar( 0*16+x,y, hourMSD);
		GLCD_DrawChar( 1*16+x,y, hourLSD);
		GLCD_DrawChar( 2*16+x,y, ':'    );
		GLCD_DrawChar( 3*16+x,y, minuteMSD);
		GLCD_DrawChar( 4*16+x,y, minuteLSD);
		GLCD_DrawChar( 5*16+x,y, ':');		
		GLCD_DrawChar( 6*16+x,y, secondMSD);
		GLCD_DrawChar( 7*16+x,y, secondLSD);
#endif
		
  }
}
