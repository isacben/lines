pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
function _init()
	t=0
	spd=60
	vel=8
	piece_x=16 --center of 96
	piece_y=0
	
	reset_board()
	
	p_names={"block","tee"}
	pce_squares={}
	buff_squares={}
	current_pce={}
	squares={}
	
	init_current_pce()
	
	generate(el,2)
	
	debug="tetris"
end

function _update()
	down()
	move()
end

function _draw()
	cls(0)
	t+=1
	
	stage()
	draw()
	
	print(debug,0,0,15)
end
-->8
-- draw

function draw()
	for square in all(pce_squares) do
		--[[rect(
			square.x,
			square.y,
			square.x+8,
			square.y+8,
			9)]]--
		spr(square.spr,square.x,square.y)
	end
	
	for square in all(squares) do
		--[[rect(
			square.x,
			square.y,
			square.x+8,
			square.y+8,
			9)]]--
		spr(square.spr,square.x,square.y)
		end
end

function stage()
	line(96,0,96,128,7)
end
-->8
-- move & collisions

function down()
	
	if t%spd == 0 then
		current_pce.y+=vel
		
		if on_floor() then
			stop_pce()
			init_current_pce()
			generate(tee,4)
		end
	
		for square in all(pce_squares) do
			square.y+=vel
		end
	end
end

function move()
	local move=8
	local cx=current_pce.x
	local cw=current_pce.w
	
	--move left
	if btnp(0) then
		for cs in all(pce_squares) do
			
			--collision with squares
			for s in all(squares) do
				if cs.y==s.y then
					if cs.x == s.x+8 then 
						move=0
					end
				end
			end
			
			--collision with the wall
			if cs.x<=0 then
				move=0
			end
		end
		
		current_pce.x-=move
		for s in all(pce_squares) do
			s.x-=move
		end
	end
	
	--move rigth
	if btnp(1) then
		for cs in all(pce_squares) do
			
			--collision with squares
			for s in all(squares) do
				if cs.y==s.y then
					if cs.x+8 == s.x then 
						move=0
					end
				end
			end
			
			--collision with the wall
			if cs.x+8>=96 then
				move=0
			end
		end
	
		current_pce.x+=move
		for s in all(pce_squares) do
			s.x+=move
		end
	end
	
	--rotate
	if btnp(2) then
		rotate(acurr)
	end
end


function on_floor()	
	for cp_sqr in all(pce_squares) do
		
		--collision with squares
		for sqr in all(squares) do
			if cp_sqr.y+8 == sqr.y and
				cp_sqr.x == sqr.x then
				--stop_pce()
				return true
			end
		end
		
		--collision with floor
		if cp_sqr.y+8>=120 then
			stop_pce()
			return true
		end
	end
end


function stop_pce()
	for s in all(pce_squares) do
		add(squares,s)
	end
		
	pce_squares={}
end
-->8
-- pieces

function generate(arr,_spr)
	acurr=arr
	
	for row=1,#arr do
		for col=1,#arr[1] do
			if arr[row][col]==1 then
				local s={}
				s.x=current_pce.x+(col-1)*8
				s.y=current_pce.y+(row-1)*8
				s.spr=_spr
				add(pce_squares,s)
			end
		end
	end
	
	--debug=current_pce.w..","..current_pce.h
end
-->8
--general

function init_current_pce()
	current_pce.x=piece_x
	current_pce.y=piece_y
	current_pce.w=0
	current_pce.h=0
end


function overlaping()
	
end


function rotate(arr)
	local temp={}
	buff_squares={}
	
	--create arry of a given size
	--for row=1,#arr do
	--	temp[row]={}
	--	for col=1,#arr[1] do
	--		temp[row][col]=0
	--	end
	--end
	
	--rotate the array
	--local n=#arr+1
	--for r=1,#arr do
	--	for c=1,#arr do
	--		temp[c][n-r]=arr[r][c]
	--	end
	--end
	
	local n=#arr+1
	for col=1,#arr[1] do
		temp[col]={}
		for row=1,#arr do
			temp[col][n-row]=arr[row][col]
		end
	end
	
	--check overlaping
	for row=1,#temp do
		for col=1,#temp[1] do
			if temp[row][col]==1 then
				local s={}
				s.x=current_pce.x+(col-1)*8
				s.y=current_pce.y+(row-1)*8
				add(buff_squares,s)
			end
		end
	end
	for bs in all(buff_squares) do
		if bs.x<0 or bs.x>=96 or
			bs.y>=120 then
			return false
		end
		for s in all(squares) do
			if bs.x==s.x and bs.y==s.y then
				return false
			end
		end
	end
	
	
	--re paint the piece
	pce_squares={}
	acurr=temp
	generate(acurr,3)
end

function new_arr(size)
	local row={}
	acurr={}
	
	for i=1,size do
		add(row,0)
	end
	
	for j=1,size do
		add{acurr,{0,0,0,0}}
	end
end


function reset_board()
	for row=1,13 do
		board[row]={}
		for col=1,14 do
			if col==1 or col==14 or row==13 then
				board[row][col]=2
			else
				board[row][col]=0
			end
		end
	end
end
-->8
--arrays

acurr={}

block={
	{1,1},
	{1,1}
}

tee={
	{0,1,0},
	{1,1,1},
	{0,0,0}
}

--0,1,0
--0,1,1
--0,1,0
el={
	{0,1,0},
	{0,1,0},
	{0,1,1}
}

asl={
	{1,1,0},
	{0,1,1}
}

asr={
	{0,1,1},
	{1,1,0}
}

aline={
	{0,1,0},
	{0,1,0},
	{0,1,0},
	{0,1,0}
}

board={
	{2,0,0,0,0,0,0,0,0,0,0,0,0,2},
}
__gfx__
00000000066666610ffffff407777772077777730000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006cccccc1f99999947eeeeee27bbbbbb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007006cccccc1f99999947eeeeee27bbbbbb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770006cccccc1f99999947eeeeee27bbbbbb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770006cccccc1f99999947eeeeee27bbbbbb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007006cccccc1f99999947eeeeee27bbbbbb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000006cccccc1f99999947eeeeee27bbbbbb30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000111111104444444022222220333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
