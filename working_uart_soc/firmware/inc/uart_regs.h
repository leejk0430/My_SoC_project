// Created with Corsair v1.0.4
#ifndef __REGS_H
#define __REGS_H

#define __I  volatile const // 'read only' permissions
#define __O  volatile       // 'write only' permissions
#define __IO volatile       // 'read / write' permissions


#ifdef __cplusplus
#include <cstdint>
extern "C" {
#else
#include <stdint.h>
#endif

#define UCSR_BASE_ADDR 0x50000000

// U_TX_DATA - UART_TX Data register
#define UCSR_U_TX_DATA_ADDR 0x0
#define UCSR_U_TX_DATA_RESET 0x0
typedef struct {
    uint32_t DATA : 8; // Data To Send Via UART TX
    uint32_t : 24; // reserved
} ucsr_u_tx_data_t;

// U_TX_DATA.DATA - Data To Send Via UART TX
#define UCSR_U_TX_DATA_DATA_WIDTH 8
#define UCSR_U_TX_DATA_DATA_LSB 0
#define UCSR_U_TX_DATA_DATA_MASK 0xff
#define UCSR_U_TX_DATA_DATA_RESET 0x0

// U_TX_STAT - UART_TX Status register
#define UCSR_U_TX_STAT_ADDR 0x4
#define UCSR_U_TX_STAT_RESET 0x20
typedef struct {
    uint32_t : 5; // reserved
    uint32_t READY : 1; // UART is Ready
    uint32_t : 7; // reserved
    uint32_t TX_DONE : 1; // Done Transmitting The Last Char (TX) (8-bit)
    uint32_t : 18; // reserved
} ucsr_u_tx_stat_t;

// U_TX_STAT.READY - UART is Ready
#define UCSR_U_TX_STAT_READY_WIDTH 1
#define UCSR_U_TX_STAT_READY_LSB 5
#define UCSR_U_TX_STAT_READY_MASK 0x20
#define UCSR_U_TX_STAT_READY_RESET 0x1

// U_TX_STAT.TX_DONE - Done Transmitting The Last Char (TX) (8-bit)
#define UCSR_U_TX_STAT_TX_DONE_WIDTH 1
#define UCSR_U_TX_STAT_TX_DONE_LSB 13
#define UCSR_U_TX_STAT_TX_DONE_MASK 0x2000
#define UCSR_U_TX_STAT_TX_DONE_RESET 0x0

// U_TX_CTRL - UART_TX Control register
#define UCSR_U_TX_CTRL_ADDR 0x8
#define UCSR_U_TX_CTRL_RESET 0x0
typedef struct {
    uint32_t : 9; // reserved
    uint32_t TX_START : 1; // TX Begin Signal, Valid For Only One Cycle
    uint32_t : 22; // reserved
} ucsr_u_tx_ctrl_t;

// U_TX_CTRL.TX_START - TX Begin Signal, Valid For Only One Cycle
#define UCSR_U_TX_CTRL_TX_START_WIDTH 1
#define UCSR_U_TX_CTRL_TX_START_LSB 9
#define UCSR_U_TX_CTRL_TX_START_MASK 0x200
#define UCSR_U_TX_CTRL_TX_START_RESET 0x0

// U_RX_DATA - UART_RX Data register
#define UCSR_U_RX_DATA_ADDR 0x10
#define UCSR_U_RX_DATA_RESET 0x0
typedef struct {
    uint32_t DATA : 8; // Data To recieve Via UART RX
    uint32_t : 24; // reserved
} ucsr_u_rx_data_t;

// U_RX_DATA.DATA - Data To recieve Via UART RX
#define UCSR_U_RX_DATA_DATA_WIDTH 8
#define UCSR_U_RX_DATA_DATA_LSB 0
#define UCSR_U_RX_DATA_DATA_MASK 0xff
#define UCSR_U_RX_DATA_DATA_RESET 0x0

// U_RX_STAT - UART_RX Status register
#define UCSR_U_RX_STAT_ADDR 0x14
#define UCSR_U_RX_STAT_RESET 0x0
typedef struct {
    uint32_t : 6; // reserved
    uint32_t RX_OVERRUN : 1; // another data has arrived before finishing reading
    uint32_t : 7; // reserved
    uint32_t RX_VALID : 1; // new data has arrived
    uint32_t : 17; // reserved
} ucsr_u_rx_stat_t;

// U_RX_STAT.RX_OVERRUN - another data has arrived before finishing reading
#define UCSR_U_RX_STAT_RX_OVERRUN_WIDTH 1
#define UCSR_U_RX_STAT_RX_OVERRUN_LSB 6
#define UCSR_U_RX_STAT_RX_OVERRUN_MASK 0x40
#define UCSR_U_RX_STAT_RX_OVERRUN_RESET 0x0

// U_RX_STAT.RX_VALID - new data has arrived
#define UCSR_U_RX_STAT_RX_VALID_WIDTH 1
#define UCSR_U_RX_STAT_RX_VALID_LSB 14
#define UCSR_U_RX_STAT_RX_VALID_MASK 0x4000
#define UCSR_U_RX_STAT_RX_VALID_RESET 0x0

// U_RX_CTRL - UART_RX Control register
#define UCSR_U_RX_CTRL_ADDR 0x18
#define UCSR_U_RX_CTRL_RESET 0x0
typedef struct {
    uint32_t : 10; // reserved
    uint32_t RX_START : 1; // RX Begin Signal, Valid For Only One Cycle
    uint32_t RX_CLEAR : 1; // reset recive buffer (pulse)
    uint32_t : 20; // reserved
} ucsr_u_rx_ctrl_t;

// U_RX_CTRL.RX_START - RX Begin Signal, Valid For Only One Cycle
#define UCSR_U_RX_CTRL_RX_START_WIDTH 1
#define UCSR_U_RX_CTRL_RX_START_LSB 10
#define UCSR_U_RX_CTRL_RX_START_MASK 0x400
#define UCSR_U_RX_CTRL_RX_START_RESET 0x0

// U_RX_CTRL.RX_CLEAR - reset recive buffer (pulse)
#define UCSR_U_RX_CTRL_RX_CLEAR_WIDTH 1
#define UCSR_U_RX_CTRL_RX_CLEAR_LSB 11
#define UCSR_U_RX_CTRL_RX_CLEAR_MASK 0x800
#define UCSR_U_RX_CTRL_RX_CLEAR_RESET 0x0


// Register map structure
typedef struct {
    union {
        __IO uint32_t U_TX_DATA; // UART_TX Data register
        __IO ucsr_u_tx_data_t U_TX_DATA_bf; // Bit access for U_TX_DATA register
    };
    union {
        __IO uint32_t U_TX_STAT; // UART_TX Status register
        __IO ucsr_u_tx_stat_t U_TX_STAT_bf; // Bit access for U_TX_STAT register
    };
    union {
        __O uint32_t U_TX_CTRL; // UART_TX Control register
        __O ucsr_u_tx_ctrl_t U_TX_CTRL_bf; // Bit access for U_TX_CTRL register
    };
    __IO uint32_t RESERVED0[1];
    union {
        __I uint32_t U_RX_DATA; // UART_RX Data register
        __I ucsr_u_rx_data_t U_RX_DATA_bf; // Bit access for U_RX_DATA register
    };
    union {
        __IO uint32_t U_RX_STAT; // UART_RX Status register
        __IO ucsr_u_rx_stat_t U_RX_STAT_bf; // Bit access for U_RX_STAT register
    };
    union {
        __IO uint32_t U_RX_CTRL; // UART_RX Control register
        __IO ucsr_u_rx_ctrl_t U_RX_CTRL_bf; // Bit access for U_RX_CTRL register
    };
} ucsr_t;

#define UCSR ((ucsr_t*)(UCSR_BASE_ADDR))

#ifdef __cplusplus
}
#endif

#endif /* __REGS_H */