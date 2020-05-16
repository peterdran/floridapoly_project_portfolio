#include "Board_GLCD.h"
#include "Board_LED.h"
#include "stm32f2xx_hal.h"
#include "GLCD_Config.h"
#include "JOY.h"
#include "Serial.h"
#include "lab 5.h"

extern GLCD_FONT GLCD_Font_16x24;
uint32_t fw,fh,dx,dy;
uint32_t relX = 0, relY = 0;
bool ready = false;

/**Initialize the peripherals: Already Done**/
void setup(void){
	GLCD_Initialize();
	LED_Initialize();
	JOY_Init();
	SER_Init(115200);
	GLCD_SetFont(&GLCD_Font_16x24);
	GLCD_SetBackgroundColor(GLCD_COLOR_PURPLE);
	fw = GLCD_Font_16x24.width;// font width
	fh = GLCD_Font_16x24.height; //font height
	//minimum x position on the screen. Corresponds to column 0
	dx = (GLCD_WIDTH - 16 * fw)>>1;
	//minimum y position on the screen. Corresponds to row 0
	dy = (GLCD_HEIGHT - 6 * fh)>>1;
	//use to prevent Joy stick sampling when the joy stick has not be initialized
	draw();
	ready = true;
}


void sampleJoystick(void){
	if(!ready)	
		return;//initialization has not completed, abort
	bool activeJoy = true;
	uint32_t key = JOY_GetKeys();
	clearHighlight(relX, relY);
	switch(key) //act based on the direction
	{
		case JOY_LEFT:
			relX = inColBounds(relX - 1) ? relX - 1 : relX;
			break;
		case JOY_RIGHT:
			relX = inColBounds(relX + 1) ? relX + 1 : relX;
			break;
		case JOY_UP:
			relY = inRowBounds(relY - 1) ? relY - 1 : relY;
			break;
		case JOY_DOWN:
			relY = inRowBounds(relY + 1) ? relY + 1 : relY;
			break;
		default:
			activeJoy = false;
			break;
	}
	if(!activeJoy)
		highlightText();
	else
		LED(getChar());
	return;
}

/*SysTick ISR*/
void SysTick_Handler(void)
{
	//increment HAL tick variable; this is required for LCD Display Config.
	HAL_IncTick();
	//check for joy stick movement to configure Joystick Sampling
	sampleJoystick();
	return;
}

uint32_t getAbsoluteXpos(uint32_t colMult)
{
	return dx + (colMult * fw);
}

uint32_t getAbsoluteYpos(uint32_t rowMult)
{
	return dy + (rowMult * fh);
}

bool inRowBounds(uint32_t row)
{
	return row < 6; //a negative row/col is impossible due to their values being unsigned
}

bool inColBounds(uint32_t col)
{
	return col < 16;
}

/**Draw ascii characters on the screen**/
void draw(void)
{ 
	GLCD_ClearScreen();
	GLCD_SetBackgroundColor(GLCD_COLOR_MAGENTA);
	GLCD_SetForegroundColor(GLCD_COLOR_WHITE);
	uint32_t charIndex = 0x20;
	uint32_t rowCount, columnCount;
	
	for(rowCount = 0; rowCount < 6; rowCount++)
	{
		for(columnCount = 0; columnCount < 16; columnCount++)
		{
			GLCD_DrawChar(getAbsoluteXpos(columnCount), getAbsoluteYpos(rowCount), charIndex);
			charIndex++;
		}
	}
	return;
}



/**Highlight the character c in the 16x6 grid **/
void highlightText(void)
{
	GLCD_SetForegroundColor(GLCD_COLOR_GREEN);
	GLCD_DrawRectangle(getAbsoluteXpos(relX),getAbsoluteYpos(relY),16,24);
	return;
}


/**Toggle the LED based on the bits of the character c.
1 LED will be turned on
0 LED will be turned off **/

void LED(uint32_t c)
{
	//bit mirror
	//Devised by Sean Anderson, July 13, 2001
	//http://graphics.stanford.edu/~seander/bithacks.html#ReverseByteWith32Bits
	c = 0xFF & (((c * 0x0802LU & 0x22110LU) | (c * 0x8020LU & 0x88440LU)) * 0x10101LU >> 16); //ASCII is 7 bits wide
	
	LED_SetOut(c);
	return;
}

uint32_t getChar(void)
{
	return 0x20 + ((relY<<4) + relX);
}

void clearHighlight(uint32_t xPos, uint32_t yPos)
{
	GLCD_SetForegroundColor(GLCD_COLOR_MAGENTA);
	GLCD_DrawRectangle(getAbsoluteXpos(xPos),getAbsoluteYpos(yPos),16,24);
	return;
}


int main(void)
{
	SystemCoreClockUpdate();
	HAL_Init();
	SysTick_Config(SystemCoreClock/1000);
	
	setup();
	SysTick_Config(SystemCoreClock/6);
	highlightText();
	LED(getChar());
	
	while(1);
}

