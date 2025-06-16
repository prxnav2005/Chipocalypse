# scripts/sim.tcl

set rom_file [lindex $argv 0]
if { $rom_file eq "" } {
    puts "ERROR: No ROM file specified to TCL script."
    exit 1
}

open_project /home/prawns/CHIP8_Trial/CHIP8_Trial.xpr

set_property -name {xsim.elaborate.xelab.more_options} -value "+ROM=$rom_file" -objects [get_filesets sim_1]

launch_simulation
run 50000000ns
exit