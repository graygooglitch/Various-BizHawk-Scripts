routes = {1,2,3,4,5,6,7,8,9,16,17,18,19,20,21,22,23,24,25,32,33,34,35,36,37,38,39,40,41,48,49,50,51,52,53,54,55,56,57,64,65,66}
clears = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
lastintersection = 0
lastroute = 1
submenu = 0
lastscore = 0
lastscoredate = "       Never"

function keyOf(tbl, value)
    for k, v in pairs(tbl) do
        if v == value then
            return k
        end
    end
    return nil
end

function toBits(num,bits)
    -- returns a table of bits, most significant first.
    bits = bits or math.max(1, select(2, math.frexp(num)))
    local t = {} -- will contain the bits        
    for b = bits, 1, -1 do
        t[b] = math.fmod(num, 2)
        num = math.floor((num - t[b]) / 2)
    end
    return t
end

function scorecalc(flags)
	score = 0

	for i,v in ipairs(clears) do score = score + v end
	if flags[3] & 128 > 0 then score = score + 4 end
	if flags[5] & 32 > 0 then score = score + 4 end
	if flags[3] & 32 > 0 then score = score + 4 end
	if flags[3] & 2 > 0 then score = score + 4 end
	if flags[3] & 8 > 0 then score = score + 4 end
	if flags[4] & 128 > 0 then score = score + 4 end
	if flags[6] & 128 > 0 then score = score + 4 end
	if flags[4] & 32 > 0 then score = score + 4 end
	if flags[4] & 8 > 0 then score = score + 4 end
	if flags[1] & 64 > 0 then score = score + 4 end
	if flags[8] & 16 > 0 then score = score + 2 end
	if memory.readbyte(0x04F3)==1 then score = score + 5 end
	if flags[5] & 1 > 0 then score = score + 3 end
	if memory.readbyte(0x04F4)==1 then score = score + 5 end
	if score>lastscore then 
		lastscore = score
		lastscoredate = os.date('!%Y-%m-%d %H:%M:%S', os.time())
	end
	return score
end

while true do
	flags = memory.read_bytes_as_array(0x057A, 10) 
	menu = memory.readbyte(0x020B)
	routenumber = memory.readbyte(0x05B8)
	intersectionnumber = memory.readbyte(0x0322)
	magicmenu = memory.readbyte(0x06E8)
	if menu==0 or menu==48 or menu==88 then
		gui.cleartext() 
    -- Route Selection Menu
		gui.pixelText(32, 210, "GrayGooGlitch Mystery Race Bizhawk Tracker: Enabled",'#FFFFFF','#000000',1)
	elseif menu==208 then
		gui.cleartext() 
    -- Route Selection Menu
		gui.pixelText(198, 5, "",'#FFFFFF','#000000',0)
	elseif menu==192 then
		gui.cleartext() 
    -- Shop Menu   
		gui.pixelText(198, 5, "" ,'#FFFFFF','#000000',0)
	elseif menu==216 or menu==200 then
		gui.cleartext() 
    -- Paused Map Menu
		pressed = memory.readbyte(0x0026)
		if pressed~=lastpressed and pressed==1 then 
			if submenu==0 then submenu=1 else submenu=0 end
		end
		lastpressed=pressed
		if submenu == 0 then
			flagtext = "Bosses\n"
			if flags[3] & 128 > 0 then flagtext = flagtext .. "Ghaz:   Dead\n" else flagtext = flagtext .. "Ghaz:   Alive\n" end
			if flags[5] & 32 > 0 then flagtext = flagtext .. "Rowdy:  Dead\n" else flagtext = flagtext .. "Rowdy:  Alive\n" end
			if flags[3] & 32 > 0 then flagtext = flagtext .. "Max:    Dead\n" else flagtext = flagtext .. "Max:    Alive\n" end
			if flags[3] & 2 > 0 then flagtext = flagtext .. "Shark:  Dead\n" else flagtext = flagtext .. "Shark:  Alive\n" end
			if flags[3] & 8 > 0 then flagtext = flagtext .. "Mush:   Dead\n" else flagtext = flagtext .. "Mush:   Alive\n" end
			if flags[4] & 128 > 0 then flagtext = flagtext .. "Pandar: Dead\n" else flagtext = flagtext .. "Pandar: Alive\n" end
			if flags[6] & 128 > 0 then flagtext = flagtext .. "Demon:  Dead\n" else flagtext = flagtext .. "Demon:  Alive\n" end
			boppertext = "Bopper: Alive\n"
			if flags[4] & 32 > 0 then boppertext = "Bopper: Escaped\n" else boppertext = boppertext end
			if flags[4] & 8 > 0 then boppertext = "Bopper: Dead\n" else boppertext = boppertext end
			flagtext = flagtext .. boppertext
			if flags[1] & 64 > 0 then flagtext = flagtext .. "Final:  Dead\n" else flagtext = flagtext .. "Final:  Alive\n" end
			flagtext = flagtext .. "\nStory\n"
			if flags[4] & 32 > 0 then boppertext = "Bopper: Escaped\n" else boppertext = boppertext end
			if flags[8] & 16 > 0 then flagtext = flagtext .. "Hermit: Freed\n" else flagtext = flagtext .. "Hermit: Captured\n" end
			if memory.readbyte(0x04F3)==1 then flagtext = flagtext .. "Gem:    Found\n" else flagtext = flagtext .. "Gem:    Hidden\n" end
			if flags[5] & 1 > 0 then flagtext = flagtext .. "Demon:  Released\n" else flagtext = flagtext .. "Demon:  Sealed\n" end
			if memory.readbyte(0x04F4)==1 then flagtext = flagtext .. "Apollo: Found\n" else flagtext = flagtext .. "Apollo: Hidden\n" end
			gui.pixelText(180, 88, flagtext ,'#FFFFFF','#000000',1)
		else
			routetracktext = ''
			routetracktext2 = ''
			routetracktext3 = ''
			for i,v in ipairs(clears) do
				cleared = 'N'
				if v == 0 then cleared='N' else cleared='Y' end
				if i<=14 then 
					if i<10 then routetracktext = routetracktext .. ' ' .. i .. ': ' .. cleared .. '\n' else routetracktext = routetracktext ..  i .. ': ' .. cleared .. '\n'end
				end 
				if i>14 and i<=28 then routetracktext2 = routetracktext2 ..  i .. ': ' .. cleared .. '\n' end
				if i>28 then routetracktext3 = routetracktext3 ..  i .. ': ' .. cleared .. '\n' end
				
    		end
			gui.pixelText(177, 88, routetracktext, '#ffffff','#000000',1)
			gui.drawLine(200, 88, 200, 185, '#ffffff') 
			gui.pixelText(203, 88, routetracktext2, '#ffffff','#000000',1)
			gui.drawLine(226, 88, 226, 185, '#ffffff') 
			gui.pixelText(229, 88, routetracktext3, '#ffffff','#000000',1)
		end
		gui.pixelText(176, 4, " Last Point Scored\n"..lastscoredate ,'#FFFFFF','#000000',1)
	elseif menu==40 then
		gui.cleartext() 
    -- Paused Map Menu
	-- Figure out flags for boss kills, and story beats
		gui.pixelText(198, 5, "",'#FFFFFF','#000000',0)
	elseif menu==248 then
		gui.cleartext() 
    	if routenumber==0  then
			gui.pixelText(196, 5, "Route " .. 1,'#FFFFFF','#000000',0)
		else
			gui.pixelText(196, 5, "Route " .. keyOf(routes,routenumber),'#FFFFFF','#000000',0)
		end
	end
	--Handle route tracking dependent on intersections
	if intersectionnumber~=lastintersection and magicmenu==0 then
		if lastroute <=0 then lastroute =1 end
		--Edge Case Management
		if lastintersection==8 and (intersectionnumber == 3 or intersectionnumber == 4) then
			--Edge Case for Hermit Path, credit 8, 6, and 35
			clears[8] = 1
			clears[6] = 1
			clears[35] = 1
		elseif (lastintersection==11 or lastintersection==21) and (intersectionnumber == 26 or intersectionnumber == 9) then
			--Edge Case for Demon Door Path, credit 33
			clears[33] = 1
		elseif (lastintersection==9 or lastintersection==27) and (intersectionnumber == 25 or intersectionnumber == 22) then
			--Edge Case for Demon Return Path, credit 38 and 39
			clears[38] = 1
			clears[39] = 1
		else
			clears[keyOf(routes,lastroute)] = 1
		end
	end
	--Not dependent on intersection edge cases
	if menu~=255 and menu~=0 and menu~=48 and menu~=88 then 
		--outside of main menu and attract mode
		--Edge Case, mark route 17 cleared when meeting the fairy
		if clears[17]==0 and flags[7] & 1 > 0 then clears[17]=1 end
		--Edge Case, mark route 32 cleared when finding Joe hurt
		if clears[32]==0 and flags[7] & 4 > 0 then clears[32]=1 end
		--Edge Case, mark route 31 cleared when getting to Pandar's Lair and talking to Fake Mary
		if clears[31]==0 and flags[8] & 1 > 0 then clears[31]=1 end
		--Edge Case, mark route 42 cleared when discovering the secret camp in the sky
		if clears[42]==0 and flags[10] & 8 > 0 then clears[42]=1 end
		--Edge Case, mark route 42 cleared when discovering the secret camp in the sky
		if clears[5]==0 and flags[6] & 1 > 0 then clears[5]=1 end
		--Edge Case, mark route 15 cleared when talking to Michael at the Well
		if clears[15]==0 and flags[8] & 7 > 0 then clears[15]=1 end
	end

	

	gui.pixelText(5, 5, "Score " .. scorecalc(flags),'#FFFFFF','#000000',0)
	lastroute=routenumber
	lastintersection=intersectionnumber
	-- Code here will run once when the script is loaded, then after each emulated frame.
	emu.frameadvance();
end