#include <system.h>

//Screen Size
static void move_cursor();
static void scroll();
unsigned int Screen_Width=80;
unsigned int Screen_Height=25;
//Cursor Location
int Cursor_X=0, Cursor_Y=0;
//Video Memory Array
unsigned short *vidmem = (unsigned short *)0xB8000;
//Text and background colours
int attributeByte = 0x0F;
/*
Value	Color
0		BLACK
1		BLUE
2		GREEN
3		CYAN
4		RED
5		MAGENTA
6		BROWN
7		LIGHT GREY
8		DARK  GREY
9		LIGHT BLUE
10		LIGHT GREEN
11		LIGHT CYAN
12		LIGHT RED
13		LIGHT MAGENTA
14		LIGHT BROWN
15		WHITE
*/


////////////////
//----Body----//
////////////////

//Clear Screen
void cls()
{
	unsigned short blank = 0x20 | (attributeByte << 8);

	int i;
	for (i=0;i<25;i++)
	{
		memsetw(vidmem+i*80, blank, 80);
	}
	Cursor_X=0;
	Cursor_Y=0;
	move_cursor();
};

//Print string to screen
void Print(char *c)
{
	int i;
	for(i=0; i<strlen(c); i++) {Write_Char(c[i]);}
}

void PrintLn(char *c)
{
	int i=0;
	while(c[i])
	{
		Write_Char(c[i++]);
	}
	Write_Char('\n');
}

//Write character to screen
void Write_Char(char c)
{
	unsigned short attribute = attributeByte << 8;
	unsigned short *location;

	//Backspace
	if (c==0x08 && Cursor_X) {
		if (Cursor_X !=0) {
			Cursor_X--;
			location=vidmem+(Cursor_Y*80+Cursor_X);
			*location=' ' | attribute;
		}
	}
	//Tab
	else if (c==0x09) {Cursor_X=(Cursor_X+8) & ~(8-1);}
	//Arrows
	else if (c==0x4B) {Cursor_X--;}
	else if (c==0x48) {Cursor_Y--;}
	else if (c==0x50) {Cursor_Y++;}
	else if (c==0x4D) {Cursor_X++;}
	//Carriage Return
	else if (c=='\r') {Cursor_X=0;}
	// New line on \n
	else if (c=='\n') {Cursor_X=0; Cursor_Y++;}
	//Any non-special character
	else if (c>=' ')  {
		location=vidmem+(Cursor_Y*80+Cursor_X);
		*location=c | attribute;
		Cursor_X++;
	}
	//Check if reached end of screen
	if (Cursor_X>=80) {Cursor_X=0; Cursor_Y++;}
	//Scroll screen if needed
	scroll();
	//Move the cursor
	move_cursor();
}

//Updates hardware(underscore) cursor to Cursor_X and Cursor_Y
static void move_cursor()
{
	unsigned short cursorLoc = (Cursor_Y*Screen_Width+Cursor_X);
	outportb(0x3D4, 14); //High cursor byte
	outportb(0x3D5, cursorLoc >> 8); //Send high byte
	outportb(0x3D4, 15); //Low cursor byte
	outportb(0x3D5, cursorLoc); //Send low byte
}

//Scroll the screen down one
static void scroll()
{
	unsigned short blank = 0x20 | (attributeByte << 8);
	unsigned temp;

	if(Cursor_Y >= 25)
	{
		temp=Cursor_Y-25+1;
		memcpyw(vidmem, vidmem+temp*80, (25-temp)*80*2);
		memsetw(vidmem+(25-temp)*80, blank, 80);
		Cursor_Y=25-1;
	}
}

//Set text and background colour
void settextcolor(unsigned char forecolor, unsigned char backcolor)
{
    attributeByte = (backcolor << 4) | (forecolor & 0x0F);
}
