## Inputs — X operand
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { x[0] }];
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { x[1] }];
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { x[2] }];
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { x[3] }];

## Inputs — Y operand
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { y[0] }];
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { y[1] }];
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { y[2] }];
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { y[3] }];

## Inputs — Operation select
set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { op_sel[0] }];
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { op_sel[1] }];

## Outputs — BCD result (ones = [3:0], tens = [7:4], hundreds = [11:8])
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { result[0] }];
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { result[1] }];
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { result[2] }];
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { result[3] }];

set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { result[4] }];
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { result[5] }];
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { result[6] }];
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { result[7] }];

set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { result[8] }];
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { result[9] }];
set_property -dict { PACKAGE_PIN U14   IOSTANDARD LVCMOS33 } [get_ports { result[10] }];
set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { result[11] }];

## Outputs — Status flags
set_property -dict { PACKAGE_PIN V14   IOSTANDARD LVCMOS33 } [get_ports { negative }];
set_property -dict { PACKAGE_PIN V12   IOSTANDARD LVCMOS33 } [get_ports { carry_out }];
set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { overflow }];