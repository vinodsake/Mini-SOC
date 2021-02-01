# Mini-SOC 
This project is intended to understand how systems comunicate in a SOC

Protocol Used: AMBA 3 APB

Sub-IP's:
1. Calculator (designed in uvm dir)
2. FIFO to hold packets  

Calc and FIFO run on different clocks and need a clock domain crossing logic to communicate via APB protocol.


