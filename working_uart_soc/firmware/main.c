#include <stdint.h>
#include <stdlib.h>
#include <gpio_regs.h>
#include <uart_regs.h>

void uart_send_char(uint8_t my_char)
{
    while (UCSR->U_TX_STAT_bf.READY == 0)
        ;
    UCSR->U_TX_DATA = my_char;
    UCSR->U_TX_CTRL_bf.TX_START = 1;
}

void uart_send_str(uint8_t *my_str)
{

    for (uint8_t i = 0; my_str[i] != '\0'; i++)
    {
        uart_send_char(my_str[i]);
    }
}


uint8_t uart_receive_char()
{


    while (UCSR->U_RX_STAT_bf.RX_VALID == 0)
        ;
    


    return UCSR->U_RX_DATA;


}


void uart_receive_str(uint8_t *buf)
{
    uint8_t i = 0;

    while (i < 31)
    {
        uint8_t c = uart_receive_char();

        if (c == '\r' || c == '\n')
            break;

        buf[i++] = c;
    }

    buf[i] = '\0';
}

// assume 5 cycles per empty loop iteration
// assume the clock is 12 MHz, 83.33 ns per clock period
// for 0.5 sec delay we need 6 million cycles
// this means we need 1.2 million iteration

void delay_long()
{

    for (uint64_t i = 0; i < 1000000 / 5; i++)
        ;
}

void delay_short()
{

    for (uint64_t i = 0; i < 1; i++)
        ;
}

int main()
{
    uint8_t input_buffer[32];

    delay_long();

    uart_send_str("Hello to Joong's world \n");


    
    uart_send_str("please enter your name: ");



    uart_receive_str(input_buffer);


    delay_long();

    uart_send_str("\r\nHello, ");
    uart_send_str(input_buffer);
    uart_send_str("!\r\n");

    while (1)
    {
        GCSR->GPIO_0 = 0x55;
        delay_long();
        GCSR->GPIO_0 = 0xaa;
        delay_long();
    }
}
