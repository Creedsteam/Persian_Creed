
local function callback(extra, success, result)
  vardump(success)
  vardump(result)
end

local function run(msg)
  if msg.service and msg.action.type == 'chat_add_user' then
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)] then
      print "ین گروه متعلق به گروه های بنده نمیباشد . بای ..."
      chat_del_user('chat#id'..msg.to.id, 'user#id'..our_id, callback, false)
    end
  end
end

return {
  description = "Kicking ourself (bot) from unmanaged groups.",
  usage = "No switch available. Turn it on or off using !plugins command.",
  patterns = {
    "^!!tgservice (.+)$"
  },
  run = run
}
