pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
function _init()
	t=0
	spd=10
	vel=8
	lwall=8
	rwall=88
	
	--start, game, over
	state="start"
	
	piece_x=32 --center of 96
	piece_y=0
	
	reset_board()
	
	p_names={"ablock","atee"}
	pce_squares={}
	buff_squares={}
	current_pce={}
	squares={}
	
	init_current_pce()
	
	--debug="tetris"
end

function _update()
	update()
end

function _draw()
	cls(6)
	t+=1
	
	draw()
	print(debug,10,2,0)
end
-->8
-- draw

function draw()
	--start screen
	if state=="start" then
		start_scr()
	
	--game screen
	elseif state=="game" then
		stage()
		paint_squares()
	end
end


function start_scr()
	cprint("press x to start",40,13)
end


function paint_squares()
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
	rectfill(96,0,128,128,5)
	
	for i=0,15 do
		spr(8,0,i*8)
		spr(8,88,i*8)
	end
	

	rectfill(96,10,128,27,6)
	rectfill(96,11,128,16,5)
	line(96,18,128,18,5)
	line(96,26,128,26,5)
	
	rectfill(99,4,123,14,6)
	rect(100,5,122,13,5)	
	print("score",102,7,5)
	local score="100"
	print(score,112-(#score*2),20,5)

		
	rectfill(99,41,123,58,6)
	rect(100,42,122,57,5)
	print("level",102,44,5)
	local level="2"
	print(level,112-(#level*2),51,5)

	rectfill(99,61,123,78,6)
	rect(100,62,122,77,5)
	print("lines",102,64,5)
	local lines="8"
	print(lines,112-(#lines*2),71,5)

	rectfill(96,87,128,119,6)
end


function cprint(s,y,c)
	print(s,64-#s*2,y,c)
end
-->8
-- move & collisions

function down()
	
	if t%spd == 0 then
		current_pce.y+=vel
		
		if on_floor() then
			stop_pce()
			init_current_pce()
			spawn()
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
			if cs.x<=lwall then
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
			if cs.x+8>=rwall then
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
				return true
			end
		end
		
		--collision with floor
		if cp_sqr.y+8>=128 then
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

function init_current_pce()
	current_pce.x=piece_x
	current_pce.y=piece_y
end


function spawn()
	current_pce.type=flr(rnd(7))+1
	generate(
		pce_type[current_pce.type],
		current_pce.type
	)
	debug="piece #:"..current_pce.type
end


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
end


function rotate(arr)
	local temp={}
	buff_squares={}
	
	--rotate into temp
	local n=#arr+1
	for col=1,#arr[1] do
		temp[col]={}
		for row=1,#arr do
			temp[col][n-row]=arr[row][col]
		end
	end
	
	--add to buffer
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
	
	--check overlaping
	for bs in all(buff_squares) do
		if bs.x<lwall or
			bs.x>=rwall or
			bs.y>=128 then
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
	generate(acurr,current_pce.type)
end
-->8
--update

function update()
	--start screen
	if state=="start" then
		if btnp(5) then
			spawn()
			state="game"
		end
	
	--game screen
	elseif state=="game" then
		down()
		move()
	end
end


function reset_board()
	for row=1,12 do
		board[row]={}
		for col=1,13 do
			board[row][col]=0
		end
	end
end
-->8
--arrays

acurr={}

pce_type={
	ablock,
	atee,
	aell,
	aelr,
	asl,
	asr,
	aline,
}

ablock={
	{1,1},
	{1,1}
}

atee={
	{0,1,0},
	{1,1,1},
	{0,0,0}
}

aell={
	{0,1,0},
	{0,1,0},
	{0,1,1}
}

aelr={
	{0,1,0},
	{0,1,0},
	{1,1,0}
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

pce_type={
	ablock,
	atee,
	aell,
	aelr,
	asl,
	asr,
	aline,
}

board={}
__gfx__
0000000055555555555555555555555555555555555555555555555555555555d56dd56d00000000000000000000000000000000000000000000000000000000
000000005dddddd55dddddd55dddddd5566666655dddddd55dddddd556666665d5ddd5dd00000000000000000000000000000000000000000000000000000000
007007005d5555d55d6666d55dddddd5565555655dddddd55d5555d556555565d5ddd5dd00000000000000000000000000000000000000000000000000000000
000770005d5665d55d6dd5d55dd55dd5565555655dddddd55d5dd6d5565dd5655555555500000000000000000000000000000000000000000000000000000000
000770005d5665d55d6dd5d55dd55dd5565555655dddddd55d5dd6d5565dd5656dd56dd500000000000000000000000000000000000000000000000000000000
007007005d5555d55d5555d55dddddd5565555655dddddd55d6666d556555565ddd5ddd500000000000000000000000000000000000000000000000000000000
000000005dddddd55dddddd55dddddd5566666655dddddd55dddddd556666665ddd5ddd500000000000000000000000000000000000000000000000000000000
00000000555555555555555555555555555555555555555555555555555555555555555500000000000000000000000000000000000000000000000000000000
