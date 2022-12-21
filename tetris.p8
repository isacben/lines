pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
function _init()
	t=0
	spd=20
	piece_x=48 --center of 96
	piece_y=0
	
	pce_squares={}
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
-->8
-- move & collisions

function down()
	
	for square in all(pce_squares) do
		if t%spd == 0 then
			square.y+=8
		end
	
		if on_floor(square) then
			square.y=120
		end
	end
end

function move()
	for square in all(pce_squares) do
		if btnp(0) then
			square.x-=8
		end
	
		if btnp(1) then
			square.x+=8
		end
	end
end

function on_floor(square)
	if square.y>=120 then
		for s in all(pce_squares) do
			add(squares,s)
		end
		
		pce_squares={}
		debug="on floor"
		return true
	else
		return false
	end
end

function collided(a,b)
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
	s2.x=piece_x+8
	s2.y=piece_y
	s2.spr=1
	add(pce_squares,s2)
	
	local s3={}
	s3.x=piece_x
	s3.y=piece_y+8
	s3.spr=1
	add(pce_squares,s3)
	
	local s4={}
	s4.x=piece_x+8
	s4.y=piece_y+8
	s4.spr=1
	add(pce_squares,s4)
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
	
	debug=piece_x..","..piece_y
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
