module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 

    parameter gndleft=0,gndright=1, left=2,right=3;
    reg [1:0] state, next_state;

    always @(*) begin
        case (state)
            gndleft: next_state = ground?left:gndleft; 
            gndright: next_state = ground?right:gndright; 
            left: next_state = ground?(bump_left?right:left):gndleft;
            right: next_state = ground?(bump_right?left:right):gndright;
        endcase
    end

    always @(posedge clk, posedge areset) begin
        if(areset) state<=left;
        else state<=next_state;
    end

    // Output logic
    assign walk_left = (state == left);
    assign walk_right = (state == right);
    assign aaah = (state == gndleft || state == gndright);

endmodule
