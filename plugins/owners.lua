
local function lock_group_namemod(msg, data, target)
  local group_name_set = data[tostring(target)]['settings']['set_name']
  local group_name_lock = data[tostring(target)]['settings']['lock_name']
  if group_name_lock == 'yes' then
    return 'اسم گروه قفل بود'
  else
    data[tostring(target)]['settings']['lock_name'] = 'yes'
    save_data(_config.moderation.data, data)
    rename_chat('chat#id'..target, group_name_set, ok_cb, false)
  return 'اسم گروه قفل شد'
  end
end

local function unlock_group_namemod(msg, data, target)
  local group_name_set = data[tostring(target)]['settings']['set_name']
  local group_name_lock = data[tostring(target)]['settings']['lock_name']
  if group_name_lock == 'no' then
    return 'اسم گروه قفل نشده'
  else
    data[tostring(target)]['settings']['lock_name'] = 'no'
    save_data(_config.moderation.data, data)
  return 'اسم گروه آزاد شده و همه قادر به تغییرش هستند'
  end
end

local function lock_group_floodmod(msg, data, target)
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'yes' then
    return 'اسپم قفل بود'
  else
    data[tostring(target)]['settings']['flood'] = 'yes'
    save_data(_config.moderation.data, data)
  return 'اسپم قفل شد'
  end
end

local function unlock_group_floodmod(msg, data, target)
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'no' then
    return 'اسپم قفل نبود'
  else
    data[tostring(target)]['settings']['flood'] = 'no'
    save_data(_config.moderation.data, data)
  return 'اسپم آازد شده و حساسیتی نسبت به آن قائل نخواهم بود'
  end
end

local function lock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return "فقط براي مديران"
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'yes' then
    return 'ورود به گروه از قبل قفل شده است'
  else
    data[tostring(target)]['settings']['lock_member'] = 'yes'
    save_data(_config.moderation.data, data)
  end
  return 'ورود به گروه قفل شد'
end

local function unlock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return "فقط براي مديران"
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'no' then
    return 'ورود به گروه قفل نبود'
  else
    data[tostring(target)]['settings']['lock_member'] = 'no'
    save_data(_config.moderation.data, data)
    return 'ورود اعضای جدید به گروه امکان پذیز است'
  end
end

local function unlock_group_photomod(msg, data, target)
  if not is_momod(msg) then
    return "فقط براي مديران"
  end
  local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
  if group_photo_lock == 'no' then
    return 'عکس گروه قفل نيست'
  else
    data[tostring(target)]['settings']['lock_photo'] = 'no'
    save_data(_config.moderation.data, data)
    return 'عکس گره آزاد شد'
  end
end

local function show_group_settingsmod(msg, data, target)
    local data = load_data(_config.moderation.data)
    if data[tostring(msg.to.id)] then
      if data[tostring(msg.to.id)]['settings']['flood_msg_max'] then
        NUM_MSG_MAX = tonumber(data[tostring(msg.to.id)]['settings']['flood_msg_max'])
        print('custom'..NUM_MSG_MAX)
      else 
        NUM_MSG_MAX = 5
      end
    end
    local settings = data[tostring(target)]['settings']
    local text = "تنظيمات گروه:\n قفل چت : "..settings.lock_chat.."\n قفل اسم : "..settings.lock_name.."\n قفل عکس : "..settings.lock_photo.."\n قفل تگ: "..lock_tag.."\n قفل ورود اعضا : "..settings.lock_member.."\n قفل انگليسي : "..lock_eng.."\n قفل خارج شدن : "..lock_leave.."\n قفل فحش : "..lock_badw.."\n قفل تبليغات : "..lock_link.."\n حساسيت اسپم : "..NUM_MSG_MAX.."\n حفاظت از ربات ها : "..bots_protection--"\nPublic: "..public
    return text
end

local function set_rules(target, rules)
  local data = load_data(_config.moderation.data)
  local data_cat = 'rules'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
  return 'تنظیم قوانین به:\n'..rules
end

local function set_description(target, about)
  local data = load_data(_config.moderation.data)
  local data_cat = 'description'
  data[tostring(target)][data_cat] = about
  save_data(_config.moderation.data, data)
  return 'تنظیم توضیحات به:\n'..about
end

local function run(msg, matches)
  if msg.to.type ~= 'group' then
    local chat_id = matches[1]
    local receiver = get_receiver(msg)
    local data = load_data(_config.moderation.data)
    if matches[2] == 'محروم' then
      local chat_id = matches[1]
      if not is_owner2(msg.from.id, chat_id) then
        return "سازنده ی گروه نیستید"
      end
      if tonumber(matches[3]) == tonumber(our_id) then return false end
      local user_id = matches[3]
      if tonumber(matches[3]) == tonumber(msg.from.id) then 
        return "شما نمیتوانید خودتان را محروم کنید"
      end
      ban_user(matches[3], matches[1])
      local name = user_print_name(msg.from)
      savelog(matches[1], name.." ["..msg.from.id.."] بن کرد ".. matches[3])
      return 'کاربره '..user_id..' بن شد'
    end
    if matches[2] == 'آنبن' then
    if tonumber(matches[3]) == tonumber(our_id) then return false end
      local chat_id = matches[1]
      if not is_owner2(msg.from.id, chat_id) then
        return "شما سازنده ی گروه نیستید"
      end
      local user_id = matches[3]
      if tonumber(matches[3]) == tonumber(msg.from.id) then 
        return "شما نمیتوانید خودتان را بن کنید"
      end
      local hash =  'banned:'..matches[1]
      redis:srem(hash, user_id)
      local name = user_print_name(msg.from)
      savelog(matches[1], name.." ["..msg.from.id.."] کاربر را صلب محرومیت کرد ".. matches[3])
      return 'کاربر '..user_id..' صلب محروم شد'
    end
    if matches[2] == 'اخراج' then
      local chat_id = matches[1]
      if not is_owner2(msg.from.id, chat_id) then
        return "شما سازنده ی گروه نیستید"
      end
      if tonumber(matches[3]) == tonumber(our_id) then return false end
      local user_id = matches[3]
      if tonumber(matches[3]) == tonumber(msg.from.id) then 
        return "شما فادر به حذف کردن خودتون نیستید"
      end
      kick_user(matches[3], matches[1])
      local name = user_print_name(msg.from)
      savelog(matches[1], name.." ["..msg.from.id.."] کاربر را اخراج کرد ".. matches[3])
      return 'کاربره '..user_id..' حذف شد'
    end
    if matches[2] == 'پاک کردن' then
      if matches[3] == 'لیست مدیران' then
        if not is_owner2(msg.from.id, chat_id) then
          return "شما سازنده ی گروه نیستید"
        end
        for k,v in pairs(data[tostring(matches[1])]['moderators']) do
          data[tostring(matches[1])]['moderators'][tostring(k)] = nil
          save_data(_config.moderation.data, data)
        end
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] لیست مدیران را پاک کرد")
      end
      if matches[3] == 'قوانین' then
        if not is_owner2(msg.from.id, chat_id) then
          return "شما سازنده ی این گروه نیستید"
        end
        local data_cat = 'rules'
        data[tostring(matches[1])][data_cat] = nil
        save_data(_config.moderation.data, data)
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] قوانین را پاک کرد")
      end
      if matches[3] == 'توضیحات' then
        if not is_owner2(msg.from.id, chat_id) then
          return "شما سازنده ی گروه نیستید"
        end
        local data_cat = 'description'
        data[tostring(matches[1])][data_cat] = nil
        save_data(_config.moderation.data, data)
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] توضیحات گروه را پاک کرد")
      end
    end
    if matches[2] == "حساسیت" then
      if not is_owner2(msg.from.id, chat_id) then
        return "شما سازنده ی گروه نیستید"
      end
      if tonumber(matches[5]) < 5 or tonumber(matches[5]) > 20 then
        return "عدد اشتباه !! محدوده اسپم بين 5 تا 30 هست"
      end
      local flood_max = matches[3]
      data[tostring(matches[1])]['settings']['flood_msg_max'] = flood_max
      save_data(_config.moderation.data, data)
      local name = user_print_name(msg.from)
      savelog(matches[1], name.." ["..msg.from.id.."] تنظیم کرد میزان اسپم را به ["..matches[3].."]")
      return 'میزان اسپم تغییر یافت به '..matches[3]
    end
    if matches[2] == 'قفل' then
      if not is_owner2(msg.from.id, chat_id) then
        return "شما سازنده ی گروه نیستید"
      end
      local target = matches[1]
      if matches[3] == 'اسم' then
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] اسم قفل شد ")
        return lock_group_namemod(msg, data, target)
      end
      if matches[3] == 'اعضا' then
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] اعضا قفل شد ")
        return lock_group_membermod(msg, data, target)
      end
    end
    if matches[2] == 'باز کردن' then
      if not is_owner2(msg.from.id, chat_id) then
        return "شما سازنده ی این گروه نیستید"
      end
      local target = matches[1]
      if matches[3] == 'اسم' then
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] اسم قفل نشد ")
        return unlock_group_namemod(msg, data, target)
      end
      if matches[3] == 'اعضا' then
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] اعضا قفل نشد ")
        return unlock_group_membermod(msg, data, target)
      end
    end
    if matches[2] == 'لینک' then
      if matches[3] == 'جدید' then
        if not is_owner2(msg.from.id, chat_id) then
          return "شما سازنده ی گروه نیستید"
        end
        local function callback (extra , success, result)
          local receiver = 'chat#'..matches[1]
          vardump(result)
          data[tostring(matches[1])]['settings']['set_link'] = result
          save_data(_config.moderation.data, data)
          return 
        end
        local receiver = 'chat#'..matches[1]
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] لینک گروه را عوض کرد ")
        export_chat_link(receiver, callback, true)
        return "لینک جدیدی ساخته شد . سازنده میتوان بگیردش با /owner "..matches[1].." گرفتن لینک"
      end
    end
    if matches[2] == 'لینک' then 
      if matches[3] == 'بگیر' then
        if not is_owner2(msg.from.id, chat_id) then
          return "شما سازندهی گروه نیستید"
        end
        local group_link = data[tostring(matches[1])]['settings']['set_link']
        if not group_link then 
          return "با دستور جدید لینک ابتدا لینک تازه بسازید"
        end
        local name = user_print_name(msg.from)
        savelog(matches[1], name.." ["..msg.from.id.."] درخواست لینک کرد ["..group_link.."]")
        return "لینک گروه:\n"..group_link
      end
    end
    if matches[1] == 'تنظیم توضیحات' and matches[2] and is_owner2(msg.from.id, matches[2]) then
      local target = matches[2]
      local about = matches[3]
      local name = user_print_name(msg.from)
      savelog(matches[2], name.." ["..msg.from.id.."] توضیحات گروه را عوض کرد به ["..matches[3].."]")
      return set_description(target, about)
    end
    if matches[1] == 'تنظیم قوانین' and is_owner2(msg.from.id, matches[2]) then
      local rules = matches[3]
      local target = matches[2]
      local name = user_print_name(msg.from)
      savelog(matches[2], name.." ["..msg.from.id.."] قوانین گروه را عوض کرد به ["..matches[3].."]")
      return set_rules(target, rules)
    end
    if matches[1] == 'نصب اسم' and is_owner2(msg.from.id, matches[2]) then
      local new_name = string.gsub(matches[3], '_', ' ')
      data[tostring(matches[2])]['settings']['set_name'] = new_name
      save_data(_config.moderation.data, data)
      local group_name_set = data[tostring(matches[2])]['settings']['set_name']
      local to_rename = 'chat#id'..matches[2]
      local name = user_print_name(msg.from)
      savelog(matches[2], " اسم گروه {} عوض شد به [ "..new_name.." ] توسط "..name.." ["..msg.from.id.."]")
      rename_chat(to_rename, group_name_set, ok_cb, false)
    end
    if matches[1] == 'تاریخچه گروه' and matches[2] and is_owner2(msg.from.id, matches[2]) then
      savelog(matches[2], "------")
      send_document("user#id".. msg.from.id,"./groups/logs/"..matches[2].."log.txt", ok_cb, false)
    end
  end
end
return {
  patterns = {
    "^(سازنده) (%d+) ([^%s]+) (.*)$",
    "^(سازنده) (%d+) ([^%s]+)$",
    "^(تنظیم توضیحات) (%d+) (.*)$",
    "^(تنظیم قوانین) (%d+) (.*)$",
    "^(نصب اسم) (%d+) (.*)$",
		"^(تاریخچه گروه) (%d+)$"
  },
  run = run
}
