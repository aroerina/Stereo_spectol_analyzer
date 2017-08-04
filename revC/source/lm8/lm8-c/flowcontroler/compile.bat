del *.elf *.mem
lm8-elf-gcc -Wall -Os -O2 -c flowctrl2.c
lm8-elf-gcc -o a.elf flowctrl2.o
pause