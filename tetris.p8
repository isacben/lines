pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
function _init()
	t=0
	spd=10
	vel=8
	piece_x=48 --center of 96
	piece_y=0
	
	p_names={"block","tee"}
	pce_squares={}
	current_pce={}
	squares={}
	
	acurr=ael
	generate(acurr,2)
	
	debug="..."
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
	if on_floor() then
		generate(atee,4)
	end
	
	if t%spd == 0 then
		current_pce.y+=vel
		
		for square in all(pce_squares) do
			square.y+=vel
		end
	end
end

function move()
	local move=8
	local cx=current_pce.x
	local cw=current_pce.w
	
	if btnp(0) then
		if cx<=0 then
			move=0
		end
		
		for cs in all(pce_squares) do
			for s in all(squares) do
				if cs.y==s.y then
					if cs.x == s.x+8 then 
						move=0
					end
				end
			end
		end
		
		current_pce.x-=move
		for s in all(pce_squares) do
			s.x-=move
		end
	end
	
	if btnp(1) then
		if cx+cw>=96 then
			move=0
		end
		
		for cs in all(pce_squares) do
			for s in all(squares) do
				if cs.y==s.y then
					if cs.x+8 == s.x then 
						move=0
					end
				end
			end
		end
	
		current_pce.x+=move
		for s in all(pce_squares) do
			s.x+=move
		end
	end
	
	if btnp(2) then
		rotate(acurr)
	end
	
	--debug=cx..","..cx+cw..","..move
end

function on_floor()
	local cy=current_pce.y
	local ch=current_pce.h
	
	if cy+ch>=120 then	
		stop_pce()
		return true
	else
		for cp_sqr in all(pce_squares) do
			for sqr in all(squares) do
				if cp_sqr.y+8 == sqr.y and
					cp_sqr.x == sqr.x then
					stop_pce()
					return true
				end
			end
		end
	end
	--debug="on floor"
end

function collision(a,b)
	if a.y>b.y then
		return true
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
	init_current_pce()
	
	for row=1,#arr do
		for col=1,#arr do
			if arr[row][col]==1 then
				local s={}
				s.x=piece_x+(col-1)*8
				current_pce.w=col*8
				
				s.y=piece_y+(row-1)*8
				current_pce.h=row*8
				
				s.spr=_spr
				add(pce_squares,s)
			end
		end
	end
	
	debug=current_pce.w..","..current_pce.h
end
-->8
--general

function init_current_pce()
	current_pce.x=piece_x
	current_pce.y=piece_y
	current_pce.w=0
	current_pce.h=0
end

function rotate(arr)
	
	local temp={
		{0,0,0},
		{0,0,0},
		{0,0,0}
	}
	
	local n=4
	for r=1,3 do
		for c=1,3 do
			temp[c][n-r]=arr[r][c]
		end
	end
	pce_squares={}
	acurr=temp
	
	generate(acurr,3)
end
-->8
--arrays

acurr={
	{0,0,0},
	{0,0,0},
	{0,0,0}
}

ablock={
	{1,1,0},
	{1,1,0};
	{0,0,0}
}

atee={
	{0,1,0},
	{1,1,1},
	{0,0,0}
}

ael={
	{1,0,0},
	{1,0,0},
	{1,1,0}
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
