#include <stdint.h>

/* Estructure for GDTR e IDTR */
typedef struct {
  uint16_t limit; /* -1 */
  uint32_t base;  /* address table */
} __attribute__((packed)) descriptor_t; /* attribute obrigatory */

descriptor_t idr_desc;

void idt_init() {
    idr_desc.limit = sizeof(idt) - 1;
    idr_desc.base = (uint32_t)&idt;

    idt_load((uint32_t)&idr_desc);
}