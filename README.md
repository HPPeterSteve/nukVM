# nukVM — storage microkernel

<img width="1188" height="648" alt="image" src="https://github.com/user-attachments/assets/95fb6a79-8a65-4041-b4e4-7759c5918360" />


> A bare-metal storage microkernel that bridges an isolated kernel and the Linux host via a lightweight driver — built from scratch in Assembly and C.

---

## What is this?

nukVM is not a general-purpose OS. It doesn't run browsers, games, or user apps.

It boots, mounts its storage engine, protects your data, and stays out of the way.

Think of it as a **fortress with a brain** — a dedicated kernel whose only job is to handle files securely, efficiently, and in complete isolation from the main system.

---

## Architecture

```
Linux Kernel
     │
     │  nukVM driver (IPC bridge)
     ▼
nukVM Microkernel  (bare metal)
     │
     ├── Boot (16-bit → Protected Mode)
     ├── GDT / IDT
     ├── Memory Manager
     ├── Storage Engine
     │     ├── Alphabetical indexing
     │     ├── Object catalog
     │     └── Integrity hashing
     ├── Crypto layer
     └── VT-x / AMD-V (paging & isolation)
```

The Linux kernel stays in control of the machine. nukVM runs as an isolated bare-metal layer, receiving and returning data through a dedicated kernel driver. If nukVM crashes, Linux keeps breathing.

---

## Boot flow

```
BIOS
 └─► boot.asm       (16-bit, loads sectors from disk)
      └─► entry.asm  (GDT setup → Protected Mode 32-bit)
           └─► kernel_main()  (C kernel entry point)
```

---

## Current status

| Component         | Status        |
|-------------------|---------------|
| Bootloader        | ✅ Working     |
| Protected Mode    | ✅ Working     |
| GDT               | ✅ Working     |
| IDT               | 🔧 In progress |
| Memory Manager    | ⏳ Planned     |
| Storage Engine    | ⏳ Planned     |
| Crypto layer      | ⏳ Planned     |
| VT-x / AMD-V      | ⏳ Planned     |
| Linux driver      | ⏳ Planned     |

---

## Roadmap

- [x] Bootloader with disk error handling
- [x] Protected mode entry
- [x] GDT (ring 0 + ring 3 segments)
- [ ] IDT with ISR handlers
- [ ] `kernel_main()` via linker + ELF
- [ ] VGA text driver
- [ ] Physical memory manager (bitmap allocator)
- [ ] Storage engine — object indexing
- [ ] Alphabetical sorting + catalog
- [ ] Integrity hashing (SHA-256)
- [ ] VT-x / AMD-V paging
- [ ] Linux kernel driver (IPC bridge)

---

## Build

Requirements:
- `nasm` — assembler
- `gcc` — C compiler (cross-compile i386)
- `ld` — linker
- `qemu-system-x86_64` — emulator

```bash
# Build and run in QEMU
nasm -f bin boot/boot.asm -o boot/boot.bin
nasm -f bin boot/entry.asm -o boot/entry.bin
cat boot/boot.bin boot/entry.bin > boot/disk.bin
qemu-system-x86_64 -drive format=raw,file=boot/disk.bin
```

---

## Contributing

Early stage — contributions are welcome, especially in:

- x86 low-level (GDT, IDT, paging)
- Storage engine design
- Linux kernel driver (character device / IPC)
- Security review

Open an issue or send a PR. No CLA, no bureaucracy.

---

## License

GPL-2.0 — see `LICENSE`.

---

> *"The kernel doesn't need to be a city. It can be a fortress."*
