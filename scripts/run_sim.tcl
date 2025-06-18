open_project /home/prawns/CHIP8_Real/CHIP8_Real.xpr

# Check argument
if { $argc < 1 } {
    puts "ERROR: No ROM file provided."
    exit 1
}
set rom_file [lindex $argv 0]
puts "INFO: ROM to load: $rom_file"

set_property -name xsim.simulate.runtime -value "all" -objects [get_filesets sim_1] 

set_property -name xsim.elaborate.xelab.more_options -value "" -objects [get_filesets sim_1]

set_property -name xsim.simulate.xsim.more_options -value "-testplusarg ROM=$rom_file" -objects [get_filesets sim_1]

file copy -force $rom_file "/home/prawns/CHIP8_Real/CHIP8_Real.sim/sim_1/behav/xsim/rom.mem"

launch_simulation