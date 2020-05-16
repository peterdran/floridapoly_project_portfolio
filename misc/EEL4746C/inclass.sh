#shell to assemble & run
avr-as -mmcu=atmega328 -o inclass.o inclass_prog.asm -a
avr-ld -o inclass_exec.elf inclass.o
simulavr -d atmega328 -g -F 20000000 &
avr-gdb
#remote localhost:1212
#file inclass_exec.elf
#load inclass_exec.elf
#continue
#^c #TODO, set breakpoint
#disassemble
#info registers