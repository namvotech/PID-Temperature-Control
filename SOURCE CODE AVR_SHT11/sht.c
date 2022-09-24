/**
  ******************************************************************************
  * Ten Tep      :        sht.c
  * Tom Tat      :        Dinh nghia cac ham dieu khien sht.
  ******************************************************************************
  * Chu Y        :   Phai dinh nghia cac chan su dung cho sht vao file main.h
  *                Vi Du:
                                PIC       AVR       8051
#define         SHT_DATA_IN     PINB0     PINB.0    P2_0
#define         SHT_DATA_OUT    PORTB0    PORTB.0   P2_0
#define         SHT_CLK         PORTB1    PORTB.1   P2_1
               Voi PIC va AVR can dinh nghia them huong du lieu.
                                PIC       AVR       8051
#define         SHT_DDR_DATA    DDRB0     DDRB.0    P2_0    
#define         SHT_DDR_CLK     DDRB1     DDRB.1    P2_1                
  ******************************************************************************
**/

/*********************************** VI DU ************************************
    float nhiet_do,do_am;
    SHT_Init(SHT_14_12_BIT);
    SHT_ReadTemHumi(&nhiet_do,&do_am);
*******************************************************************************/
//================================
static uint8_t SHT_Resolution;
 /*******************************************************************************
Noi Dung    :   Bat dau mot ket noi moi.
Tham Bien   :   Khong.
Tra Ve      :   Khong.
********************************************************************************/
void SHT_Start()
{
SHT_DDR_CLK  = DDROUT;  // SHT la chan ra
SHT_DDR_DATA = DDROUT; // Data la chan ra
SHT_DATA_OUT = 1;
SHT_CLK = 0;
SHT_CLK = 1;
SHT_DATA_OUT = 0;
SHT_CLK = 0;
SHT_CLK = 1;
SHT_DATA_OUT = 1;
SHT_CLK = 0;
}
 /*******************************************************************************
Noi Dung    :   Reset ket noi moi.
Tham Bien   :   Khong.
Tra Ve      :   Khong.
********************************************************************************/
void SHT_ResetConection()
{ 
   uint8_t i;
   SHT_DDR_DATA = DDROUT;  //Data la chan ra
   SHT_DATA_OUT=1;
   for (i=0; i<9; i++)
       {
      SHT_CLK=1;
      SHT_CLK=0;
       }
   SHT_Start();
}
 /*******************************************************************************
Noi Dung    :   Gui 1 Byte du lieu len SHT.
Tham Bien   :   Data:  Byte du lieu can viet.
Tra Ve      :   1:     Neu viet Byte xay ra loi.
                0:     Neu viet Byte thanh cong.
********************************************************************************/
uint8_t SHT_WriteByte(uint8_t Data)
{
uint8_t i, error = 0;
SHT_DDR_DATA = DDROUT;                // Data la chan ra
delay_us(2);
for(i = 0x80; i > 0; i /= 2)
   {
   SHT_CLK = 0;
   if(i & Data)   SHT_DATA_OUT = 1;
   else            SHT_DATA_OUT = 0;    
   delay_us(1);
   SHT_CLK = 1;
   delay_us(1);
   }
   SHT_CLK = 0;
   SHT_DDR_DATA = DDRIN;            // Data la chan vao
   delay_us(1);
   SHT_CLK = 1;        
   delay_us(1);
   error = SHT_DATA_IN;
   SHT_CLK = 0;
   delay_ms(250);
return(error);
}
 /*******************************************************************************
Noi Dung    :   Doc 1 Byte du lieu tu SHT.
Tham Bien   :   ack:   Gia tri ACK 0,1.
Tra Ve      :   Khong.
********************************************************************************/
uint8_t SHT_ReadByte(uint8_t ack)
{
uint8_t i, val = 0;
SHT_DDR_DATA = DDRIN;               // Data la chan vao
for(i = 0x80; i > 0; i /= 2)
{
   SHT_CLK = 1;     
   delay_us(1);
   if(SHT_DATA_IN)   val = val | i;  
   delay_us(1);
   SHT_CLK = 0;
}
SHT_DDR_DATA = DDROUT;                // Data la chan ra
delay_us(1);
SHT_DATA_OUT = ! ack;
SHT_CLK = 1;
delay_us(1);
SHT_CLK = 0;
return(val);
}
 /*******************************************************************************
Noi Dung    :   Khoi tao SHT.
Tham Bien   :   resolution: gia tri do phan giai.
                - SHT_14_12_BIT
                - SHT_12_8_BIT
Tra Ve      :   Khong.
********************************************************************************/
void SHT_Init(uint8_t resolution)
{
 SHT_ResetConection();
 SHT_WriteByte(SHT_STATUS_REG_W);
 delay_ms(300);
 SHT_WriteByte(resolution);
 SHT_Resolution=resolution;
}
 /*******************************************************************************
Noi Dung    :   Reset SHT.
Tham Bien   :   Khong.
Tra Ve      :   Khong.
********************************************************************************/
void SHT_ResetChip()
{
SHT_ResetConection();
SHT_WriteByte(SHT_RESET);
delay_ms(100);
}
 /*******************************************************************************
Noi Dung    :   Doc 16 bit du lieu tu SHT.
Tham Bien   :   Command:   Ma lenh yeu cau.
Tra Ve      :   16 bit du lieu.
********************************************************************************/
uint16_t SHT_ReadSenSor(uint8_t Command)
{
uint8_t msb, lsb, crc;
SHT_ResetConection();
SHT_WriteByte(Command);
while(SHT_DATA_IN);
msb = SHT_ReadByte(SHT_ACK);
lsb = SHT_ReadByte(SHT_ACK);
crc = SHT_ReadByte(SHT_NOACK);
return(((uint16_t) msb << 8) | (uint16_t) lsb);
}
 /*******************************************************************************
Noi Dung    :   Doc  gia tri nhiet do,do am tu SHT.
Tham Bien   :   *tem: con tro luu tru du lieu nhiet do.
                *humi: con tro luu tru du lieu do am.
Tra Ve      :   Khong.
********************************************************************************/
void SHT_ReadTemHumi(float *tem, float *humi)
{
   uint16_t SOT;
   uint16_t SORH;
   SOT=SHT_ReadSenSor(SHT_MEASURE_TEMP);
   SORH=SHT_ReadSenSor(SHT_MEASURE_HUMI);
   if(SHT_Resolution==SHT_14_12_BIT)
   {
    *tem=(H_D1+H_D2*SOT);
    *humi=((H_D1+H_D2*SOT-25)*(H_T1+H_T2*SORH)+H_C1+H_C2*SORH+H_C3*SORH*SORH);
   }
   else
   {
   *tem=(L_D1+L_D2*SOT);
   *humi=((L_D1+L_D2*SOT-25)*(L_T1+L_T2*SORH)+L_C1+L_C2*SORH+L_C3*SORH*SORH);
   }
}
/******************************KET THUC FILE*****************************

