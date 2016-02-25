
local function pre_process(msg)
  -- SERVICE MESSAGE
  if msg.action and msg.action.type then
    local action = msg.action.type
    -- Check if banned user joins chat by link
    if action == 'chat_add_user_link' then
      local user_id = msg.from.id
      print('درحال بررسی شخص اینوایت شده '..user_id)
      local banned = is_banned(user_id, msg.to.id)
      if banned or is_gbanned(user_id) then -- Check it with redis
      print('کاربر بن شده است')
      local name = user_print_name(msg.from)
      savelog(msg.to.id, name.." ["..msg.from.id.."] این شخص بن بود پس حذف شد ! ")-- Save to logs
      kick_user(user_id, msg.to.id)
      end
    end
    -- Check if banned user joins chat
    if action == 'chat_add_user' then
      local user_id = msg.action.user.id
      print('درحال بررسی شخص اینوایت شده '..user_id)
      local banned = is_banned(user_id, msg.to.id)
      if banned or is_gbanned(user_id) then -- Check it with redis
        print('کاربر بن شده است!')
        local name = user_print_name(msg.from)
        savelog(msg.to.id, name.." ["..msg.from.id.."] شخص بن شده را ادد کرد >"..msg.action.user.id)-- Save to logs
        kick_user(user_id, msg.to.id)
        local banhash = 'شخصی بن شده را ادد کرد:'..msg.to.id..':'..msg.from.id
        redis:incr(banhash)
        local banhash = ' شخصی بن شده را ادد کرد:'..msg.to.id..':'..msg.from.id
        local banaddredis = redis:get(banhash)
        if banaddredis then
          if tonumber(banaddredis) == 4 and not is_owner(msg) then
            kick_user(msg.from.id, msg.to.id)-- Kick user who adds ban ppl more than 3 times
          end
          if tonumber(banaddredis) ==  8 and not is_owner(msg) then
            ban_user(msg.from.id, msg.to.id)-- Kick user who adds ban ppl more than 7 times
            local banhash = 'شخص بن شده را ادد کرد:'..msg.to.id..':'..msg.from.id
            redis:set(banhash, 0)-- Reset the Counter
          end
        end
      end
     if data[tostring(msg.to.id)] then
       if data[tostring(msg.to.id)]['settings'] then
         if data[tostring(msg.to.id)]['settings']['lock_bots'] then
           bots_protection = data[tostring(msg.to.id)]['settings']['lock_bots']
          end
        end
      end
    if msg.action.user.username ~= nil then
      if string.sub(msg.action.user.username:lower(), -3) == 'bot' and not is_momod(msg) and bots_protection == "بله" then --- Will kick bots added by normal users
        local name = user_print_name(msg.from)
          savelog(msg.to.id, name.." ["..msg.from.id.."] ربات را ادد کرد > @".. msg.action.user.username)-- Save to logs
          kick_user(msg.action.user.id, msg.to.id)
      end
    end
  end
    -- No further checks
  return msg
  end
  -- banned user is talking !
  if msg.to.type == 'chat' then
    local data = load_data(_config.moderation.data)
    local group = msg.to.id
    local texttext = 'groups'
    --if not data[tostring(texttext)][tostring(msg.to.id)] and not is_realm(msg) then -- Check if this group is one of my groups or not
    --chat_del_user('chat#id'..msg.to.id,'user#id'..our_id,ok_cb,false)
    --return
    --end
    local user_id = msg.from.id
    local chat_id = msg.to.id
    local banned = is_banned(user_id, chat_id)
    if banned or is_gbanned(user_id) then -- Check it with redis
      print('شخص بن شده در حال حرف زدن هست!')
      local name = user_print_name(msg.from)
      savelog(msg.to.id, name.." ["..msg.from.id.."] شخص بن شده در حال حرف زدن هست !")-- Save to logs
      kick_user(user_id, chat_id)
      msg.text = ''
    end
  end
  return msg
end

local function kick_ban_res(extra, success, result)
--vardump(result)
--vardump(extra)
      local member_id = result.id
      local user_id = member_id
      local member = result.username
      local chat_id = extra.chat_id
      local from_id = extra.from_id
      local get_cmd = extra.get_cmd
      local receiver = "chat#id"..chat_id
       if get_cmd == "kick" then
         if member_id == from_id then
             return send_large_msg(receiver, "شما نمیتوانید خودتان را حذف کنید")
         end
         if is_momod2(member_id, chat_id) and not is_admin2(sender) then
            return send_large_msg(receiver, "شما اجازه حذف کردن مدیران و سازنده ها را ندارید")
         end
         return kick_user(member_id, chat_id)
      elseif get_cmd == 'ban' then
        if is_momod2(member_id, chat_id) and not is_admin2(sender) then
          return send_large_msg(receiver, "شما اجازه ی مسدود کردن مدیران را ندارید")
        end
        send_large_msg(receiver, 'کاربر @'..member..' ['..member_id..'] مسدود شد')
        return ban_user(member_id, chat_id)
      elseif get_cmd == 'unban' then
        send_large_msg(receiver, 'کاربر @'..member..' ['..member_id..'] صلب مسدودیت شد')
        local hash =  'بن شد:'..chat_id
        redis:srem(hash, member_id)
        return 'کاربر '..user_id..' آنبن شد'
      elseif get_cmd == 'banall' then
        send_large_msg(receiver, 'کاربر @'..member..' ['..member_id..'] از همه ی گروه ها مسدود شد ')
        return banall_user(member_id, chat_id)
      elseif get_cmd == 'unbanall' then
        send_large_msg(receiver, 'کاربر @'..member..' ['..member_id..'] از همه ی گروه ها مسدود شد ')
        return unbanall_user(member_id, chat_id)
      end
end

local function run(msg, matches)
 if matches[1]:lower() == 'ای دی' then
    if msg.to.type == "user" then
      return "آی دی ربات: "..msg.to.id.. "\n\nای دی شما: "..msg.from.id
    end
    if type(msg.reply_id) ~= "nil" then
      local name = user_print_name(msg.from)
        savelog(msg.to.id, name.." ["..msg.from.id.."] از دستور ای دی استفاده کرد ")
        id = get_message(msg.reply_id,get_message_callback_id, false)
    elseif matches[1]:lower() == 'ای دی' then
      local name = user_print_name(msg.from)
      savelog(msg.to.id, name.." ["..msg.from.id.."] از دستور ای دی استفاده کرد ")
      return "ای دی این گروه " ..string.gsub(msg.to.print_name, "_", " ").. ":\n\n"..msg.to.id
    end
  end
  if matches[1]:lower() == 'اخراجم کن' then-- /kickme
  local receiver = get_receiver(msg)
    if msg.to.type == 'chat' then
      local name = user_print_name(msg.from)
      savelog(msg.to.id, name.." ["..msg.from.id.."] با دستور اخراجم کن رفت ")-- Save to logs
      chat_del_user("chat#id"..msg.to.id, "user#id"..msg.from.id, ok_cb, false)
    end
  end

  if not is_momod(msg) then -- Ignore normal users
    return
  end

  if matches[1]:lower() == "لیست مسدودان" then -- Ban list !
    local chat_id = msg.to.id
    if matches[2] and is_admin(msg) then
      chat_id = matches[2]
    end
    return ban_list(chat_id)
  end
  if matches[1]:lower() == 'مسدود' then-- /ban
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_admin(msg) then
        local msgr = get_message(msg.reply_id,ban_by_reply_admins, false)
      else
        msgr = get_message(msg.reply_id,ban_by_reply, false)
      end
    end
      local user_id = matches[2]
      local chat_id = msg.to.id
      if string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return
        end
        if not is_admin(msg) and is_momod2(matches[2], msg.to.id) then
          	return "شما اجازه ی مسدود کردن مدیران و سازنده ها را ندارید"
        end
        if tonumber(matches[2]) == tonumber(msg.from.id) then
          	return "ما نمیتوانید خودتان را مسدود بکنید"
        end
        local name = user_print_name(msg.from)
        savelog(msg.to.id, name.." ["..msg.from.id.."] شخص را بن کرد ".. matches[2])
        ban_user(user_id, chat_id)
      else
		local cbres_extra = {
		chat_id = msg.to.id,
		get_cmd = 'ban',
		from_id = msg.from.id
		}
		local username = matches[2]
		local username = string.gsub(matches[2], '@', '')
		res_user(username, kick_ban_res, cbres_extra)
    	end
  end


  if matches[1]:lower() == 'صلب مسدود' then -- /unban
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      local msgr = get_message(msg.reply_id,unban_by_reply, false)
    end
      local user_id = matches[2]
      local chat_id = msg.to.id
      local targetuser = matches[2]
      if string.match(targetuser, '^%d+$') then
        	local user_id = targetuser
        	local hash =  'بن کرد:'..chat_id
        	redis:srem(hash, user_id)
        	local name = user_print_name(msg.from)
        	savelog(msg.to.id, name.." ["..msg.from.id.."] شخص را آنبن کرد ".. matches[2])
        	return 'کاربر '..user_id..' آن بن شد'
      else
		local cbres_extra = {
			chat_id = msg.to.id,
			get_cmd = 'unban',
			from_id = msg.from.id
		}
		local username = matches[2]
		local username = string.gsub(matches[2], '@', '')
		res_user(username, kick_ban_res, cbres_extra)
	end
 end

if matches[1]:lower() == 'اخراج' then
    if type(msg.reply_id)~="nil" and is_momod(msg) then
      if is_admin(msg) then
        local msgr = get_message(msg.reply_id,Kick_by_reply_admins, false)
      else
        msgr = get_message(msg.reply_id,Kick_by_reply, false)
      end
    end

	if string.match(matches[2], '^%d+$') then
		if tonumber(matches[2]) == tonumber(our_id) then
			return
		end
		if not is_admin(msg) and is_momod2(matches[2], msg.to.id) then
			return "شما اجازه حذف کردن مدیران و سازنده ها را ندارید"
		end
		if tonumber(matches[2]) == tonumber(msg.from.id) then
			return "شما نمیتوانید خودتان را حذف کنید"
		end
      		local user_id = matches[2]
      		local chat_id = msg.to.id
		name = user_print_name(msg.from)
		savelog(msg.to.id, name.." ["..msg.from.id.."] شخص را اخراج کرد ".. matches[2])
		kick_user(user_id, chat_id)
	else
		local cbres_extra = {
			chat_id = msg.to.id,
			get_cmd = 'kick',
			from_id = msg.from.id
		}
		local username = matches[2]
		local username = string.gsub(matches[2], '@', '')
		res_user(username, kick_ban_res, cbres_extra)
	end
end


  if not is_admin(msg) then
    return
  end

  if matches[1]:lower() == 'مسدود از همه' then -- Global ban
    if type(msg.reply_id) ~="nil" and is_admin(msg) then
      return get_message(msg.reply_id,banall_by_reply, false)
    end
    local user_id = matches[2]
    local chat_id = msg.to.id
      local targetuser = matches[2]
      if string.match(targetuser, '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
         	return false
        end
        	banall_user(targetuser)
       		return ' کاربره  ['..user_id..' ] از همه ی گروه ها مسدود شد '
      else
	local cbres_extra = {
		chat_id = msg.to.id,
		get_cmd = 'banall',
		from_id = msg.from.id
	}
		local username = matches[2]
		local username = string.gsub(matches[2], '@', '')
		res_user(username, kick_ban_res, cbres_extra)
      	end
  end
  if matches[1]:lower() == 'صلب مسدود از همه' then -- Global unban
    local user_id = matches[2]
    local chat_id = msg.to.id
      if string.match(matches[2], '^%d+$') then
        if tonumber(matches[2]) == tonumber(our_id) then
          	return false
        end
       		unbanall_user(user_id)
        	return 'کاربر ['..user_id..' ] از لیست مسدود از همه گروه ها پاک شد'
      else
	local cbres_extra = {
		chat_id = msg.to.id,
		get_cmd = 'unbanall',
		from_id = msg.from.id
	}
		local username = matches[2]
		local username = string.gsub(matches[2], '@', '')
		res_user(username, kick_ban_res, cbres_extra)
      end
  end
  if matches[1]:lower() == "لیست مسدود از همه" then -- Global ban list
    return banall_list()
  end
end

return {
  patterns = {
    "^(مسدود از همه) (.*)$",
    "^(مسدود از همه)$",
    "^(لیست مسدودان) (.*)$",
    "^(لیست مسدودان)$",
    "^(لیست مسدود از همه)$",
    "^(مسدود) (.*)$",
    "^(اخراج)$",
    "^(صلب مسدود) (.*)$",
    "^(صلب مسدود از همه) (.*)$",
    "^(صلب مسدود از همه)$",
    "^(اخراج) (.*)$",
    "^(اخراجم کن)$",
    "^(مسدود)$",
    "^(صلب مسدود)$",
    "^(ای دی)$",
    "^!!tgservice (.+)$"
  },
  run = run,
  pre_process = pre_process
}
