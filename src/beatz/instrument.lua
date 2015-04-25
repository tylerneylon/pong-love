--[[ beatz/instrument.lua

A class to capture a single instrument.

On disk, an instrument is a set of sound files kept together in a single subdir
of the instruments dir.

TODO Clarify actual usage.

Projected usage:

  -- This is to load audio files in the dir instruments/my_drumkit.
  instrument = require 'instrument'
  drums = instrument.load('my_drumkit')
  drums:play('a')

--]]

require 'strict'  -- Enforce careful global variable usage.

local dir     = require 'beatz.dir'
local rsounds = require 'beatz.rsounds'


local instrument = {}

-------------------------------------------------------------------------------
-- Internal variables and functions.
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Class interface.
-------------------------------------------------------------------------------

local Instrument = {}

function Instrument:new()
  local new_inst = {sounds = {}}
  return setmetatable(new_inst, {__index = self})
end

function Instrument:play(name)
  self.sounds[name]:play()
end


-------------------------------------------------------------------------------
-- Public functions.
-------------------------------------------------------------------------------

function instrument.load(inst_name)
  local inst = Instrument:new()

  local dir_path = 'instruments/' .. inst_name
  local wav_pattern = '(.*)%.wav$'
  for filename in dir.open(dir_path) do
    local name = filename:match(wav_pattern)
    if name then
      local file_path = dir_path .. '/' .. filename
      inst.sounds[name] = rsounds.load(file_path, 20)
    end
  end

  return inst
end


return instrument
