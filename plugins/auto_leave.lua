--[[
Kicking ourself (bot) from unmanaged groups.
When someone invited this bot to a group,  the bot will exit immediately by kicking itself out of that group.
No switch available. You need to turn it on or off using !plugins command.
--]]

-- suppress '*** lua: attempt to call a nil value' warning
local function callback(extra, success, result)
  vardump(success)
  vardump(result)
end

local function run(msg)
  if msg.service and msg.action.type == 'chat_add_user' then
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)] then
      print "This is not our group. Leaving..."
      chat_del_user('chat#id'..msg.to.id, 'user#id'..167946378, callback, false)
    end
  end
end

return {
  description = "Kicking ourself (bot) from unmanaged groups.",
  usage = "Plugin For Kiling add with id ....",
  patterns = {
    "^!!tgservice (.+)$"
  },
  run = run
}
