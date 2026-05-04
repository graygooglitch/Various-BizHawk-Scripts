-- Clash at Demonhead LiveSplit Auto-Splitter
-- by GrayGooGlitch, Based on Trysdyn's Cool Spot Splitter script

activesplit=0
running=0


local function init_livesplit()
    pipe_handle = io.open("//./pipe/LiveSplit", 'a')

    if not pipe_handle then
        error("\nFailed to open LiveSplit named pipe!\n" ..
              "Please make sure LiveSplit is running and is at least 1.7, " ..
              "then load this script again")
    end

    pipe_handle:write("reset\r\n")
    pipe_handle:flush()
	running = 0
	activesplit = 0
	print("LiveSplit Initialized")
    return pipe_handle
end

pipe_handle = init_livesplit()

function callsplit()
	pipe_handle:write("split\r\n")
    pipe_handle:flush()
	print("Split "..activesplit)
	activesplit=activesplit+1
end

function checkforsplit()
	flags = memory.read_bytes_as_array(0x057A, 10) 
	if activesplit==1 then 
		--Ghaz
		if flags[3] & 128 > 0 then callsplit() end
	elseif activesplit==2 then 
		--Fairy
		if flags[7] & 1 > 0 then callsplit() end
	elseif activesplit==3 then 
		--Rowdy
		if flags[5] & 32 > 0 then callsplit() end
	elseif activesplit==4 then 
		--Max
		if flags[3] & 32 > 0 then callsplit() end
	elseif activesplit==5 then 
		--Shark
		if flags[3] & 2 > 0 then callsplit() end
	elseif activesplit==6 then 
		--Mush
		if flags[3] & 8 > 0 then callsplit() end
	elseif activesplit==7 then 
		--Gem
		if memory.readbyte(0x04F3)==1 then callsplit() end
	elseif activesplit==8 then
		--Demon Door
		if flags[5] & 1 > 0 then callsplit() end
	elseif activesplit==9 then 
		--Apollo
		if memory.readbyte(0x04F4)==1 then callsplit() end
	elseif activesplit==10 then 
		--Bopper 1
		if flags[4] & 32 > 0 then callsplit() end
	elseif activesplit==11 then 
		--Demon
		if flags[6] & 128 > 0 then callsplit() end
	elseif activesplit==12 then 
		--Bopper 2
		if flags[4] & 8 > 0 then callsplit() end
	elseif activesplit==13 then 
		--Michael
		if flags[1] & 64 > 0 then callsplit() end
	end

end

while true do
	menu = memory.readbyte(0x020B)
	if menu==0 and running==1 then
		pipe_handle:write("reset\r\n")
    	pipe_handle:flush()
		running = 0
		activesplit = 0
		print("LiveSplit Reset")
	elseif menu==248 and running==0 then
		print("Menu: "..menu)
		print("Running: "..running)
		gui.cleartext() 
		running = 1
		activesplit = 1
		pipe_handle:write("starttimer\r\n")
        pipe_handle:flush()
		print("LiveSplit Started")
		gui.pixelText(32, 210, "",'#FFFFFF','#000000',1)
	end
	if running==1 then 
		checkforsplit() 
	end
	-- Code here will run once when the script is loaded, then after each emulated frame.
	emu.frameadvance();
end
