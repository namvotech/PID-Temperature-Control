/**************************************
T2 overflow interrupt
**************************************/
interrupt [TIM2_OVF] void timer2_ovf_isr (void) 
{    
    delay_sampling++;
    if(delay_sampling>=5)
    {
        pid_temp_ctrol(nhiet_do,set_temp_ok);
        pid_humi_ctrol(do_am,set_humi_ok);
        delay_sampling=0;
    }
    s++;
    state=s>=2200?~state:state; 
    s=s>=2200?0:s; 
    delay++;       
}
