# Mini-SOC 
This project is intended to understand how systems comunicate in a SOC

Protocol Used: AMBA 3 APB

Sub-IP's:
1. Calculator (designed in learnsv/uvm)
2. FIFO to hold packets 
3. use APB inerconnect fabric 

Calc and FIFO run on different clocks and need a clock domain crossing logic to communicate via APB protocol.


