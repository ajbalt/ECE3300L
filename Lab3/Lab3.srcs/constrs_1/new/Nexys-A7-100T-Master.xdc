## X operand - SW3-SW0
set_property -dict { PACKAGE_PIN J15  IOSTANDARD LVCMOS33 } [get_ports { X[0] }];
set_property -dict { PACKAGE_PIN L16  IOSTANDARD LVCMOS33 } [get_ports { X[1] }];
set_property -dict { PACKAGE_PIN M13  IOSTANDARD LVCMOS33 } [get_ports { X[2] }];
set_property -dict { PACKAGE_PIN R15  IOSTANDARD LVCMOS33 } [get_ports { X[3] }];

## Y operand - SW7-SW4
set_property -dict { PACKAGE_PIN R17  IOSTANDARD LVCMOS33 } [get_ports { Y[0] }];
set_property -dict { PACKAGE_PIN T18  IOSTANDARD LVCMOS33 } [get_ports { Y[1] }];
set_property -dict { PACKAGE_PIN U18  IOSTANDARD LVCMOS33 } [get_ports { Y[2] }];
set_property -dict { PACKAGE_PIN R13  IOSTANDARD LVCMOS33 } [get_ports { Y[3] }];

## Digit select - SW9-SW8 (bank 34: LVCMOS18)
set_property -dict { PACKAGE_PIN T8   IOSTANDARD LVCMOS18 } [get_ports { digit_sel[0] }];
set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS18 } [get_ports { digit_sel[1] }];

## Operation select - SW15-SW14
set_property -dict { PACKAGE_PIN U11  IOSTANDARD LVCMOS33 } [get_ports { op_sel[0] }];
set_property -dict { PACKAGE_PIN V10  IOSTANDARD LVCMOS33 } [get_ports { op_sel[1] }];

## 7-segment cathodes (active-low, gfedcba)
set_property -dict { PACKAGE_PIN T10  IOSTANDARD LVCMOS33 } [get_ports { sseg[0] }]; ## CA
set_property -dict { PACKAGE_PIN R10  IOSTANDARD LVCMOS33 } [get_ports { sseg[1] }]; ## CB
set_property -dict { PACKAGE_PIN K16  IOSTANDARD LVCMOS33 } [get_ports { sseg[2] }]; ## CC
set_property -dict { PACKAGE_PIN K13  IOSTANDARD LVCMOS33 } [get_ports { sseg[3] }]; ## CD
set_property -dict { PACKAGE_PIN P15  IOSTANDARD LVCMOS33 } [get_ports { sseg[4] }]; ## CE
set_property -dict { PACKAGE_PIN T11  IOSTANDARD LVCMOS33 } [get_ports { sseg[5] }]; ## CF
set_property -dict { PACKAGE_PIN L18  IOSTANDARD LVCMOS33 } [get_ports { sseg[6] }]; ## CG

## Decimal point
set_property -dict { PACKAGE_PIN H15  IOSTANDARD LVCMOS33 } [get_ports { DP }];

## Anode select (active-low)
set_property -dict { PACKAGE_PIN J17  IOSTANDARD LVCMOS33 } [get_ports { AN[0] }];
set_property -dict { PACKAGE_PIN J18  IOSTANDARD LVCMOS33 } [get_ports { AN[1] }];
set_property -dict { PACKAGE_PIN T9   IOSTANDARD LVCMOS33 } [get_ports { AN[2] }];
set_property -dict { PACKAGE_PIN J14  IOSTANDARD LVCMOS33 } [get_ports { AN[3] }];
set_property -dict { PACKAGE_PIN P14  IOSTANDARD LVCMOS33 } [get_ports { AN[4] }];
set_property -dict { PACKAGE_PIN T14  IOSTANDARD LVCMOS33 } [get_ports { AN[5] }];
set_property -dict { PACKAGE_PIN K2   IOSTANDARD LVCMOS33 } [get_ports { AN[6] }];
set_property -dict { PACKAGE_PIN U13  IOSTANDARD LVCMOS33 } [get_ports { AN[7] }];

## carry_out → LED14
set_property -dict { PACKAGE_PIN V12  IOSTANDARD LVCMOS33 } [get_ports { carry_out }];

## overflow → LED15
set_property -dict { PACKAGE_PIN V11  IOSTANDARD LVCMOS33 } [get_ports { overflow }];