
ENTRY( _start )   
__stack_size = 1232896;  

PROVIDE( _stack_size = __stack_size );  
 
MEMORY
{
    RAM (xrw)  : ORIGIN = 0x80000000, LENGTH = 16M
}
 
SECTIONS
{
    .text :
    {
        . = ALIGN(8);
        *(.text)
        *(.text.*)
        *(.rodata)
        *(.rodata*)
        *(.gnu.linkonce.t.*)
        . = ALIGN(8);
    } >RAM
 
    .data :
    {
        *(.gnu.linkonce.r.*)
        *(.data .data.*)
        *(.gnu.linkonce.d.*)
        . = ALIGN(8);
        PROVIDE( __global_pointer$ = . + 0x800 );
        *(.sdata .sdata.*)
        *(.sdata2.*)
        *(.gnu.linkonce.s.*)
        . = ALIGN(8);
        *(.srodata.cst16)
        *(.srodata.cst8)
        *(.srodata.cst4)
        *(.srodata.cst2)
        *(.srodata .srodata.*)
        . = ALIGN(8);
        PROVIDE( _edata = .);
    } >RAM
 
    .bss :
    {
        . = ALIGN(8);
        PROVIDE( _sbss = .);
        *(.sbss*)
        *(.gnu.linkonce.sb.*)
        *(.bss*)
        *(.gnu.linkonce.b.*)		
        *(COMMON*)
        . = ALIGN(8);
        PROVIDE( _ebss = .);
    } >RAM
 
    PROVIDE( _end = _ebss);
    PROVIDE( end = . ); 
 
 
    .stack ORIGIN(RAM) + LENGTH(RAM) - __stack_size :
    {
        PROVIDE( _heap_end = . ); 
        . = ALIGN(8);
        PROVIDE(_susrstack = . );
        . = . + __stack_size;
        PROVIDE( _eusrstack = .);
    } >RAM 
 
}