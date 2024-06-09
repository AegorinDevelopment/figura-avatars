local runLater = require("runLater")

-- Falls der Spieler ein Vampier ist, wird die Verwandlung sofort durchgeführt

local isVampier = false

local transformerDelay = 160

if isVampier then
    transformerDelay = 0
end

local animalAction = action_wheel:newAction()
	:title("Tier")
	:toggleTitle("Mensch")
	:item("minecraft:cod")
	:toggleItem("minecraft:player_head")
	:setOnToggle(function ()
		werdeTier()
	end)
	:setOnUntoggle(function ()
		werdeMensch()
	end)

local isTransforming = action_wheel:newAction()
	:title("Transforming...")
	:item("minecraft:end_crystal")
	:setHoverColor(0,0,0)

local mainPage = action_wheel:newPage()
local animalPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

mainPage:setAction(-1, animalAction)

animalPage:setAction(1, animalAction)

function werdeTier ()
	host:sendChatCommand("action")
	animalPage:setAction(1, isTransforming)
	action_wheel:setPage(animalPage)
	runLater(transformerDelay, function()
		animalPage:setAction(1, animalAction)
		printJson('[{"text":"Tier","color":"gold"}]') 
	end)
	
end

function werdeMensch ()
	host:sendChatCommand("action")
	animalPage:setAction(1, isTransforming)
	runLater(transformerDelay, function()
		action_wheel:setPage(mainPage)
		printJson('[{"text":"Mensch","color":"gold"}]') 
	end)
end