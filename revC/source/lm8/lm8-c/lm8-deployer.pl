#########################################################################
#!/usr/bin/perl -w							#
#-----------------------------------------------------------------------#
# Script to generate On-Chip Memory Deployment File (.mem) for LM8 PROM #
#-----------------------------------------------------------------------#
#									#
# Revision History:							#
# Date       Author       Bug        Remarks			        #
# ---------  -----------  ---------  -----------------------------------#
# 12/15/09   saurabh		     Original	                        #
#									#
#########################################################################
use strict;
use Getopt::Std;
use lib "$FindBin::Bin/.";



#--------------------------------------------------------------------
# START PROCESSING:
#--------------------------------------------------------------------
#print "generating on-chip memory deployment file\n";



#--------------------------------------------------------------------
# Validate command-line arguments:
# Arg0: Bin2Verilog Executable Path
# Arg1: MSB Platform File
# Arg2: Application ELF Executable
# Arg3: Output Directory
# Arg4: Output File(s) Prefix
#--------------------------------------------------------------------
my $CmdLineArgs = $#ARGV + 1;
if ($CmdLineArgs < 2) {
	die "Usage: perl lm8-deployer.pl <Bin2Ver_Path> <ELF_Executable> \n failed";
}
my $Bin2VerExePath  = $ARGV[0];
#print ("$Bin2VerExePath\n");
my $ELFExecutable   = $ARGV[1];
#print ("$ELFExecutable\n");
my $Bin2VerExe      = $Bin2VerExePath."\/bin_to_verilog";



#--------------------------------------------------------------------
# Make sure Platform MSB file and ELF application executable exist
#--------------------------------------------------------------------
(-e $ELFExecutable) || die "failed to find application executable $ELFExecutable\n failed ";



#--------------------------------------------------------------------
# Extract section information from ELF Executable using GCC Utility
# lm32-elf-readelf. We are only interested in the number of program
# headers, the virtual address of each header, and the sections
# mapped to each program header.
# -------------------------------------------------------------------
my $ElfReaderCmd = "lm8-elf-readelf -l $ELFExecutable > readelf.out";
system $ElfReaderCmd;

my @ExeSegments;
my @ExeSegmentFlags;
my $ExeSegmentsIndex = 0;
my @ExeMemories;
my $ExeMemoriesIndex = 0;
my $startDetect = 0;
(open (INFILE, '<', "readelf.out")) || die "failed to open readelf.out\n failed ";
foreach my $line (<INFILE>) {
	# print ("$line");
	if ($line =~ /LOAD/) {
		my @lineElements = split (/ +/, $line);
		my $virtAddress = $lineElements[3];
		my $flags = $lineElements[7];
		
		$ExeSegments[$ExeSegmentsIndex] = $virtAddress;
		if ($flags =~ /RW/) {
			$ExeSegmentFlags[$ExeSegmentsIndex] = 0;
		} else {
			$ExeSegmentFlags[$ExeSegmentsIndex] = 1;
		}
		$ExeSegmentsIndex = $ExeSegmentsIndex + 1;
	}
	
	elsif ($line =~ /Segment Sections/) {
		$startDetect = 1;
	}
	
	else {
		if ($startDetect) {
			my @lineElements = split (' ', $line);
			my $sections = " ";
			splice(@lineElements, 0, 1);
			foreach my $lineElement (@lineElements) {
				$sections = $sections . "-j $lineElement ";
			}
			# print ("$sections\n");
			$ExeMemories[$#ExeMemories + 1] = {
				"address"  => $ExeSegments[$ExeMemoriesIndex],
				"flags"    => $ExeSegmentFlags[$ExeMemoriesIndex],
				"sections" => $sections
			};
			$ExeMemoriesIndex = $ExeMemoriesIndex + 1;
		}
	}
}
close (INFILE);



#--------------------------------------------------------------------
#
#--------------------------------------------------------------------
my $ExeMemoryAddress;       # Start Address of Program Header
my $ExeMemoryFlags;         # Flags associated with Program Header
my $ExeMemorySections;      # Sections belonging to Program Header
foreach my $ExeMemory (@ExeMemories) 
{
    $ExeMemoryAddress  = $ExeMemory->{address};
    $ExeMemoryFlags    = $ExeMemory->{flags};
    $ExeMemorySections = $ExeMemory->{sections};
    
    my $ApplicationBin = "Application.bin";
    my $ApplicationMem;
    my $DataWidth;
    if ($ExeMemoryFlags eq 1) {
	    $ApplicationMem = "prom_init.mem";
	    $DataWidth = 3;
    } else {
	    $ApplicationMem = "scratchpad_init.mem";
	    $DataWidth = 1;
    }
    my $ObjCopyCmd = "lm8-elf-objcopy $ExeMemorySections -O binary $ELFExecutable $ApplicationBin";
    #print ("$ObjCopyCmd\n");
    my $VerilogCmd = "$Bin2VerExe --LM8 --h --EB --width $DataWidth $ApplicationBin $ApplicationMem";
    #print ("$VerilogCmd\n");
    system $ObjCopyCmd;
    system $VerilogCmd;
}



#--------------------------------------------------------------------
# Clean up
# -------------------------------------------------------------------
system "rm -r -f readelf.out";
system "rm -r -f Application.bin";
