
//SHT11 io Define
#define SHT_CLK         PORTD.2   
#define SHT_DATA_IN     PIND.3    
#define SHT_DATA_OUT    PORTD.3   

#define SHT_DDR_CLK     DDRD.2  
#define SHT_DDR_DATA    DDRD.3      
         
#define DDROUT		1
#define DDRIN		0

//Button Define                           
#define SETTING     PINA.7
#define UP          PINA.6
#define DOWN        PINA.3
#define OK          PINA.5
#define MODE        PINA.2
#define CANCEL      PINA.4

#define SPEAK_PORT  PORTB
#define SPEAK_PIN   4
#define SPEAK       PORTB.4

#define true        1
#define false       0

//PWM define
#define pwm_a       OCR1A    //Dieu khien nhiet do
#define pwm_b       OCR1B    //Dieu khien do am

//#define CTRL1       PORTD.5
//#define CTRL2       PORTD.4
//65535=0xffff; 20000=0x4e20, 10000=0x2710 ;1000=0x03e8
//#define icr1        (icr1_h<<8)|icr1_l
#define icr1        10000

//Edge define
#define not_bit(port,pin)   (port.pin=~port.pin)
#define set_bit(port,pin)   (port)|= (1<<(pin))
#define clr_bit(port,pin)   (port)&=~(1<<(pin))
#define falling_edge(port, pin) do {\ 
                                set_bit(port,pin);\ 
                                delay_ms(40);\
                                clr_bit(port,pin);\
                            } while (0)                            
#define rising_edge(port, pin) do {\ 
                                clr_bit(port,pin);\  
                                set_bit(port,pin);\
                            } while (0) 

//Define kieu du lieu                            
/*    Kieu So Nguyen Co Dau    */
typedef   signed           char int8_t;
typedef   signed           int int16_t;
typedef   signed long      int int32_t;

/*    Kieu So Nguyen Khong Dau */
typedef   unsigned         char uint8_t;
typedef   unsigned         int  uint16_t;
typedef   unsigned long    int  uint32_t;
/*    Kieu So Thuc */
typedef   float            float32_t;                             

//Nap 1 lan 
//Mang luu du lieu cho CGRam LCD
flash unsigned char character_0[]={0x10,0x18,0x1c,0x1e,0x1c,0x18,0x10,0x00};

#define delay_bt    1500
// Khai bao bien su dung
unsigned char set=1,mode_temp=1,mode_humi=1; 
int int_temp[4]={0,4,0,0},int_humi[4]={0,5,0,0};
int int_temp_ok[4]={0,4,0,0},int_humi_ok[4]={0,5,0,0};
unsigned int set_temp_int, set_humi_int, set_temp_int_ok, set_humi_int_ok;
float set_temp, set_humi;
float set_temp_ok, set_humi_ok;
unsigned  int i=0,s, delay;
float nhiet_do,do_am;
bit state,dao_pwm=0;
//================================//
/***********************************
Bien Luu EEPROM
******************************/
eeprom int eep_temp_ok[4], eep_humi_ok[4];

/*********************************
PID variable
*****************************/
#define sampling_time       64   //ms
#define inv_sampling_time   6.25     //s=1/sampling_time*1000
#define pwm_period          5000
int delay_sampling;
float err, pre_err=0;
float kp=60000, kd=2000, ki=1;

//kp=30000, kd=10000, ki=1 (ss=0.2);
//kp=40000, kd=1000, ki=1(On dinh);
//kp=40000, kd=15000, ki=1 (On dinh hon, dap ung cham hon);
//kp=50000, kd=1000, ki=1; pwm_period          5000

float p_part=0, i_part=0,pre_i_part=0, d_part=0;
float output;

/*********************************
PID Humi variable
*****************************/
#define humi_sampling_time       64   //ms
#define humi_inv_sampling_time   6.25     //s=1/sampling_time*1000
#define humi_pwm_period          5000

float humi_err, humi_pre_err=0;
float humi_kp=60000, humi_kd=2000, humi_ki=1;

//kp=30000, kd=10000, ki=1 (ss=0.2);
//kp=40000, kd=1000, ki=1(On dinh);
//kp=40000, kd=15000, ki=1 (On dinh hon, dap ung cham hon);
//kp=50000, kd=1000, ki=1; pwm_period          5000

float humi_p_part=0, humi_i_part=0,humi_pre_i_part=0, humi_d_part=0;
float humi_output;
