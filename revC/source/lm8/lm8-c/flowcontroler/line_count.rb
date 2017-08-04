#行数を数える
f = open(ARGV[0])
num_line = f.each{}.lineno

print "\n",ARGV[0]," : TOTAL LINE = ",num_line.to_s,"\n"

BROM_DEPTH = 2048
f.rewind

if num_line > BROM_DEPTH
	f_lo = File.open("prom_init_lo.mem","w")
	f_hi = File.open("prom_init_hi.mem","w")
	
	(BROM_DEPTH-1).times{
		f_lo.write(f.readline)
	}
	f_lo.write(f.readline.chop)
	f_lo.close
	
	(num_line-BROM_DEPTH-1).times{
		f_hi.write(f.readline)
	}
	f_hi.write(f.readline.chop)
	f_hi.close
	
end