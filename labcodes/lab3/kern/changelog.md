1. replace `libs/sbi.S` with `sbi.c`
2. fix `libs/defs.h` (32bit ptr -> 64bit ptr)
3. fix `kern/driver/clock.c`, enable sie
4. change `kern/init/entry.S`, enable pagetable
5. fix `tools/kernel.ld`
6. disable fine-grained paging in `kern/mm/pmm.c`, and replace sbi_detect_memory
7. add macros in `kern/mm/memlayout.h`
8. change `makefile`
9. change `flush_tlb`