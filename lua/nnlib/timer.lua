-- This file is part of nnlib which is released under MIT License.
-- See file LICENSE or go to https://github.com/xoderton/nnlib/blob/main/LICENSE for full license details.

timer.Paused = timer.Paused or {}

timer.OldPause = timer.OldPause or timer.Pause
function timer.Pause(identifier)
  timer.Paused[identifier] = true
  hook.Run("nnlib.timer.pause", identifier)
  timer.OldPause(identifier)
end

timer.OldUnPause = timer.OldUnPause or timer.UnPause
function timer.UnPause(identifier)
  timer.Paused[identifier] = false
  hook.Run("nnlib.timer.unpause", identifier)
  timer.OldUnPause(identifier)
end

function timer.Status(identifier)
  return timer.Paused[identifier] or false
end