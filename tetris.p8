pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
function _init()
	t=0
	spd=20
	vel=8
	piece_x=48 --center of 96
	piece_y=0
	
	p_names={"block","tee"}
	pce_squares={}
	current_pce={}
	squares={}
	
	tee()
	
	debug="debug"
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
		rect(
			square.x,
			square.y,
			square.x+8,
			square.y+8,
			9)
	end
	
	for square in all(squares) do
		rect(
			square.x,
			square.y,
			square.x+8,
			square.y+8,
			9)
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
		
		for square in all(pce_squares) do
			square.y+=vel
		end
	end
	
	if on_floor() then
		spawn("block")
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
		
		current_pce.x-=move
		for s in all(pce_squares) do
			s.x-=move
		end
	end
	
	if btnp(1) then
		if cx+cw>=96 then
			move=0
		end
	
		current_pce.x+=move
		for s in all(pce_squares) do
			s.x+=move
		end
	end
	
	debug=cx..","..cx+cw..","..move
end

function on_floor()
	local cy=current_pce.y
	local ch=current_pce.h
	
	if cy+ch>=120 then
		for s in all(pce_squares) do
			add(squares,s)
		end
		
		pce_squares={}
		return true
	end
	--debug="on floor"
end

function collision(a,b)
	if a.y>b.y then
		return true
	end
end
-->8
-- pieces

function block()
	local s1={}
	s1.x=piece_x
	s1.y=piece_y
	s1.spr=1
	add(pce_squares,s1)
	
	local s2={}
	s2.x=s1.x+8
	s2.y=s1.y
	s2.spr=1
	add(pce_squares,s2)
	
	local s3={}
	s3.x=s1.x
	s3.y=s1.y+8
	s3.spr=1
	add(pce_squares,s3)
	
	local s4={}
	s4.x=s1.x+8
	s4.y=s1.y+8
	s4.spr=1
	add(pce_squares,s4)
	
	current_pce.x=piece_x
	current_pce.y=piece_y
	current_pce.w=16
	current_pce.h=16
end

function tee()
	local s1={}
	s1.x=piece_x
	s1.y=piece_y
	s1.spr=2
	add(pce_squares,s1)
	
	local s2={}
	s2.x=piece_x-8
	s2.y=piece_y+8
	s2.spr=2
	add(pce_squares,s2)
	
	local s3={}
	s3.x=piece_x
	s3.y=piece_y+8
	s3.spr=2
	add(pce_squares,s3)
	
	local s4={}
	s4.x=piece_x+8
	s4.y=piece_y+8
	s4.spr=2
	add(pce_squares,s4)
	
	current_pce.x=piece_x-8
	current_pce.y=piece_y
	current_pce.w=24
	current_pce.h=16
end
-->8
--general

function spawn(p_name)
	block()
end
__gfx__
00000000000000009999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000cccccc09000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000cccccc09000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000cccccc09000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000cccccc09000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000cccccc09000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000cccccc09000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000009999999900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
