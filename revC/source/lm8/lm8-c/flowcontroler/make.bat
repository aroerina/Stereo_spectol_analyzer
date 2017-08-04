del *.elf *.mem
lm8-elf-gcc -Wall -Os -o a.elf flowctrl3.c
perl C:\Dev\source\lm8-c\lm8-deployer.pl C:\lscc\lm8\gtools\bin a.elf
ruby line_count.rb "prom_init.mem"
copy *.mem C:\Dev\source\HDL\FPGAProject\FFT_DEBUG\
pause