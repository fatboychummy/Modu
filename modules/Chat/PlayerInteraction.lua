--[[FATFILE
1
https://raw.githubusercontent.com/fatboychummy/Modu/Master/modules/Chat/PlayerInteraction.lua

This module controls how the machine speaks to the player
]]

local funcs = {}
local listenFor = "chat_message"
local player = ""
local manip = false

function funcs.tell(info)
  if type(info) ~= "string" then
    error("Expected string, got " .. type(info), 2)
  end

  local strings = {}
  if #info > 100 then
    -- if the length of the string is too long, split it into multiple strings
    for i = 1, #info / 100 + 1 do
      strings[i] = info:sub(i*100 - 99, i*100)
    end
  else
    strings[1] = info
  end

  -- tell the player each string
  for i = 1, #strings do
    manip.tell(strings[i])
  end
end

function funcs.help()
  return false
end

function funcs.init(data)
  data = data or false
  if not data then
    return false, "No data given to init!"
  end
  -- handle the owner
  player = data.owner or false
  if not player then
    return false, "Owner not specified (edit InitData and change or add variable 'owner'!)."
  end


  -- handle the manipulator
  manip = {peripheral.find("manipulator")}

  if #manip > 1 then
    return false, "Too many manipulators connected to the network. This program currently will not support multiple manipulators."
  elseif #manip == 0 then
    return false, "No manipulator (or manipulator has no modules)!"
  else
    manip = manip[1]
  end

  -- handle the manipulator modules
  local modules = manip.listModules()

  for i = 1, #modules do
    if modules[i] == "plethora:chat"
      or modules[i] == "plethora:chat_creative" then
      return true
    end
  end

  return false, "No chat recorder present."
end


return funcs
