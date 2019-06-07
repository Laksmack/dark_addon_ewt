local addon, dark_addon = ...

local modifiers = { }

function modifiers:shift()
  return GetKeyState(0x10) 
end

function modifiers:control()
  return GetKeyState(0x11)  
end

function modifiers:alt()
  return GetKeyState(0x12) 
end

function modifiers:lshift()
  return GetKeyState(0xA0) 
end

function modifiers:lcontrol()
  return GetKeyState(0xA2) 
end

function modifiers:lwindows()
  return GetKeyState(0x5B) 
end

function modifiers:rwindows()
  return GetKeyState(0x5C) 
end

-- These are not in the microsoft docs. Unsure as to why ALT keys dont have left or right
-- blah blahg.    


function modifiers:lalt()
  return IsLeftAltKeyDown() and GetCurrentKeyBoardFocus() == nil
end

function modifiers:rshift()
  return GetKeyState(0xA1) 
end

function modifiers:rcontrol()
  return GetKeyState(0xA3) 
end

-- These are not in the microsoft docs. Unsure as to why ALT keys dont have left or right

function modifiers:ralt()
  return IsRightAltKeyDown() and GetCurrentKeyBoardFocus() == nil
end

dark_addon.environment.hooks.modifier = setmetatable({}, {
  __index = function(t, k)
    return modifiers[k](t)
  end
})
