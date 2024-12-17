//使用20ns的时钟sclk
//----------------RTL-----------------
module	cnt_1s
#(
	parameter CNT_1US_MAX = 6'd49,
	parameter CNT_1MS_MAX = 10'd999,
	parameter CNT_1S_MAX  = 10'd99999
)
(
	input   wire	sclk	,
	input   wire	rst_n	,
	
	output	reg		time
);

reg	[5:0] cnt_1us;	
reg	[9:0] cnt_1ms;	
reg	[16:0] cnt_1s;		
reg		  cnt_1us_flag;
reg		  cnt_1ms_flag;
reg		  cnt_1s_flag;


#(
	parameter CNT_1US_MAX = 6'd49,
	parameter CNT_1MS_MAX = 10'd999,
	parameter CNT_1S_MAX  = 10'd999
)
(
	input   wire	sclk	,
	input   wire	rst_n	,
	
	output	reg		led
);

reg	[5:0] cnt_1us;	
reg	[9:0] cnt_1ms;	
reg	[9:0] cnt_1s;		
reg		  cnt_1us_flag;
reg		  cnt_1ms_flag;
reg		  cnt_1s_flag;

//cnt_1us:1us计数器
always@(posedge sclk or negedge	rst_n)
	if(rst_n == 1'b0)	
		cnt_1us <= 6'b0;	
	else	if(cnt_1us	== CNT_1US_MAX)	
		cnt_1us <= 6'b0;
	else
		cnt_1us <= cnt_1us + 1'b1;

//cnt_1us_flag:1us计数器标志信号
always@(posedge sclk or negedge	rst_n)
	if(rst_n == 1'b0)	
		cnt_1us_flag <= 1'b0;	
	else	if(cnt_1us	==	CNT_1US_MAX)	
		cnt_1us_flag <= 1'b1;
	else
		cnt_1us_flag <= 1'b0;

//cnt_1ms:1ms计数器
always@(posedge sclk or negedge	rst_n)
	if(rst_n == 1'b0)	
		cnt_1ms <= 10'b0;	
	else	if(cnt_1ms == CNT_1MS_MAX && cnt_1us_flag == 1'b1)	
		cnt_1ms <= 10'b0;
	else	if(cnt_1us_flag == 1'b1)
		cnt_1ms <= cnt_1ms + 1'b1;
		
//cnt_1ms_flag:1ms计数器标志信号

always@(posedge sclk or negedge	rst_n)
	if(rst_n == 1'b0)	
		cnt_1ms_flag <=	1'b0;	
	else	if(cnt_1ms == CNT_1MS_MAX && cnt_1us_flag == 1'b1)	
		cnt_1ms_flag <= 1'b1;
	else	
		cnt_1ms_flag <= 1'b0;

//cnt_1s:1s计数器，可以直接用time不用cnt_1s.
always@(posedge sclk or negedge	rst_n)
	if(rst_n == 1'b0)	
		cnt_1s	<=	10'b0;	
        time <=	10'b0;
	else if(cnt_1s == CNT_1S_MAX && cnt_1ms_flag == 1'b1)	
		cnt_1s	<=	10'b0;
        time <=	10'b0;
	else if(cnt_1ms_flag == 1'b1)
		cnt_1s	<=	cnt_1s	+ 1'b1;
        time = ~time;

//time每秒翻转一次，翻转时就要有输出。
end module