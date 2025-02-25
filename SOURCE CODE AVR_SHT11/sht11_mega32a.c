/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : DO NHIET DO VA DO AM SHT11
Version : 2
Date    : 12/6/2014
Author  : Minh Nam
Company : ---
Comments: 


Chip type               : ATmega32A
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/
#include <mega32a.h>
#include <delay.h>
#include <math.h>
// Alphanumeric LCD Module functions
#include <alcd.h>

#include <declare.c>
#include <sub_programs.c>
#include <sub_interrupt.c>
#include <sub_sht11.c>
// Declare your global variables here
void main(void)
{
// Input/Output Ports initialization
// Port A initialization
PORTA=0xFC;
DDRA=0x00;

// Port B initialization
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
PORTD=0x00;
DDRD=0xF2;

// Timer/Counter 0 initialization
TCCR0=0;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
TCCR1A=(1<<COM1A1)|(1<<COM1B1)|(1<<WGM11);
TCCR1B=(1<<WGM13)|(1<<WGM12)|(1<<CS11);
//TCCR1A=0;
//TCCR1B=0;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1=pwm_period;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
ASSR=0x00;
TCCR2|=(1<<CS21);
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK|=(1<<TOIE2);

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTB Bit 7
// RD - PORTB Bit 6
// EN - PORTB Bit 5
// D4 - PORTB Bit 3
// D5 - PORTB Bit 2
// D6 - PORTB Bit 1
// D7 - PORTB Bit 0
// Characters/line: 20
lcd_init(20);
lcd_clear();

lcd_gotoxy(3,0);
lcd_puts("Do An Mon Hoc");
//lcd_gotoxy(1,1);
//lcd_puts("Nguyen Thuy Duong");
//lcd_gotoxy(1,2);
//lcd_puts("Phuong Vo");
lcd_gotoxy(0,1);
lcd_puts("Thuy Duong 12141041");
lcd_gotoxy(0,2);
lcd_puts("Phuong Vo  12141174");
lcd_gotoxy(0,3);
lcd_puts("Dang Khoi Tao SHT...");
SHT_Init(SHT_12_8_BIT);
delay_ms(2000);


//Subroutine call recording CGRAM character on the LCD
define_char(character_0,0x00);

for(i=0;i<=3;i++)
{         
    int_temp_ok[i]=eep_temp_ok[i];
    int_humi_ok[i]=eep_humi_ok[i];
    int_temp[i]=int_temp_ok[i];
    int_humi[i]=int_humi_ok[i];
}
SHT_ReadTemHumi(&nhiet_do,&do_am); 
         
while (1)
{
    // Place your code here 
    //Phim cai dat 
    //set=1:run, set=2:set_temp, set=3:set_humi,
    if(SETTING==0)
    {   
        while(SETTING==0); 
        falling_edge(SPEAK_PORT,SPEAK_PIN);
        set++;
        set=set>3?2:set;                                              
    } 
        //Set temp
    if(set==2)
    {     
        if(MODE==0)
        {   
            while(MODE==0); 
            falling_edge(SPEAK_PORT,SPEAK_PIN);            
            mode_temp++;
            mode_temp=mode_temp>4?1:mode_temp;                                              
        }     
        if (mode_temp==1)
        {    
            if(UP==0)
            {   
                while(UP==0); 
                if(delay>=delay_bt) 
                {
                delay=0;
                falling_edge(SPEAK_PORT,SPEAK_PIN);
                int_temp[0]++;
                int_temp[0]=int_temp[0]>1?0:int_temp[0];  
                lcd_gotoxy(3,3);     
                lcd_putchar(int_temp[0]+48);
                } 
            } 
            if(DOWN==0)
            {   
                while(DOWN==0); 
                if(delay>=delay_bt) 
                {
                delay=0;
                falling_edge(SPEAK_PORT,SPEAK_PIN);
                int_temp[0]--;
                int_temp[0]=int_temp[0]<0?1:int_temp[0];  
                lcd_gotoxy(3,3);     
                lcd_putchar(int_temp[0]+48); 
                }
            }             
        }        
        if(!int_temp[0])
        {
            if (mode_temp==2)
            {           
                if(UP==0)
                {   
                    while(UP==0)
                    {   
                        if(delay>=delay_bt) 
                        {
                        delay=0;
                        int_temp[1]++;
                        int_temp[1]=int_temp[1]>9?0:int_temp[1];  
                        lcd_gotoxy(4,3);     
                        lcd_putchar(int_temp[1]+48);
                        }
                    }
                    falling_edge(SPEAK_PORT,SPEAK_PIN);                                                
                } 
                if(DOWN==0)
                {   
                    while(DOWN==0)
                    {   
                        if(delay>=delay_bt) 
                        {
                        delay=0;
                        int_temp[1]--;
                        int_temp[1]=int_temp[1]<0?9:int_temp[1];  
                        lcd_gotoxy(4,3);     
                        lcd_putchar(int_temp[1]+48);  
                        }
                    }
                    falling_edge(SPEAK_PORT,SPEAK_PIN);                                                
                }                              
            } 
            if (mode_temp==3)
            {
                if(UP==0)
                {   
                    while(UP==0)
                    {    
                        if(delay>=delay_bt) 
                        {
                        delay=0;
                        int_temp[2]++;
                        int_temp[2]=int_temp[2]>9?0:int_temp[2];  
                        lcd_gotoxy(5,3);     
                        lcd_putchar(int_temp[2]+48);
                        }
                    } 
                    falling_edge(SPEAK_PORT,SPEAK_PIN);                                               
                } 
                if(DOWN==0)
                {   
                    while(DOWN==0)
                    {  
                        if(delay>=delay_bt) 
                        {
                        delay=0;
                        int_temp[2]--;
                        int_temp[2]=int_temp[2]<0?9:int_temp[2];  
                        lcd_gotoxy(5,3);     
                        lcd_putchar(int_temp[2]+48);
                        }
                    }
                    falling_edge(SPEAK_PORT,SPEAK_PIN);                                                
                }                                            
            } 
            if (mode_temp==4)
            {
                if(UP==0)
                {   
                    while(UP==0)
                    {    
                        if(delay>=delay_bt) 
                        {
                        delay=0;
                        int_temp[3]++;
                        int_temp[3]=int_temp[3]>9?0:int_temp[3];  
                        lcd_gotoxy(7,3);     
                        lcd_putchar(int_temp[3]+48);
                        }
                    }
                    falling_edge(SPEAK_PORT,SPEAK_PIN);                                                
                } 
                if(DOWN==0)
                {   
                    while(DOWN==0)
                    {    
                        if(delay>=delay_bt) 
                        {
                        delay=0;
                        int_temp[3]--;
                        int_temp[3]=int_temp[3]<0?9:int_temp[3];  
                        lcd_gotoxy(7,3);     
                        lcd_putchar(int_temp[3]+48);
                        } 
                    }
                    falling_edge(SPEAK_PORT,SPEAK_PIN);                                                
                }                              
            } 
        }
        else
        {    
            if (mode_temp==2)
            {    
                if(UP==0)
                {   
                    while(UP==0);
                    if(delay>=delay_bt) 
                    {
                    delay=0;
                    falling_edge(SPEAK_PORT,SPEAK_PIN);
                    int_temp[1]++;
                    int_temp[1]=int_temp[1]>2?0:int_temp[1];  
                    lcd_gotoxy(4,3);     
                    lcd_putchar(int_temp[1]+48); 
                    }
                    
                } 
                if(DOWN==0)
                {   
                    while(DOWN==0);
                    if(delay>=delay_bt) 
                    {
                    delay=0;
                    falling_edge(SPEAK_PORT,SPEAK_PIN);
                    int_temp[1]--;
                    int_temp[1]=int_temp[1]<0?2:int_temp[1];  
                    lcd_gotoxy(4,3);     
                    lcd_putchar(int_temp[1]+48); 
                    }
                    
                }                                                                                         
            } 
            int_temp[1]=int_temp[1]>2?2:int_temp[1]; 
            
            if (int_temp[1]>=2)
            {
                int_temp[2]=0;
                int_temp[3]=0; 
                mode_temp=mode_temp>2?1:mode_temp;            
            }
            else
            {
                if (mode_temp==3)
                {
                    if(UP==0)
                    {   
                        while(UP==0)
                        {    
                            if(delay>=delay_bt) 
                            {
                            delay=0;
                            int_temp[2]++;
                            int_temp[2]=int_temp[2]>9?0:int_temp[2];  
                            lcd_gotoxy(5,3);     
                            lcd_putchar(int_temp[2]+48);
                            }
                             
                        }
                        falling_edge(SPEAK_PORT,SPEAK_PIN);                                                
                    } 
                    if(DOWN==0)
                    {   
                        while(DOWN==0)
                        {    
                            if(delay>=delay_bt) 
                            {
                            delay=0;
                            int_temp[2]--;
                            int_temp[2]=int_temp[2]<0?9:int_temp[2];  
                            lcd_gotoxy(5,3);     
                            lcd_putchar(int_temp[2]+48);
                            } 
                        }
                        falling_edge(SPEAK_PORT,SPEAK_PIN);                                                
                    }                                  
                } 
                if (mode_temp==4)
                {
                    if(UP==0)
                    {   
                        while(UP==0)
                        {    
                            if(delay>=delay_bt) 
                            {
                            delay=0;
                            int_temp[3]++;
                            int_temp[3]=int_temp[3]>9?0:int_temp[3];  
                            lcd_gotoxy(7,3);     
                            lcd_putchar(int_temp[3]+48);
                            }
                            
                        }
                        falling_edge(SPEAK_PORT,SPEAK_PIN);                                                
                    } 
                    if(DOWN==0)
                    {   
                        while(DOWN==0)
                        {   
                            if(delay>=delay_bt) 
                            {
                            delay=0;
                            int_temp[3]--;
                            int_temp[3]=int_temp[3]<0?9:int_temp[3];  
                            lcd_gotoxy(7,3);     
                            lcd_putchar(int_temp[3]+48); 
                            }
                        }
                        falling_edge(SPEAK_PORT,SPEAK_PIN);                                                
                    }                                  
                }            
            }    
        }                                                    
    }   
    //Set humi
    if (set==3)
    {   
        if(MODE==0)
        {   
            while(MODE==0); 
            falling_edge(SPEAK_PORT,SPEAK_PIN);
            mode_humi++;
            mode_humi=mode_humi>4?1:mode_humi;                                              
        }     
        
        if (mode_humi==1)
        {
            if(UP==0)
            {   
                while(UP==0); 
                if(delay>=delay_bt) 
                {
                delay==0;
                falling_edge(SPEAK_PORT,SPEAK_PIN);
                int_humi[0]++;
                int_humi[0]=int_humi[0]>1?0:int_humi[0];  
                lcd_gotoxy(14,3);     
                lcd_putchar(int_humi[0]+48);  
                }                                               
            }
             
            if(DOWN==0)
            {   
                while(DOWN==0); 
                if(delay>=delay_bt) 
                {
                delay=0;
                falling_edge(SPEAK_PORT,SPEAK_PIN);
                int_humi[0]--;
                int_humi[0]=int_humi[0]<0?1:int_humi[0];  
                lcd_gotoxy(14,3);     
                lcd_putchar(int_humi[0]+48); 
                }
            }             
        }

        if (!int_humi[0]) 
        {
            if (mode_humi==2)
            {
                if(UP==0)
                {   
                    while(UP==0)
                    {   
                        if(delay>=delay_bt) 
                        {
                        delay=0;
                        int_humi[1]++;
                        int_humi[1]=int_humi[1]>9?0:int_humi[1];  
                        lcd_gotoxy(15,3);     
                        lcd_putchar(int_humi[1]+48);
                        } 
                    }
                    falling_edge(SPEAK_PORT,SPEAK_PIN);                                                
                } 
                if(DOWN==0)
                {   
                    while(DOWN==0)
                    {   
                        if(delay>=delay_bt) 
                        {
                        delay=0;
                        int_humi[1]--;
                        int_humi[1]=int_humi[1]<0?9:int_humi[1];  
                        lcd_gotoxy(15,3);     
                        lcd_putchar(int_humi[1]+48); 
                        }
                    }
                    falling_edge(SPEAK_PORT,SPEAK_PIN);                                                
                }                               
            } 
            if (mode_humi==3)
            {
                if(UP==0)
                {   
                    while(UP==0)
                    {   
                        if(delay>=delay_bt) 
                        {
                        delay=0;
                        int_humi[2]++;
                        int_humi[2]=int_humi[2]>9?0:int_humi[2];  
                        lcd_gotoxy(16,3);     
                        lcd_putchar(int_humi[2]+48);
                        } 
                    } 
                    falling_edge(SPEAK_PORT,SPEAK_PIN);                                               
                } 
                if(DOWN==0)
                {   
                    while(DOWN==0)
                    {  
                        if(delay>=delay_bt) 
                        {
                        delay=0;
                        int_humi[2]--;
                        int_humi[2]=int_humi[2]<0?9:int_humi[2];  
                        lcd_gotoxy(16,3);     
                        lcd_putchar(int_humi[2]+48); 
                        }
                    } 
                    falling_edge(SPEAK_PORT,SPEAK_PIN);                                               
                }                              
            } 
            if (mode_humi==4)
            {
                if(UP==0)
                {   
                    while(UP==0)
                    {   
                        if(delay>=delay_bt) 
                        {
                        delay=0;
                        int_humi[3]++;
                        int_humi[3]=int_humi[3]>9?0:int_humi[3];  
                        lcd_gotoxy(18,3);     
                        lcd_putchar(int_humi[3]+48);
                        }
                    } 
                    falling_edge(SPEAK_PORT,SPEAK_PIN);                                               
                } 
                if(DOWN==0)
                {   
                    while(DOWN==0)
                    {   
                        if(delay>=delay_bt) 
                        {
                        delay=0;
                        int_humi[3]--;
                        int_humi[3]=int_humi[3]<0?9:int_humi[3];  
                        lcd_gotoxy(18,3);     
                        lcd_putchar(int_humi[3]+48); 
                        }
                    } 
                    falling_edge(SPEAK_PORT,SPEAK_PIN);                                               
                }                              
            }             
            
        }
        else
        {    
            int_humi[1]=0;
            int_humi[2]=0;
            int_humi[3]=0;
            mode_humi=1;   
        }                                   
    }  
                                                                        
    //Ok chap nhan gia tri, CANCEL huy cai dat nhiet do va do am
    if(set!=1)
    {
        if(OK==0)
        {   
            while(OK==0); 
            falling_edge(SPEAK_PORT,SPEAK_PIN);
            
            int_temp_ok[0]=int_temp[0]; 
            int_temp_ok[1]=int_temp[1];
            int_temp_ok[2]=int_temp[2];
            int_temp_ok[3]=int_temp[3]; 
            
            int_humi_ok[0]=int_humi[0]; 
            int_humi_ok[1]=int_humi[1];
            int_humi_ok[2]=int_humi[2];
            int_humi_ok[3]=int_humi[3]; 
                        
            //Save to EEPROM
            eep_temp_ok[0]=int_temp_ok[0];
            eep_temp_ok[1]=int_temp_ok[1];
            eep_temp_ok[2]=int_temp_ok[2];
            eep_temp_ok[3]=int_temp_ok[3];  
            
            eep_humi_ok[0]=int_humi_ok[0];
            eep_humi_ok[1]=int_humi_ok[1];
            eep_humi_ok[2]=int_humi_ok[2];
            eep_humi_ok[3]=int_humi_ok[3];
             
                      
            set=1;
            mode_temp=1;
            mode_humi=1;
            //lcd_clear();                                 
        }
    
        if (CANCEL==0)
        {   
            while(CANCEL==0); 
            falling_edge(SPEAK_PORT,SPEAK_PIN);
                
            int_temp[0]=int_temp_ok[0]; 
            int_temp[1]=int_temp_ok[1];
            int_temp[2]=int_temp_ok[2];
            int_temp[3]=int_temp_ok[3];
                
            int_humi[0]=int_humi_ok[0]; 
            int_humi[1]=int_humi_ok[1];
            int_humi[2]=int_humi_ok[2];
            int_humi[3]=int_humi_ok[3];            
            set=1;
            mode_temp=1; 
            mode_humi=1; 
            //lcd_clear();                               
        }
    }
    else
    {
        if (CANCEL==0)
        {   
            while(CANCEL==0); 
            falling_edge(SPEAK_PORT,SPEAK_PIN);            
            set=1;
            mode_temp=1; 
            mode_humi=1;
            dao_pwm=~dao_pwm;            
            //lcd_clear();                               
        }    
    }
         
    
    #asm ("cli")
    delay_ms(10); 
    if(set==1)      SHT_ReadTemHumi(&nhiet_do,&do_am);          
    #asm ("sei") 

    if(dao_pwm==0)
    {
        TCCR1A=(1<<COM1A1)|(1<<COM1B1)|(1<<WGM11);
        TCCR1B=(1<<WGM13)|(1<<WGM12)|(1<<CS11); 
        lcd_gotoxy(0,2);
        lcd_puts("           Ctrl: On ");       
    }
    else
    {
        TCCR1A=0;
        TCCR1B=0; 
        lcd_gotoxy(0,2);
        lcd_puts("           Ctrl: Off");           
    }
         
    //Hien Thi Nhiet Do
    lcd_gotoxy(0,0);
    lcd_puts("Temp:"); 
    lcd_display_sensor(nhiet_do); 
    lcd_putchar(0x20);            
    lcd_putchar(0xdf);
    lcd_puts("C      ");    
              
    //Hien thi Do Am                
    lcd_gotoxy(0,1);
    lcd_puts("Humi:");
    lcd_display_sensor(do_am);             
    lcd_puts(" %       ");
    
//    lcd_gotoxy(0,2);
//    lcd_puts("                    "); 
                            
    //Luu gia tri set nhiet do va set do am
    set_temp_int= (int_temp[0]*1000 + int_temp[1]*100 + int_temp[2]*10 + int_temp[3]) ;
    set_humi_int= (int_humi[0]*1000 + int_humi[1]*100 + int_humi[2]*10 + int_humi[3]);
    set_temp_int_ok= (int_temp_ok[0]*1000 + int_temp_ok[1]*100 + int_temp_ok[2]*10 + int_temp_ok[3]) ;
    set_humi_int_ok= (int_humi_ok[0]*1000 + int_humi_ok[1]*100 + int_humi_ok[2]*10 + int_humi_ok[3]);
            
    set_temp = (float) set_temp_int/(float)10;
    set_humi = (float) set_humi_int/(float)10;
    set_temp_ok = (float) set_temp_int_ok/(float)10;
    set_humi_ok = (float) set_humi_int_ok/(float)10;  
               
//    set_temp= (float)(int_temp[0]*1000 + int_temp[1]*100 + int_temp[2]*10 + int_temp[3])/((float)10);
//    set_humi= (float)(int_humi[0]*1000 + int_humi[1]*100 + int_humi[2]*10 + int_humi[3])/((float)10); 
//
//    set_temp_ok= (float)(int_temp_ok[0]*1000 + int_temp_ok[1]*100 + int_temp_ok[2]*10 + int_temp_ok[3])/((float)10);
//    set_humi_ok= (float)(int_humi_ok[0]*1000 + int_humi_ok[1]*100 + int_humi_ok[2]*10 + int_humi_ok[3])/((float)10); 

   // Hien thi Set Temp
    lcd_gotoxy(0,3);  
    lcd_putsf("ST"); 
    if(set==2)  lcd_putchar(0x00);
    else        lcd_putchar('>'); 
     
    if(set==1)  lcd_display_set(set_temp_int_ok); 
    else  lcd_display_set(set_temp_int); 
    lcd_gotoxy(8,3);   
    lcd_putchar(0xdf);
    lcd_putsf("C ");    
          
    //Hien thi Set Humi
    lcd_puts("SH");
    if(set==3)  lcd_putchar(0x00);     
    else        lcd_putchar('>');  
    
    if(set==1)  lcd_display_set(set_humi_int_ok); 
    else     lcd_display_set(set_humi_int); 
    lcd_gotoxy(19,3);    
    lcd_putchar('%'); 
    
//    lcd_gotoxy(0,2);    
//    lcd_display_pwm(pwm_a); 
           
    //Flashing for Set_Temp
    //vi tri con tro: 3.4.5.7 hang 3 //
    if (set==2)
    { 
        if(mode_temp==1)
        {  
            if(!state) 
            {   
                lcd_gotoxy(3,3);
                lcd_putchar(0x20);
            }
        }
        if(mode_temp==2)
        {
            if(!state) 
            {   
                lcd_gotoxy(4,3);
                lcd_putchar(0x20);
            }         
        }
        if(mode_temp==3)
        {
            if(!state) 
            {   
                lcd_gotoxy(5,3);
                lcd_putchar(0x20);
            }         
        }            
        if(mode_temp==4)
        {
            if(!state) 
            {   
                lcd_gotoxy(7,3);
                lcd_putchar(0x20);
            }         
        }            
    }                   
    //Flashing for Set_Humi
    //vi tri con tro: 14.15.16.18 hang 3
    if(set==3)
    {
        if(mode_humi==1)
            if(!state) 
            {   
                lcd_gotoxy(14,3);
                lcd_putchar(0x20);
            }
        if(mode_humi==2)
            if(!state) 
            {   
                lcd_gotoxy(15,3);
                lcd_putchar(0x20);
            }
        if(mode_humi==3)
            if(!state) 
            {   
                lcd_gotoxy(16,3);
                lcd_putchar(0x20);
            }
        if(mode_humi==4)
            if(!state) 
            {   
                lcd_gotoxy(18,3);
                lcd_putchar(0x20);
            }                                                                             
    }                                              
}
}
