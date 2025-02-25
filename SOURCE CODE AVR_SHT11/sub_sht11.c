//Library source code for SHT11
//===========================
//SHT11 const  define
#define SHT_NOACK           0
#define SHT_ACK             1
#define SHT_STATUS_REG_W    0x06   //0000 0110
#define SHT_STATUS_REG_R    0x07   //0000 0111
#define SHT_MEASURE_TEMP    0x03   //0000 0011
#define SHT_MEASURE_HUMI    0x05   //0000 0101
#define SHT_RESET           0x1E   //0001 1110
#define SHT_14_12_BIT       0x00
#define SHT_12_8_BIT        0x01
//Cac hang so voi do phan giai 14 va 12 bit
#define H_C1    -4.0            
#define H_C2    0.0405
#define H_C3    -0.0000028
#define H_D1    -40.00      //(vcc=5v)
//#define H_D1    -39.75        //(vcc=4v)
#define H_D2    0.01
#define H_T1    0.01            
#define H_T2    0.00008
//Cac hang so voi do phan giai 12 va 8 bit
#define L_C1    -4.0          
#define L_C2    0.648
#define L_C3    -0.00072
#define L_D1    -40.00      
#define L_D2    0.04
#define L_T1    0.01            
#define L_T2    0.00128

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
///////////////////////////////////////////////
while(SHT_DATA_IN){#asm ("sei")};
#asm ("cli")
delay_ms(10);
//////////////////////////////////////////////
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
//===========================


