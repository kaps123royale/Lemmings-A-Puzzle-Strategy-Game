module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    parameter gndleft=0,gndright=1, left=2,right=3, digleft=4,digright=5,splatter=6;
    reg [2:0] state, next_state;
    integer count=0;

    always @(*) begin
        case (state)
            
            gndleft:begin next_state = (ground && count<=19)?left:((count>=20 && ground==1 )?splatter:gndleft);  end
            gndright:begin next_state = (ground && count<=19)?right:((count>=20 && ground==1)?splatter:gndright); end
            left: next_state = ground?(dig?digleft:(bump_left?right:left)):gndleft;
            right: next_state = ground?(dig?digright:(bump_right?left:right)):gndright;
            digleft: next_state = ~ground?gndleft:digleft;
            digright: next_state = ~ground?gndright:digright;
            splatter: next_state = areset?left:splatter;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        if(areset)
            state<=left;
        else if(state == gndleft || state == gndright) begin
            count=count+1;
           state<=next_state; 
        end
        else begin
            state<=next_state;
            count=0;
        end
        
    end


    always @(*) begin
        case (state)
            left : begin walk_left = 1; walk_right=0; aaah=0;digging=0; end
            right : begin walk_left = 0; walk_right=1; aaah=0;digging=0; end
            gndleft : begin walk_left = 0; walk_right=0; aaah=1;digging=0; end
            gndright : begin walk_left = 0; walk_right=0; aaah=1;digging=0; end
            digleft : begin walk_left = 0; walk_right=0; aaah=0;digging=1; end
            digright : begin walk_left = 0; walk_right=0; aaah=0;digging=1; end
            splatter : begin walk_left = 0; walk_right=0; aaah=0;digging=0; end
        endcase
    end
    // Output logic
    

    
endmodule
