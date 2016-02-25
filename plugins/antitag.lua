local function run(msg)

    local data = load_data(_config.moderation.data)

     if data[tostring(msg.to.id)]['settings']['lock_tag'] == 'yes' then


if not is_momod(msg) then


chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
    local msgtag = 'تگ کردن در این گروه غیر مجاز است بنابر این اخراج میشوید '
   local receiver = msg.to.id
    send_large_msg('chat#id'..receiver, msgads.."\n", ok_cb, false)

      end
   end
end

return {patterns = {
"#(.*)",
"@(.*)",
}, run = run}

