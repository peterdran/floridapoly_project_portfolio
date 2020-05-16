#ifndef __lab_5_h
#define __lab_5_h

void setup(void);
void sampleJoystick(void);
void SysTick_Handler(void);
uint32_t getAbsoluteXpos(uint32_t);
uint32_t getAbsoluteYpos(uint32_t);
bool inRowBounds(uint32_t);
bool inColBounds(uint32_t);
void draw(void);
void highlightText(void);
void LED(uint32_t);
uint32_t getChar(void);
void clearHighlight(uint32_t xPos, uint32_t yPos);

#endif
