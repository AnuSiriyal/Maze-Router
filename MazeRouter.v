//-----------------------------------------------------
// Design Name : Maze Router
// File Name   : MazeRouter.v
// Authors	   : Yang Zhang
// Function    : Read "map" saved inside RAM and output routing 
//-----------------------------------------------------
`timescale 1ns/10ps
module maze_router (
reset		,
start		,
clk         , // Clock Input
address     , // Address Output
data_in        , // Data 
data_out,
cs          , // Chip Select
we          , // Write Enable/Read Enable
D); 
parameter WIDTH = 8 ;
parameter DEPTH = 1 << WIDTH;
parameter WIDTH1 = 8 ;
parameter DEPTH1 = 1 << WIDTH1;
parameter DATA_WIDTH = 8 ;
parameter ADDR_WIDTH = 8 ;



//------------Input--------------- 
input					reset		;
input 					start	;
input                  clk         ;


input [DATA_WIDTH-1:0]  data_in       ;

//------------output---------------
output                  cs          ;
output                  we          ;
output [DATA_WIDTH-1:0]  data_out       ;
output [ADDR_WIDTH-1:0] address     ;
output D;
reg cs,we;
reg [DATA_WIDTH-1:0]  data_out       ;
reg [ADDR_WIDTH-1:0] address     ;
reg D	;
//reg set;



//--------------Code Starts Here------------------ 

integer i,j,k,loc,loct,locs,locp,counter,flag,max,x,y,writer,data,flags,l;
integer count;
reg [7:0] a[0:63];
reg [7:0] b[0:63];
reg [7:0] d[0:63];
reg [WIDTH-1:0] c [0:DEPTH-1];
reg [WIDTH1-1:0] e [0:DEPTH1-1];
reg [1:0] STATE;
parameter INITIALIZE=2'b00,FILL=2'b01,BACKTRACK=2'b10,LOADMEM=2'b11;


always@(posedge clk)
begin	//always
	
	if(reset==1)
	begin//if
		count=0;flags=1;
	   STATE <=INITIALIZE;
	end//if
	else 
	begin//else
	case(STATE)
	   INITIALIZE: begin//state INITIALIZE
			
//--------------------LOAD FROM MEMORY--------------------------// 
			if(count<=131)
			begin//if 
			  if(((count-2)<64)&&(flags==1))
			   begin
				address<=count;
				cs<=1;
				we<=0;
				a[count-2]<=data_in;
				d[count-2]<=data_in;
				b[count]<=0;
				
      			    end
			  if((count-2)==128)
				begin
				address<=count;
				cs<=1;
				we<=0;
				locs<=data_in;
				end
			  if(count-2==129)
				begin
				address<=count;
				cs<=1;
				we<=0;
				loct<=data_in;
				end
			  if((count-2)==64)
			    begin
			 	flags=0;
			    end
			address<=count;
			cs<=1;
			we<=0;
			count<=count+1;
			STATE<=INITIALIZE;
			end
			if(count==131)
			begin
			STATE<=FILL;
			end
			end
		FILL: begin//FILL state
			
			b[locs]=1;
			c[0]=locs;
			counter=1;
			x=1;
			flag=0;
			max=1;e[0]=locs;
			for(i=1;i<=16;i=i+1)
			  begin//for
        		 j=0;k=0;
				 for(l=0;l<20;l=l+1)
				 begin
					c[l]=e[l];
				 end
			    counter=x;
			   while(counter!=0)
			    begin//while
			      loc=c[j];
       			      counter=counter-1;
			      j=j+1;
					
			      if((((loc+1)!=loct)||((loc+8)!=loct)||((loc-1)!=loct)||((loc-8)!=loct))&&(flag==0))
			      begin//if1
					if((a[loc+1]==8'hee)&&((loc+1)<64)&&((loc+1)>=0)&&(flag==0))
                 begin//if2
							
                    					if((b[loc+1]==0)||(b[loc+1]==(i+1)))
								begin//if3
								b[loc+1]=i+1;
								//m=loc+1;
								e[k]=loc+1;k=k+1;
								end//if3
						end//if2
					if((a[loc-1]==8'hee)&&((loc-1)<64)&&((loc-1)>=0)&&(flag==0))
                	begin//if2
                    if((b[loc-1]==0)||(b[loc-1]==(i+1)))
							begin//if3
							b[loc-1]=i+1;
							e[k]=loc-1;k=k+1;
							end//if3
						end//if2
                if((a[loc+8]==8'hee)&&((loc+8)<64)&&((loc+8)>=0)&&((flag==0)))
                  begin//if2
                    if((b[loc+8]==0)||(b[loc+8]==(i+1)))
							begin//if3
								b[loc+8]=i+1;
								e[k]=loc+8;k=k+1;
							end//if3
						end//if2
					  if((a[loc-8]==8'hee)&&((loc-8)<64)&&((loc-8)>=0)&&((flag==0)))
                	begin//if2
                    if((b[loc-8]==0)||(b[loc-8]==(i+1)))
							begin//if3
							b[loc-8]=i+1;
							e[k]=loc-8;k=k+1;
							end//if3
						end//if2
                 end//if1
					a[loc]=8'h25;
			if(((loc+1)==loct)&&(flag==0))
           begin
				flag=1;max=i+1;b[loc+1]=i;locp=loc;
				a[loc+1]=8'h25;
				end
		
		       if(((loc-1)==loct)&&(flag==0))
               begin
					max=i+1;flag=1;b[loc-1]=i;locp=loc;
					a[loc-1]=8'h25;
				   end
		       if(((loc+8)==loct)&&(flag==0))
               begin
					max=i+1;flag=1;b[loc+8]=i;locp=loc;
					a[loc+8]=8'h25;
				   end
		      if(((loc-8)==loct)&&(flag==0))
               begin
					max=i+1;flag=1;b[loc-8]=i;locp=loc;
					a[loc-8]=8'h25;
				   end
				x=k;
			
	       end//while
			
	         end//for
	
		if(((locp-1)!=loct)&&((b[locp-16]==(b[locp]-2))||(b[locp-9]==(b[locp]-2))||(b[locp-7]==(b[locp]-2))))
		  b[locp-1]=b[locp]-1;
		if(((locp+1)!=loct)&&((b[locp-7]==(b[locp]-2))||(b[locp+2]==(b[locp]-2))||(b[locp-9]==(b[locp]-2))))
		  b[locp+1]=b[locp]-1;
		if(((locp-8)!=loct)&&((b[locp-7]==(b[locp]-2))||(b[locp-16]==(b[locp]-2))||(b[locp-9]==(b[locp]-2))))
		  b[locp-8]=b[locp]-1;
		if(((locp+8)!=loct)&&((b[locp+9]==(b[locp]-2))||(b[locp+16]==(b[locp]-2))||(b[locp-9]==(b[locp]-2))))
		  b[locp+8]=b[locp]-1;
		b[loct]=max;
		writer = $fopen("filling.txt","w");
		j=0;
		for(i = 0; i < 64; i = i + 1)
		begin
		
		  if(j==8)
		   begin
			j=0;
			$fwrite(writer,"\n");
		  end
		$fwrite(writer,"%h ",b[i]);
		j=j+1;
		end
		$fwrite(writer,"\n");
		$fclose(writer);
			
			STATE <=BACKTRACK;
		end
    BACKTRACK: begin
		loc=loct;
		d[loct]=8'h00;
		for(i=max;i>=0;i=i-1)
		 begin
		 if((b[loc-1]==(i-1))&&(d[loc-1]==8'hee))
	          begin
		   d[loc-1]=8'h00;
		   loc=loc-1;
	          end
	         else if((b[loc-8]==(i-1))&&(d[loc-8]==8'hee))
	          begin
		   d[loc-8]=8'h00;
		   loc=loc-8;
	          end
	        else if((b[loc+1]==(i-1))&&(d[loc+1]==8'hee))
	          begin
		   d[loc+1]=8'h00;
		   loc=loc+1;
	          end
	        else if((b[loc+8]==(i-1))&&(d[loc+8]==8'hee))
	          begin
		   d[loc+8]=8'h00;
		   loc=loc+8;
	          end 
		end//for end
		flags=1;count=0;
		STATE<=LOADMEM;
	       end//state end
LOADMEM: begin
	
	if(count==64)
	   begin
	     flags=0;D=1;
	   end
	if((count<64)&&(flags==1))
           begin
	    address=count;
	    cs=1;
	    we=1;
	    data_out=d[count];
	    count=count+1;
	end
	
	end//state end	
	     endcase
	   end//else end
	end//always end
endmodule