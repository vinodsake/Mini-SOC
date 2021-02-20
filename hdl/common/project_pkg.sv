/**********************************************************************
* File Name	: project_pkg.sv
* Description 	: Project package
* Creation Date : 04-02-2021
* Last Modified : Sat 06 Feb 2021 06:26:29 PM PST
* Author 	: Vinod Sake
* Email 	: vinodsake042@gmail.com
* GitHub	: github.com/vinodsake
**********************************************************************/
`ifndef _PROJECT_PKG_
`define _PROJECT_PKG_

package project_pkg;
	parameter DATA_SIZE = 8;
	parameter ADDR_SIZE = 8;
	parameter CMD_SIZE = 3;
	parameter FIFO_DEPTH = 8;
endpackage
`endif
