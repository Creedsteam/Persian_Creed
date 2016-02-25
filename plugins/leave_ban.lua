local function run(msg, matches)
  local data = load_data(_config.moderation.data)
   if msg.action and msg.action.type then
   local action = msg.action.type 
    if data[tostring(msg.to.id)] then
      if data[tostring(msg.to.id)]['settings'] then
        if data[tostring(msg.to.id)]['settings']['adds_ban'] then 
          leave_ban = data[tostring(msg.to.id)]['settings']['adds_ban']
        end
      end
    end
   if action == 'chat_del_user' and not is_momod2(msg.action.user.id) and adds_ban == 'yes' then
     	local user_id = msg.action.user.id
     	local chat_id = msg.to.id
     	ban_user(user_id, chat_id)
     end
   end
  end


return {
  patterns = {
"^!!tgservice (chat_del_user)$"

  },
  run = run
}
