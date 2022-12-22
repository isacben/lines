pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
function _init()
	t=0
	spd=20
	vel=8
	piece_x=0 --center of 96
	piece_y=0
	
	p_names={"block","tee"}
	pce_squares={}
	current_pce={}
	squares={}
	
	init_current_pce()
	generate(aline,2,8,32)
	
	--debug="..."
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
		init_current_pce()
		generate(atee,4,3,2)
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
	
	--move left
	if btnp(0) then
		--if cx<=0 then
		--	move=0
		--end
		
		for cs in all(pce_squares) do
			for s in all(squares) do
				if cs.y==s.y then
					if cs.x == s.x+8 then 
						move=0
					end
				end
			end
			
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
		--if cx+cw>=96 then
		--	move=0
		--end
		
		for cs in all(pce_squares) do
			for s in all(squares) do
				if cs.y==s.y then
					if cs.x+8 == s.x then 
						move=0
					end
				end
			end
			
			if cs.x+8>=96 then
				move=0
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
	
	--debug=cx..","..current_pce.y..","..cw
	--debug=current_pce.x
end

function on_floor()
	local cy=current_pce.y
	local ch=current_pce.h
	
	--if cy+ch>=120 then	
	--	stop_pce()
	--	return true
	--else
	for cp_sqr in all(pce_squares) do
		for sqr in all(squares) do
			if cp_sqr.y+8 == sqr.y and
				cp_sqr.x == sqr.x then
				stop_pce()
				return true
			end
		end
		
		if cp_sqr.y+8>=120 then
			stop_pce()
			return true
		end
	end
	--end
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

function generate(arr,_spr,w,h)
	--init_current_pce()
	acurr=arr
	
	current_pce.w=w
	current_pce.h=h
	
	for row=1,#arr do
		for col=1,#arr do
			if arr[row][col]==1 then
				local s={}
				s.x=current_pce.x+(col-1)*8
				--current_pce.w=col*8
				
				s.y=current_pce.y+(row-1)*8
				--current_pce.h=row*8
				
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

function rotate(arr)
	local temp={}
	
	for row=1,#arr do
		temp[row]={}
		for col=1,#arr do
			temp[row][col]=0
		end
	end
	
	local n=#arr+1
	for r=1,#arr do
		for c=1,#arr do
			temp[c][n-r]=arr[r][c]
		end
	end
	pce_squares={}
	acurr=temp
	
	generate(acurr,3,current_pce.h,current_pce.w)
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
-->8
--arrays

acurr={}

ablock={
	{1,1},
	{1,1}
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

aline={
	{1,0,0,0},
	{1,0,0,0},
	{1,0,0,0},
	{1,0,0,0}
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
