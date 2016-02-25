do
data = load_data(_config.moderation.data)
local function get_msgs_user_chat(user_id, chat_id)
  local user_info = {}
  local uhash = 'user:'..user_id
  local user = redis:hgetall(uhash)
  local um_hash = 'msgs:'..user_id..':'..chat_id
  user_info.msgs = tonumber(redis:get(um_hash) or 0)
  user_info.name = user_print_name(user)..' ['..user_id..']'
  return user_info
end
local function chat_stats(chat_id)
  local hash = 'chat:'..chat_id..':users'
  local users = redis:smembers(hash)
  local users_info = {}
  for i = 1, #users do
    local user_id = users[i]
    local user_info = get_msgs_user_chat(user_id, chat_id)
    table.insert(users_info, user_info)
  end
  table.sort(users_info, function(a, b) 
      if a.msgs and b.msgs then
        return a.msgs > b.msgs
      end
    end)
  local text = 'آمار گروه:\n'
  for k,user in pairs(users_info) do
    text = text..user.name..' = '..user.msgs..'\n'
  end
  return text
end

local function get_group_type(target)
  local data = load_data(_config.moderation.data)
  local group_type = data[tostring(target)]['group_type']
    if not group_type or group_type == nil then
       return 'هیچ نقشی برای گروه موجود نیست.'
    end
      return group_type
end
local function show_group_settings(target)
  local data = load_data(_config.moderation.data)
  if data[tostring(target)] then
    if data[tostring(target)]['settings']['flood_msg_max'] then
      NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['flood_msg_max'])
      print('custom'..NUM_MSG_MAX)
    else 
      NUM_MSG_MAX = 5
    end
  end
  local settings = data[tostring(target)]['settings']
  local text = "تنظیمات گروه :\n💡قفل اسم گروه : "..settings.lock_name.."\n💡قفل عکس گروه : "..settings.lock_photo.."\n💡قفل تگ کردن در گروه : "..lock_tag.."\n💡قفل ورود اعضا : "..settings.lock_member.."\n💡قفل انگلیسی .. : "..lock_eng.."\n 💡محروم ترک کنندگان : "..lock_leave.."\n💡قفل فحش دادن : "..lock_badw.."\n💡قفل تبلیغات در گروه : "..lock_link.."\n💡قفل استیکر در گروه : "..lock_sticker.."\n💡حساسیت به اسپم : "..NUM_MSG_MAX.."\n💡حفاظت در برابر ربات ها : "..bots_protection--"\nPublic: "..public
  return text
end

local function get_description(target)
  local data = load_data(_config.moderation.data)
  local data_cat = 'description'
  if not data[tostring(target)][data_cat] then
    return 'هیچ توضیحاتی وجود ندارد'
  end
  local about = data[tostring(target)][data_cat]
  return about
end

local function get_rules(target)
  local data = load_data(_config.moderation.data)
  local data_cat = 'rules'
  if not data[tostring(target)][data_cat] then
    return 'هیچ قانونی تنظیم نشده است.'
  end
  local rules = data[tostring(target)][data_cat]
  return rules
end


local function modlist(target)
  local data = load_data(_config.moderation.data)
  local groups = 'groups'
  if not data[tostring(groups)] or not data[tostring(groups)][tostring(target)] then
    return 'گروه اضافه نشده است یا ریلم است . '
  end
  if next(data[tostring(target)]['moderators']) == nil then
    return 'هیچ مدیری در این گروه نیست.'
  end
  local i = 1
  local message = '\nلیست مدیران این گروه عبارتند از :\n'
  for k,v in pairs(data[tostring(target)]['moderators']) do
    message = message ..i..' - @'..v..' [' ..k.. '] \n'
    i = i + 1
  end
  return message
end

local function get_link(target)
  local data = load_data(_config.moderation.data)
  local group_link = data[tostring(target)]['settings']['set_link']
  if not group_link or group_link == nil then 
    return "لینکی وجود ندارد"
  end
  return "لینک گروه عبارت است از:\n"..group_link
end

local function all(target, receiver)
  local text = "همه ی اطلاعات موجود درباره ی این گروه عبارتند از \n\n"
  local group_type = get_group_type(target)
  text = text.."نقش گروه: \n"..group_type
  local settings = show_group_settings(target)
  text = text.."\n\nتنظیمات گروه: \n"..settings
  local rules = get_rules(target)
  text = text.."\n\nقوانین گروه: \n"..rules
  local description = get_description(target)
  text = text.."\n\nتوضیحات گروه: \n"..description
  local modlist = modlist(target)
  text = text.."\n\nمدیران: \n"..modlist
  local link = get_link(target)
  text = text.."\n\nلینک گروه: \n"..link
  local stats = chat_stats(target)
  text = text.."\n\n"..stats
  local ban_list = ban_list(target)
  text = text.."\n\n"..ban_list
  local file = io.open("./groups/all/"..target.."all.txt", "w")
  file:write(text)
  file:flush()
  file:close()
  send_document(receiver,"./groups/all/"..target.."all.txt", ok_cb, false)
  return
end

function run(msg, matches)
  if matches[1] == "همه چیز" and matches[2] and is_owner2(msg.from.id, matches[2]) then
    local receiver = get_receiver(msg)
    local target = matches[2]
    return all(target, receiver)
  end
  if not is_owner(msg) then
    return
  end
  if matches[1] == "همه چیز" and not matches[2] then
    local receiver = get_receiver(msg)
    if not is_owner(msg) then
      return
    end
    return all(msg.to.id, receiver)
  end
end


return {
  patterns = {
  "^(همه چیز)$",
  "^(همه چیز) (%d+)$"
  },
  run = run
}
end
