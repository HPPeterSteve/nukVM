#include <stdint.h>
#include "idt.h"

typedef struct {
    uint16_t isr_low;
    uint16_t kernel_cs;
    uint8_t reserved;
    uint8_t attributes;
    uint16_t isr_high;
} __attribute__((packed)) idt_entry_t;

idt_entry_t idt[256];

void idt_set(int vetor, uint32_t handler) {
    idt[vetor].isr_low  = handler & 0xFFFF;
    idt[vetor].kernel_cs    = 0x08;
    idt[vetor].reserved        = 0;
    idt[vetor].attributes       = 0x8E;
    idt[vetor].isr_high = (handler >> 16) & 0xFFFF;
}