do

--check Member
local function check_member_autorealm(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result.members) do
    local member_id = v.id
    if member_id ~= our_id then
      -- Group configuration
      data[tostring(msg.to.id)] = {
        group_type = 'Realm',
        settings = {
          set_name = string.gsub(msg.to.print_name, '_', ' '),
          lock_name = 'yes',
          lock_photo = 'no',
          lock_member = 'no',
          flood = 'yes'
        }
      }
      save_data(_config.moderation.data, data)
      local realms = 'realms'
      if not data[tostring(realms)] then
        data[tostring(realms)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(realms)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
      return send_large_msg(receiver, 'به ریلم ی جدیدتان خوش آمدید!')
    end
  end
end
local function check_member_realm_add(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result.members) do
    local member_id = v.id
    if member_id ~= our_id then
      -- Group configuration
      data[tostring(msg.to.id)] = {
        group_type = 'Realm',
        settings = {
          set_name = string.gsub(msg.to.print_name, '_', ' '),
          lock_name = 'yes',
          lock_photo = 'no',
          lock_member = 'no',
          flood = 'yes'
        }
      }
      save_data(_config.moderation.data, data)
      local realms = 'realms'
      if not data[tostring(realms)] then
        data[tostring(realms)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(realms)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
      return send_large_msg(receiver, 'ریلم اضافه شد')
    end
  end
end
function check_member_group(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result.members) do
    local member_id = v.id
    if member_id ~= our_id then
      -- Group configuration
      data[tostring(msg.to.id)] = {
        group_type = 'Group',
        moderators = {},
        set_owner = member_id ,
        settings = {
          set_name = string.gsub(msg.to.print_name, '_', ' '),
          lock_name = 'yes',
          lock_photo = 'no',
          lock_member = 'no',
          flood = 'yes',
        }
      }
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
      return send_large_msg(receiver, 'شما مالک این گروه شدید.')
    end
  end
end
local function check_member_modadd(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result.members) do
    local member_id = v.id
    if member_id ~= our_id then
      -- Group configuration
      data[tostring(msg.to.id)] = {
        group_type = 'Group',
        moderators = {},
        set_owner = member_id ,
        settings = {
          set_name = string.gsub(msg.to.print_name, '_', ' '),
          lock_name = 'yes',
          lock_photo = 'no',
          lock_member = 'no',
          flood = 'yes',
        }
      }
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
      return send_large_msg(receiver,' گروه اضافه شد و شما به عنوان مالک گروه تعیین شدید ')
    end
  end
end
local function automodadd(msg)
  local data = load_data(_config.moderation.data)
  if msg.action.type == 'chat_created' then
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_group,{receiver=receiver, data=data, msg = msg})
  end
end
local function autorealmadd(msg)
  local data = load_data(_config.moderation.data)
  if msg.action.type == 'chat_created' then
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_autorealm,{receiver=receiver, data=data, msg = msg})
  end
end
local function check_member_realmrem(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result.members) do
    local member_id = v.id
    if member_id ~= our_id then
      -- Realm configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local realms = 'realms'
      if not data[tostring(realms)] then
        data[tostring(realms)] = nil
        save_data(_config.moderation.data, data)
      end
      data[tostring(realms)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      return send_large_msg(receiver, 'ریلم حذف شد')
    end
  end
end
local function check_member_modrem(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local data = cb_extra.data
  local msg = cb_extra.msg
  for k,v in pairs(result.members) do
    local member_id = v.id
    if member_id ~= our_id then
      -- Group configuration removal
      data[tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
      return send_large_msg(receiver, 'گروه حذف شد')
    end
  end
end
--End Check Member
local function show_group_settingsmod(msg, data, target)
        if not is_momod(msg) then
        return "فقط برای مدیران !!"
        end
        local data = load_data(_config.moderation.data)
    if data[tostring(msg.to.id)] then
        if data[tostring(msg.to.id)]['settings']['flood_msg_max'] then
                NUM_MSG_MAX = tonumber(data[tostring(msg.to.id)]['settings']['flood_msg_max'])
                print('custom'..NUM_MSG_MAX)
        else
                NUM_MSG_MAX = 0
        end
    end

    local bots_protection = "Yes"
    if data[tostring(msg.to.id)]['settings']['lock_bots'] then
        bots_protection = data[tostring(msg.to.id)]['settings']['lock_bots']
        end

  local lock_link = "no"
    if data[tostring(msg.to.id)]['settings']['lock_link'] then
        lock_link = data[tostring(msg.to.id)]['settings']['lock_link']
        end

  local lock_join= "no"
    if data[tostring(msg.to.id)]['settings']['lock_join'] then
        lock_join = data[tostring(msg.to.id)]['settings']['lock_join']
        end

          local lock_eng = "no"
    if data[tostring(msg.to.id)]['settings']['lock_eng'] then
        lock_eng = data[tostring(msg.to.id)]['settings']['lock_eng']
        end

          local lock_badw = "no"
    if data[tostring(msg.to.id)]['settings']['lock_badw'] then
        lock_badw = data[tostring(msg.to.id)]['settings']['lock_badw']
        end

        local lock_tag = "no"
    if data[tostring(msg.to.id)]['settings']['lock_tag'] then
        lock_tag = data[tostring(msg.to.id)]['settings']['lock_tag']
        end

  local lock_leave = "no"
    if data[tostring(msg.to.id)]['settings']['lock_leave'] then
        lock_leave = data[tostring(msg.to.id)]['settings']['lock_leave']
        end
local lock_sticker = "no"
    if data[tostring(msg.to.id)]['settings']['sticker'] then
        lock_sticker = data[tostring(msg.to.id)]['settings']['sticker']
        end
         local settings = data[tostring(target)]['settings']
  local text = "تنظیمات گروه :\n💡قفل اسم گروه : "..settings.lock_name.."\n💡قفل عکس گروه : "..settings.lock_photo.."\n💡قفل تگ کردن در گروه : "..lock_tag.."\n💡قفل ورود اعضا : "..settings.lock_member.."\n💡قفل انگلیسی .. : "..lock_eng.."\n 💡محروم ترک کنندگان : "..lock_leave.."\n💡قفل فحش دادن : "..lock_badw.."\n💡قفل تبلیغات در گروه : "..lock_link.."\n💡قفل استیکر در گروه : "..lock_sticker.."\n💡حساسیت به اسپم : "..NUM_MSG_MAX.."\n💡حفاظت در برابر ربات ها : "..bots_protection--"\nPublic: "..public
  return text
end


local function set_descriptionmod(msg, data, target, about)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local data_cat = 'description'
  data[tostring(target)][data_cat] = about
  save_data(_config.moderation.data, data)
  return 'توضیحات گروه تغییر یافت به:\n'..about
end
local function get_description(msg, data)
  local data_cat = 'description'
  if not data[tostring(msg.to.id)][data_cat] then
    return 'هیچ توضیحاتی وجود ندارد.'
  end
  local about = data[tostring(msg.to.id)][data_cat]
  local about = string.gsub(msg.to.print_name, "_", " ")..':\n\n'..about
  return 'در مورد گروه : '..about
end
local function lock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !"
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'yes' then
    return 'فارسی قفل بود'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'فارسی قفل شد'
  end
end

local function unlock_group_arabic(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !"
  end
  local group_arabic_lock = data[tostring(target)]['settings']['lock_arabic']
  if group_arabic_lock == 'no' then
    return 'فارسی قفل نبود'
  else
    data[tostring(target)]['settings']['lock_arabic'] = 'no'
    save_data(_config.moderation.data, data)
    return 'فارسی در گروه مجاز شد'
  end
end

local function lock_group_link(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !"
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'yes' then
    return 'تبلیغ قفل بود'
  else
    data[tostring(target)]['settings']['lock_link'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تبلیغ قفل شد'
  end
end
local function lock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_sticker_lock = data[tostring(target)]['settings']['sticker']
  if group_sticker_lock == 'yes' then
    return 'استیکر قفل بود'
  else
    data[tostring(target)]['settings']['sticker'] = 'kick'
    save_data(_config.moderation.data, data)
    return 'استیکر قفل شد'
  end
end

local function unlock_group_sticker(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_sticker_lock = data[tostring(target)]['settings']['sticker']
  if group_sticker_lock == 'no' then
    return 'استیکر قفل نبود'
  else
    data[tostring(target)]['settings']['sticker'] = 'no'
    save_data(_config.moderation.data, data)
    return 'استفاده از استیکر آزاد شد'
  end
end

local function unlock_group_link(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'no' then
    return 'تبلیغات قفل نبود'
  else
    data[tostring(target)]['settings']['lock_link'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تبلیغات در گروه آزاد شد'
  end
end
local function lock_group_link(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'yes' then
    return 'تبلیغات قفل بود'
  else
    data[tostring(target)]['settings']['lock_link'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تبلیغات قفل شد'
  end
end

local function unlock_group_link(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_link_lock = data[tostring(target)]['settings']['lock_link']
  if group_link_lock == 'no' then
    return 'تبلیغات قفل نبود'
  else
    data[tostring(target)]['settings']['lock_link'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تبلیغات در گروه مجاز شد'
  end
end

local function lock_group_eng(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_eng_lock = data[tostring(target)]['settings']['lock_eng']
  if group_eng_lock == 'yes' then
    return 'انگلیسی قفل بود'
  else
    data[tostring(target)]['settings']['lock_eng'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'انگلیسی در گروه قفل شد'
  end
end

local function unlock_group_eng(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_eng_lock = data[tostring(target)]['settings']['lock_eng']
  if group_eng_lock == 'no' then
    return 'انگلیسی قفل نبود'
  else
    data[tostring(target)]['settings']['lock_eng'] = 'no'
    save_data(_config.moderation.data, data)
    return 'استفاده از انگلیسی آزاد شد'
  end
end
local function lock_group_eng(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_eng_lock = data[tostring(target)]['settings']['lock_eng']
  if group_eng_lock == 'yes' then
    return 'انگلیسی قفل بود'
  else
    data[tostring(target)]['settings']['lock_eng'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'انگلیسی قفل شد'
  end
end

local function unlock_group_eng(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_eng_lock = data[tostring(target)]['settings']['lock_eng']
  if group_eng_lock == 'no' then
    return 'انگلیسی قفل نبود'
  else
    data[tostring(target)]['settings']['lock_eng'] = 'no'
    save_data(_config.moderation.data, data)
    return 'انگلیسی در گروه مجاز شد'
  end
end

local function lock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == 'yes' then
    return 'تگ کرردن قفل بود'
  else
    data[tostring(target)]['settings']['lock_tag'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تگ کردن قفل شد'
  end
end

local function unlock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == 'no' then
    return 'تگ کردن قفل نبود'
  else
    data[tostring(target)]['settings']['lock_tag'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تگ کردن در گروه مجاز شد'
  end
end
local function lock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == 'yes' then
    return 'تگ کردن قفل بود'
  else
    data[tostring(target)]['settings']['lock_tag'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'تگ کردن قفل شد'
  end
end

local function unlock_group_tag(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_tag_lock = data[tostring(target)]['settings']['lock_tag']
  if group_tag_lock == 'no' then
    return 'تگ کردن قفل نبود'
  else
    data[tostring(target)]['settings']['lock_tag'] = 'no'
    save_data(_config.moderation.data, data)
    return 'تگ کردن در گروه مجاز شد'
  end
end

local function lock_group_badw(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_badw_lock = data[tostring(target)]['settings']['lock_badw']
  if group_badw_lock == 'yes' then
    return 'فحش در گروه قفل بود'
  else
    data[tostring(target)]['settings']['lock_badw'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'فحش در گروه قفل شد'
  end
end

local function unlock_group_badw(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_badw_lock = data[tostring(target)]['settings']['lock_badw']
  if group_badw_lock == 'no' then
    return 'فحش در گروه قفل نبود'
  else
    data[tostring(target)]['settings']['lock_badw'] = 'no'
    save_data(_config.moderation.data, data)
    return 'استفاده از فحش در گروه آزاد شد'
  end
end
local function lock_group_badw(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_badw_lock = data[tostring(target)]['settings']['lock_badw']
  if group_badw_lock == 'yes' then
    return 'فحش در گروه قفل نبود'
  else
    data[tostring(target)]['settings']['lock_badw'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'فحش در گروه قفل شد'
  end
end

local function unlock_group_badw(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_badw_lock = data[tostring(target)]['settings']['lock_badw']
  if group_badw_lock == 'no' then
    return 'فحش قفل نبود'
  else
    data[tostring(target)]['settings']['lock_badw'] = 'no'
    save_data(_config.moderation.data, data)
    return 'استفاده از فحش در گروه آزاد شد'
  end
end

local function lock_group_leave(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local leave_ban = data[tostring(msg.to.id)]['settings']['leave_ban']
  if leave_ban == 'yes' then
    return 'افراد خارج شده محروم خواهند شد'
  else
    data[tostring(msg.to.id)]['settings']['leave_ban'] = 'yes'
    save_data(_config.moderation.data, data)
  end
  return 'افراد خارج شده محروم خواهند شد'
end

local function unlock_group_leave(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local leave_ban = data[tostring(msg.to.id)]['settings']['leave_ban']
  if leave_ban == 'no' then
    return 'افراد خارج شده محروم نخواهند شد'
  else
    data[tostring(msg.to.id)]['settings']['leave_ban'] = 'no'
    save_data(_config.moderation.data, data)
    return 'افراد خارج شده محروم نخواهند شد'
  end
end

local function lock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'yes' then
    return 'دفاع دربرابر ربات ها فعال بود'
  else
    data[tostring(target)]['settings']['lock_bots'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'دفاع در برابر ربات فعال شد'
  end
end
local function unlock_group_bots(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_bots_lock = data[tostring(target)]['settings']['lock_bots']
  if group_bots_lock == 'no' then
    return 'دفاع در برابر ربات غیر فعال بود'
  else
    data[tostring(target)]['settings']['lock_bots'] = 'no'
    save_data(_config.moderation.data, data)
    return 'دفاع در برابر ربات غیر فعال شد'
  end
end

local function lock_group_namemod(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
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
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_name_set = data[tostring(target)]['settings']['set_name']
  local group_name_lock = data[tostring(target)]['settings']['lock_name']
  if group_name_lock == 'no' then
    return 'اسم گروه قفل نبود'
  else
    data[tostring(target)]['settings']['lock_name'] = 'no'
    save_data(_config.moderation.data, data)
    return 'اسم گروه قابل  تغییر برای همه شد'
  end
end
local function lock_group_floodmod(msg, data, target)
  if not is_owner(msg) then
    return "فقط ادمین ها میتوانند اینکار را بکنند"
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'yes' then
    return 'اسپم در گروه قفل بود'
  else
    data[tostring(target)]['settings']['flood'] = 'yes'
    save_data(_config.moderation.data, data)
    return 'اسپم در گروه قفل شد'
  end
end

local function unlock_group_floodmod(msg, data, target)
  if not is_owner(msg) then
    return "فقط ادمین ها میتوانند اینکار را بکنند"
  end
  local group_flood_lock = data[tostring(target)]['settings']['flood']
  if group_flood_lock == 'no' then
    return 'اسپم در گروه قفل نبود '
  else
    data[tostring(target)]['settings']['flood'] = 'no'
    save_data(_config.moderation.data, data)
    return 'اسپم در گروه مجاز شد'
  end
end

local function lock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'yes' then
    return 'ورود اعضای جدید غیر مجاز بود'
  else
    data[tostring(target)]['settings']['lock_member'] = 'yes'
    save_data(_config.moderation.data, data)
  end
  return 'ورود اعضای جدید غیر مجاز شد'
end

local function unlock_group_membermod(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_member_lock = data[tostring(target)]['settings']['lock_member']
  if group_member_lock == 'no' then
    return 'ورود اعضای جدید غیر مجاز نبود'
  else
    data[tostring(target)]['settings']['lock_member'] = 'no'
    save_data(_config.moderation.data, data)
    return 'ورود اعضای جدید به گروه مجاز شد'
  end
end

local function unlock_group_photomod(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local group_photo_lock = data[tostring(target)]['settings']['lock_photo']
  if group_photo_lock == 'no' then
    return 'عکس گروه قفل نبود'
  else
    data[tostring(target)]['settings']['lock_photo'] = 'no'
    save_data(_config.moderation.data, data)
    return 'عکس گروه قابل تغییر توسط همگان است'
  end
end

local function set_rulesmod(msg, data, target)
  if not is_momod(msg) then
    return "فقط برای مدیران !!"
  end
  local data_cat = 'rules'
  data[tostring(target)][data_cat] = rules
  save_data(_config.moderation.data, data)
  return 'قوانین گروه تغییر یافت به:\n'..rules
end
local function modadd(msg)
  -- superuser and admins only (because sudo are always has privilege)
  if not is_admin(msg) then
    return "شما ادمین نیستید !"
  end
  local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
    return 'گروه از قبل اضافه شده بود'
  end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_modadd,{receiver=receiver, data=data, msg = msg})
end
local function modadd(msg)
  -- superuser and admins only (because sudo are always has privilege)
  if not is_admin(msg) then
    return "شما ادمین نیستید !"
  end
  local data = load_data(_config.moderation.data)
  if is_group(msg) then
    return 'گروه از قبل اضافه شده بود'
  end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_modadd,{receiver=receiver, data=data, msg = msg})
end
local function realmadd(msg)
  -- superuser and admins only (because sudo are always has privilege)
  if not is_admin(msg) then
    return "شما ادمین نیستید !"
  end
  local data = load_data(_config.moderation.data)
  if is_realm(msg) then
    return 'ریلم از قبل اضافه شده بود'
  end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_realm_add,{receiver=receiver, data=data, msg = msg}) 
end
-- Global functions
function modrem(msg)
  -- superuser and admins only (because sudo are always has privilege)
  if not is_admin(msg) then
    return "شما ادمین نیستید !"
  end
  local data = load_data(_config.moderation.data)
  if not is_group(msg) then
    return 'گروه اضافه نشده است'
  end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_modrem,{receiver=receiver, data=data, msg = msg})
end

function realmrem(msg)
  -- superuser and admins only (because sudo are always has privilege)
  if not is_admin(msg) then
    return "شما ادمین نیستید !"
  end
  local data = load_data(_config.moderation.data)
  if not is_realm(msg) then
    return 'ریلم اضافه نشده است'
  end
    receiver = get_receiver(msg)
    chat_info(receiver, check_member_realmrem,{receiver=receiver, data=data, msg = msg})
end
local function get_rules(msg, data)
  local data_cat = 'rules'
  if not data[tostring(msg.to.id)][data_cat] then
    return 'هیچ قانونی تنظیم نشده است.'
  end
  local rules = data[tostring(msg.to.id)][data_cat]
  local rules = 'قوانین گروه عبارتند از:\n'..rules
  return rules
end

local function set_group_photo(msg, success, result)
  local data = load_data(_config.moderation.data)
  local receiver = get_receiver(msg)
  if success then
    local file = 'data/photos/chat_photo_'..msg.to.id..'.jpg'
    print('این فایل دانلود شد به :', result)
    os.rename(result, file)
    print('این فایل انتقال یافت به:', file)
    chat_set_photo (receiver, file, ok_cb, false)
    data[tostring(msg.to.id)]['settings']['set_photo'] = file
    save_data(_config.moderation.data, data)
    data[tostring(msg.to.id)]['settings']['lock_photo'] = 'yes'
    save_data(_config.moderation.data, data)
    send_large_msg(receiver, 'عکس به ثبت رسید!', ok_cb, false)
  else
    print('خطایی در دانلود رخ داده است: '..msg.id)
    send_large_msg(receiver, 'خطایی رخ داد . لطفا بعدا امتحان کنید', ok_cb, false)
  end
end

local function promote(receiver, member_username, member_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'chat#id', '')
  if not data[group] then
    return send_large_msg(receiver, 'گروه اضافه نشده است')
  end
  if data[group]['moderators'][tostring(member_id)] then
    return send_large_msg(receiver, member_username..' از قبل مدیر بود.')
  end
  data[group]['moderators'][tostring(member_id)] = member_username
  save_data(_config.moderation.data, data)
  return send_large_msg(receiver, member_username..' به عنوان مدیر ارتقا یافت.')
end

local function promote_by_reply(extra, success, result)
    local msg = result
    local full_name = (msg.from.first_name or '')..' '..(msg.from.last_name or '')
    if msg.from.username then
      member_username = '@'.. msg.from.username
    else
      member_username = full_name
    end
    local member_id = msg.from.id
    if msg.to.type == 'chat' then
      return promote(get_receiver(msg), member_username, member_id)
    end  
end

local function demote(receiver, member_username, member_id)
  local data = load_data(_config.moderation.data)
  local group = string.gsub(receiver, 'chat#id', '')
  if not data[group] then
    return send_large_msg(receiver, 'گروه اضافه نشده است')
  end
  if not data[group]['moderators'][tostring(member_id)] then
    return send_large_msg(receiver, member_username..' این شخص مدیر نیست.')
  end
  data[group]['moderators'][tostring(member_id)] = nil
  save_data(_config.moderation.data, data)
  return send_large_msg(receiver, member_username..' صلب مدیریت شد.')
end

local function demote_by_reply(extra, success, result)
    local msg = result
    local full_name = (msg.from.first_name or '')..' '..(msg.from.last_name or '')
    if msg.from.username then
      member_username = '@'..msg.from.username
    else
      member_username = full_name
    end
    local member_id = msg.from.id
    if msg.to.type == 'chat' then
      return demote(get_receiver(msg), member_username, member_id)
    end  
end

local function setowner_by_reply(extra, success, result)
  local msg = result
  local receiver = get_receiver(msg)
  local data = load_data(_config.moderation.data)
  local name_log = msg.from.print_name:gsub("_", " ")
  data[tostring(msg.to.id)]['set_owner'] = tostring(msg.from.id)
      save_data(_config.moderation.data, data)
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] ارتقا داد  ["..msg.from.id.."] را به عنوان مالک گروه")
      local text = msg.from.print_name:gsub("_", " ").." الان مالک گروه است"
      return send_large_msg(receiver, text)
end

local function promote_demote_res(extra, success, result)
--vardump(result)
--vardump(extra)
      local member_id = result.id
      local member_username = "@"..result.username
      local chat_id = extra.chat_id
      local mod_cmd = extra.mod_cmd
      local receiver = "chat#id"..chat_id
      if mod_cmd == 'promote' then
        return promote(receiver, member_username, member_id)
      elseif mod_cmd == 'demote' then
        return demote(receiver, member_username, member_id)
      end
end

local function modlist(msg)
  local data = load_data(_config.moderation.data)
  local groups = "groups"
  if not data[tostring(groups)][tostring(msg.to.id)] then
    return 'گروه اضافه نشده است'
  end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['moderators']) == nil then --fix way
    return 'هیچ مدیری در این گروه نیست . برای اضافه کردن به مالک گروه مراجعه کنید.'
  end
  local i = 1
  local message = '\nلیست مدیران این گروه عبارت است از  ' .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
  for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
    message = message ..i..' - '..v..' [' ..k.. '] \n'
    i = i + 1
  end
  return message
end

local function callbackres(extra, success, result)
--vardump(result)
  local user = result.id
  local name = string.gsub(result.print_name, "_", " ")
  local chat = 'chat#id'..extra.chatid
  send_large_msg(chat, user..'\n'..name)
  return user
end


local function help()
  local help_text = tostring(_config.help_text)
  return help_text
end

local function cleanmember(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local chat_id = "chat#id"..result.id
  local chatname = result.print_name
  for k,v in pairs(result.members) do
    kick_user(v.id, result.id)     
  end
end

local function killchat(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local chat_id = "chat#id"..result.id
  local chatname = result.print_name
  for k,v in pairs(result.members) do
    kick_user_any(v.id, result.id)     
  end
end

local function killrealm(cb_extra, success, result)
  local receiver = cb_extra.receiver
  local chat_id = "chat#id"..result.id
  local chatname = result.print_name
  for k,v in pairs(result.members) do
    kick_user_any(v.id, result.id)     
  end
end

local function user_msgs(user_id, chat_id)
  local user_info
  local uhash = 'user:'..user_id
  local user = redis:hgetall(uhash)
  local um_hash = 'پیام ها:'..user_id..':'..chat_id
  user_info = tonumber(redis:get(um_hash) or 0)
  return user_info
end

local function kick_zero(cb_extra, success, result)
    local chat_id = cb_extra.chat_id
    local chat = "chat#id"..chat_id
    local ci_user
    local re_user
    for k,v in pairs(result.members) do
        local si = false
        ci_user = v.id
        local hash = 'chat:'..chat_id..':users'
        local users = redis:smembers(hash)
        for i = 1, #users do
            re_user = users[i]
            if tonumber(ci_user) == tonumber(re_user) then
                si = true
            end
        end
        if not si then
            if ci_user ~= our_id then
                if not is_momod2(ci_user, chat_id) then
                  chat_del_user(chat, 'user#id'..ci_user, ok_cb, true)
                end
            end
        end
    end
end

local function kick_inactive(chat_id, num, receiver)
    local hash = 'chat:'..chat_id..':users'
    local users = redis:smembers(hash)
    -- Get user info
    for i = 1, #users do
        local user_id = users[i]
        local user_info = user_msgs(user_id, chat_id)
        local nmsg = user_info
        if tonumber(nmsg) < tonumber(num) then
            if not is_momod2(user_id, chat_id) then
              chat_del_user('chat#id'..chat_id, 'user#id'..user_id, ok_cb, true)
            end
        end
    end
    return chat_info(receiver, kick_zero, {chat_id = chat_id})
end

local function run(msg, matches)
  local data = load_data(_config.moderation.data)
  local receiver = get_receiver(msg)
   local name_log = user_print_name(msg.from)
  local group = msg.to.id
  if msg.media then
    if msg.media.type == 'photo' and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_chat_msg(msg) and is_momod(msg) then
      load_photo(msg.id, set_group_photo, msg)
    end
  end
  if matches[1] == 'نصب' and not matches[2] then
    if is_realm(msg) then
       return 'خطا : اینجا ریلم معرفی شده است'
    end
    print("گروهه "..msg.to.print_name.."("..msg.to.id..") اضافه شد")
    return modadd(msg)
  end
   if matches[1] == 'نصب' and matches[2] == 'ریلم' then
    if is_group(msg) then
       return 'خطا : اینجا به عنوان گروه معمولی معرفی شده است'
    end
    print("گروهه "..msg.to.print_name.."("..msg.to.id..") ریلم معرفی شد")
    return realmadd(msg)
  end
  if matches[1] == 'صلب' and not matches[2] then
    print("گروهه "..msg.to.print_name.."("..msg.to.id..") حذف شد")
    return modrem(msg)
  end
  if matches[1] == 'صلب' and matches[2] == 'ریلم' then
    print("group "..msg.to.print_name.."("..msg.to.id..") ریلم حذف شد")
    return realmrem(msg)
  end
  if matches[1] == 'chat_created' and msg.from.id == 0 and group_type == "group" then
    return automodadd(msg)
  end
  if matches[1] == 'chat_created' and msg.from.id == 0 and group_type == "realm" then
    return autorealmadd(msg)
  end

  if msg.to.id and data[tostring(msg.to.id)] then
    local settings = data[tostring(msg.to.id)]['settings']
    if matches[1] == 'chat_add_user' then
      if not msg.service then
        return "کیو میخوای خر کنی ؟ "
      end
      local group_member_lock = settings.lock_member
      local user = 'user#id'..msg.action.user.id
      local chat = 'chat#id'..msg.to.id
      if group_member_lock == 'yes' and not is_owner2(msg.action.user.id, msg.to.id) then
        chat_del_user(chat, user, ok_cb, true)
      elseif group_member_lock == 'yes' and tonumber(msg.from.id) == tonumber(our_id) then
        return nil
      elseif group_member_lock == 'no' then
        return nil
      end
    end
    if matches[1] == 'chat_del_user' then
      if not msg.service then
         -- return "کیو میخوای خر کنی ؟ "
      end
      local user = 'user#id'..msg.action.user.id
      local chat = 'chat#id'..msg.to.id
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] deleted user  "..user)
    end
    if matches[1] == 'chat_delete_photo' then
      if not msg.service then
        return "کیو میخوای خر کنی ؟ "
      end
      local group_photo_lock = settings.lock_photo
      if group_photo_lock == 'yes' then
        local picturehash = 'picture:changed:'..msg.to.id..':'..msg.from.id
        redis:incr(picturehash)
        ---
        local picturehash = 'picture:changed:'..msg.to.id..':'..msg.from.id
        local picprotectionredis = redis:get(picturehash) 
        if picprotectionredis then 
          if tonumber(picprotectionredis) == 4 and not is_owner(msg) then 
            kick_user(msg.from.id, msg.to.id)
          end
          if tonumber(picprotectionredis) ==  8 and not is_owner(msg) then 
            ban_user(msg.from.id, msg.to.id)
            local picturehash = 'picture:changed:'..msg.to.id..':'..msg.from.id
            redis:set(picturehash, 0)
          end
        end
        
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] tried to deleted picture but failed  ")
        chat_set_photo(receiver, settings.set_photo, ok_cb, false)
      elseif group_photo_lock == 'no' then
        return nil
      end
    end
    if matches[1] == 'chat_change_photo' and msg.from.id ~= 0 then
      if not msg.service then
        return "کیو میخوای خر کنی ؟ "
      end
      local group_photo_lock = settings.lock_photo
      if group_photo_lock == 'yes' then
        local picturehash = 'picture:changed:'..msg.to.id..':'..msg.from.id
        redis:incr(picturehash)
        ---
        local picturehash = 'picture:changed:'..msg.to.id..':'..msg.from.id
        local picprotectionredis = redis:get(picturehash) 
        if picprotectionredis then 
          if tonumber(picprotectionredis) == 4 and not is_owner(msg) then 
            kick_user(msg.from.id, msg.to.id)
          end
          if tonumber(picprotectionredis) ==  8 and not is_owner(msg) then 
            ban_user(msg.from.id, msg.to.id)
          local picturehash = 'picture:changed:'..msg.to.id..':'..msg.from.id
          redis:set(picturehash, 0)
          end
        end
        
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] سعی در عوض کردن عکس گروه داشت  ")
        chat_set_photo(receiver, settings.set_photo, ok_cb, false)
      elseif group_photo_lock == 'no' then
        return nil
      end
    end
    if matches[1] == 'chat_rename' then
      if not msg.service then
        return "کیو میخوای خر کنی ؟ "
      end
      local group_name_set = settings.set_name
      local group_name_lock = settings.lock_name
      local to_rename = 'chat#id'..msg.to.id
      if group_name_lock == 'yes' then
        if group_name_set ~= tostring(msg.to.print_name) then
          local namehash = 'name:changed:'..msg.to.id..':'..msg.from.id
          redis:incr(namehash)
          local namehash = 'name:changed:'..msg.to.id..':'..msg.from.id
          local nameprotectionredis = redis:get(namehash) 
          if nameprotectionredis then 
            if tonumber(nameprotectionredis) == 4 and not is_owner(msg) then 
              kick_user(msg.from.id, msg.to.id)
            end
            if tonumber(nameprotectionredis) ==  8 and not is_owner(msg) then 
              ban_user(msg.from.id, msg.to.id)
              local namehash = 'name:changed:'..msg.to.id..':'..msg.from.id
              redis:set(namehash, 0)
            end
          end
          
          savelog(msg.to.id, name_log.." ["..msg.from.id.."] سعی در عوض کردن عکس گروه داشت  ")
          rename_chat(to_rename, group_name_set, ok_cb, false)
        end
      elseif group_name_lock == 'no' then
        return nil
      end
    end
    if matches[1] == 'نصب اسم' and is_momod(msg) then
      local new_name = string.gsub(matches[2], '_', ' ')
      data[tostring(msg.to.id)]['settings']['set_name'] = new_name
      save_data(_config.moderation.data, data)
      local group_name_set = data[tostring(msg.to.id)]['settings']['set_name']
      local to_rename = 'chat#id'..msg.to.id
      rename_chat(to_rename, group_name_set, ok_cb, false)
      
      savelog(msg.to.id, "گروهه { "..msg.to.print_name.." }  اسمش تغییر یافت به [ "..new_name.." ] توسط "..name_log.." ["..msg.from.id.."]")
    end
    if matches[1] == 'نصب عکس' and is_momod(msg) then
      data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
      save_data(_config.moderation.data, data)
      return 'لطفا عکس گروه را برای من ارسال کنید'
    end
    if matches[1] == 'ارتقا' and not matches[2] then
      if not is_owner(msg) then
        return "فقط سازنده ی گروه قادر به اضافه کردن مدیر هست"
      end
      if type(msg.reply_id)~="nil" then
          msgr = get_message(msg.reply_id, promote_by_reply, false)
      end
    end
    if matches[1] == 'ارتقا' and matches[2] then
      if not is_momod(msg) then
        return
      end
      if not is_owner(msg) then
        return "فقط سازنده ی گروه قادر به اضافه کردن مدیر هست"
      end
	local member = matches[2]
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] این شخص ارتقا یافت به عنوان مدیر @".. member)
	local cbres_extra = {
	chat_id = msg.to.id,
        mod_cmd = 'promote', 
	from_id = msg.from.id
	}
	local username = matches[2]
	local username = string.gsub(matches[2], '@', '')
	return res_user(username, promote_demote_res, cbres_extra)
    end
    if matches[1] == 'حذف مدیر' and not matches[2] then
      if not is_owner(msg) then
        return "فقط سازنده ی گروه قادر به صلب مدیریت است"
      end
      if type(msg.reply_id)~="nil" then
          msgr = get_message(msg.reply_id, demote_by_reply, false)
      end
    end
    if matches[1] == 'حذف مدیر' and matches[2] then
      if not is_momod(msg) then
        return
      end
      if not is_owner(msg) then
        return "فقط سازنده ی گروه قادر به صلب مدیریت است"
      end
      if string.gsub(matches[2], "@", "") == msg.from.username and not is_owner(msg) then
        return "شما قادر به صلب مدیریت خود نیستید"
      end
	local member = matches[2]
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] این شخص را از مدیریت برکنار کرد @".. member)
	local cbres_extra = {
	chat_id = msg.to.id,
        mod_cmd = 'demote', 
	from_id = msg.from.id
	}
	local username = matches[2]
	local username = string.gsub(matches[2], '@', '')
	return res_user(username, promote_demote_res, cbres_extra)
    end
    if matches[1] == 'لیست مدیران' then
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] درخواست لیست مدیران را کرد")
      return modlist(msg)
    end
    if matches[1] == 'توضیحات' then
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] توضیحات گروه را خواست")
      return get_description(msg, data)
    end
    if matches[1] == 'قوانین' then
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] قوانین گروه را خواست")
      return get_rules(msg, data)
    end
    if matches[1] == 'تنظیم' then
      if matches[2] == 'قوانین' then
        rules = matches[3]
        local target = msg.to.id
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] قوانین گروه رو تغییر داد به ["..matches[3].."]")
        return set_rulesmod(msg, data, target)
      end
      if matches[2] == 'توضیحات' then
        local data = load_data(_config.moderation.data)
        local target = msg.to.id
        local about = matches[3]
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] توضیحات گروه را تغییر داد به ["..matches[3].."]")
        return set_descriptionmod(msg, data, target, about)
      end
    end
   if matches[1] == 'قفل' then
      local target = msg.to.id
      if matches[2] == 'همه' then
      	if not is_momod(msg) then
      		return "همه ی تنظیمات قفل شد"
      	end
      	local safemode ={
      		lock_group_sticker(msg, data, target),
      		lock_group_namemod(msg, data, target),
      		lock_group_membermod(msg, data, target),
      		lock_group_floodmod(msg, data, target),
      		lock_group_tag(msg, data, target),
      		lock_group_badw(msg, data, target),
      		lock_group_bots(msg, data, target),
      		lock_group_link(msg, data, target),
      	}
      	return safemode
      end
      if matches[2] == 'استیکر' then
          savelog(msg.to.id, name_log.." ["..msg.from.id.."] استفاده از استیکر ممنوع شد ")
          return lock_group_sticker(msg, data, target)
      end
      if matches[2] == 'اسم' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] اسم گروه قفل شد ")
        return lock_group_namemod(msg, data, target)
      end
      if matches[2] == 'ورود' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] ورود اعضای جدید قدغا شد ")
        return lock_group_membermod(msg, data, target)
        end
      if matches[2] == 'اسپم' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] اسپم در گروه غیر مجاز شد")
        return lock_group_floodmod(msg, data, target)
      end
      if matches[2] == 'فارسی' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] فارسی در گروه قفل شد ")
        return lock_group_arabic(msg, data, target)
      end
          if matches[2] == 'تبلیغ' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] تبلیغات در گروه قفل شد ")
        return lock_group_link(msg, data, target)
      end
          if matches[2] == 'انگلیسی' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] استفاده از الفبای انگلیسی قدغا شد ")
        return lock_group_eng(msg, data, target)
      end
          if matches[2] == 'تگ' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] تگ کردن در گروه قدغا شد ")
        return lock_group_tag(msg, data, target)
      end
         if matches[2] == 'فحش' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] استفاده از فحش در گروه قدغا شد ")
        return lock_group_badw(msg, data, target)
      end
         if matches[2] == 'خروج' then
       savelog(msg.to.id, name_log.." ["..msg.from.id.."] افراد خارج شده محروم خواهند شد ")
       return lock_group_leave(msg, data, target)
     end
      if matches[2] == 'ربات' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] locked bots ")
        return lock_group_bots(msg, data, target)
      end
    end
    if matches[1] == 'باز کردن' then
      local target = msg.to.id
      if matches[2] == 'همه' then
      	if not is_momod(msg) then
      		return "همه تنظیمات باز شد"
      	end
      	local de_safemode ={
      		unlock_group_sticker(msg, data, target),
      		unlock_group_namemod(msg, data, target),
      		unlock_group_membermod(msg, data, target),
      		unlock_group_floodmod(msg, data, target),
      		unlock_group_tag(msg, data, target),
      		unlock_group_badw(msg, data, target),
      		unlock_group_bots(msg, data, target),
      		unlock_group_link(msg, data, target),
      	}
      	return de_safemode
      end
      if matches[2] == 'استیکر' then
          savelog(msg.to.id, name_log.." ["..msg.from.id.."] استفاده از استیکر مجاز شد ")
          return unlock_group_sticker(msg, data, target)
      end
      if matches[2] == 'اسم'  then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] اسم گروه قابل تغییر برای همه شد ")
        return unlock_group_namemod(msg, data, target)
      end
      if matches[2] == 'ورود' or matches[2] == 'اعضا' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] اجازه ی ورود اعضای جدید داده شد ")
        return unlock_group_membermod(msg, data, target)
      end
      if matches[2] == 'عکس' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] عکس گروه قابل تغییر برای همه شد ")
        return unlock_group_photomod(msg, data, target)
      end
      if matches[2] == 'اسپم' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] اسپم در گروه آزاد شد ")
        return unlock_group_floodmod(msg, data, target)
      end
      if matches[2] == 'فارسی' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] فارسی در گروه آزاد شد ")
        return unlock_group_arabic(msg, data, target)
      end
          if matches[2] == 'تبلیغ' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] تبلیغات در گروه مجاز شد ")
        return unlock_group_link(msg, data, target)
      end
          if matches[2] == 'انگلیسی' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] استفاده از انگلیسی در این گروه مجاز شد ")
        return unlock_group_eng(msg, data, target)
      end
          if matches[2] == 'تگ' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] تگ کردن مجاز شد ")
        return unlock_group_tag(msg, data, target)
      end
         if matches[2] == 'فحش' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] فحش دادن در این گروه مجاز شد ")
        return unlock_group_badw(msg, data, target)
      end
         if matches[2] == 'خروج' then
       savelog(msg.to.id, name_log.." ["..msg.from.id.."] امکان برگشت بعد ترک گروه وجود دارد ")
       return unlock_group_leave(msg, data, target)
     end
      if matches[2] == 'ربات' then
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] امکان آوردن ربات وجود دارد")
        return unlock_group_bots(msg, data, target)
      end
    end
    if matches[1] == 'تنظیمات' then
      local target = msg.to.id
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] درخواست تنظیمات گروه را کرد ")
      return show_group_settingsmod(msg, data, target)
    end	
     if msg.media and msg.media.caption == 'sticker.webp' and not is_momod(msg) then
      local user_id = msg.from.id
      local chat_id = msg.to.id
      local sticker_hash = 'sticker:'..chat_id..':'..user_id
      local is_sticker_offender = redis:get(sticker_hash)
    if settings.sticker == 'yes' then
        chat_del_user(receiver, 'user#id'..user_id, ok_cb, true)
        return 'استیکر در گروه قفل شد لطفا استیکر نفرستید'
      elseif settings.sticker == 'no' then
        return nil
      end
    end
  --[[if matches[1] == 'public' then
    local target = msg.to.id
    if matches[2] == 'yes' then
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] set group to: public")
      return set_public_membermod(msg, data, target)
    end
    if matches[2] == 'no' then
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] set group to: not public")
      return unset_public_membermod(msg, data, target)
    end
  end]]

    if matches[1] == 'لینک جدید' and not is_realm(msg) then
      if not is_momod(msg) then
        return "فقط برای مدیران !!"
      end
      local function callback (extra , success, result)
        local receiver = 'chat#'..msg.to.id
        if success == 0 then
           return send_large_msg(receiver, 'خطایی رخ داده است : لینک بدست نمی آید \nعلت : سازنده نبودن.')
        end
        send_large_msg(receiver, "لینک جدید ساخته شد")
        data[tostring(msg.to.id)]['settings']['set_link'] = result
        save_data(_config.moderation.data, data)
      end
      local receiver = 'chat#'..msg.to.id
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] لینک گروه را عوض کرد ")
      return export_chat_link(receiver, callback, true)
    end
    if matches[1] == 'لینک' then
      if not is_momod(msg) then
        return "فقط برای مدیران !!"
      end
      local group_link = data[tostring(msg.to.id)]['settings']['set_link']
      if not group_link then 
        return "ابتدا با دستور *لینک جدید* یک لینک جدید بسازید"
      end
       savelog(msg.to.id, name_log.." ["..msg.from.id.."] درخواست لینک گروه را داد ["..group_link.."]")
      return "لینک گروه برای  ("..string.gsub(msg.to.print_name, "_", " ").."):\n"..group_link
    end
    if matches[1] == 'نصب مالک' and matches[2] then
      if not is_owner(msg) then
        return "فقط مخصوص ادمین ها و سازنده ی گروه هست"
      end
      data[tostring(msg.to.id)]['set_owner'] = matches[2]
      save_data(_config.moderation.data, data)
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] این شخص را ["..matches[2].."] به عنوان مالک گروه انتخاب کرد")
      local text = matches[2].." به عنوان مالک گروه انتخاب شد"
      return text
    end
    if matches[1] == 'نصب مالک' and not matches[2] then
      if not is_owner(msg) then
        return "فقط مخصوص ادمین ها و سازنده ی گروه هست"
      end
      if type(msg.reply_id)~="nil" then
          msgr = get_message(msg.reply_id, setowner_by_reply, false)
      end
    end
    if matches[1] == 'مالک' then
      local group_owner = data[tostring(msg.to.id)]['set_owner']
      if not group_owner then 
        return "هیچ سازنده ای وجود ندارد . از ادمین ها برای معرفی سازنده کمک بگیرید"
      end
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] از دستور *مالک* استفاده کرد")
      return "سازنده ی گروه شخصه رو به رو است ["..group_owner..']'
    end
    if matches[1] == 'نصب سازنده' then
      local receiver = "chat#id"..matches[2]
      if not is_admin(msg) then
        return "فقط برای ادمین ها !"
      end
      data[tostring(matches[2])]['set_owner'] = matches[3]
      save_data(_config.moderation.data, data)
      local text = matches[3].." به عنوان سازنده معرفی شد"
      send_large_msg(receiver, text)
      return
    end
    if matches[1] == 'حساسیت' then 
      if not is_momod(msg) then
        return "فقط برای مدیران !!"
      end
      if tonumber(matches[5]) < 5 or tonumber(matches[5]) > 20 then
        return "عدد اشتباه است . حساسیت باید بین 5 تا 20 باشد"
      end
      local flood_max = matches[2]
      data[tostring(msg.to.id)]['settings']['flood_msg_max'] = flood_max
      save_data(_config.moderation.data, data)
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] حساسیت اسپم را تغییر داد به ["..matches[2].."]")
      return 'حساسیت به اسپم تغییر یافت به عدد '..matches[2]
    end
    if matches[1] == 'پاک کردن' then
      if not is_owner(msg) then
        return "فقط مالک گروه قادر به پاک کردن هست"
      end
      if matches[2] == 'اعضا' then
        if not is_owner(msg) then
          return "فقط ادمین ها قادر به پاک کردن اعضا هستند"
        end
        local receiver = get_receiver(msg)
        chat_info(receiver, cleanmember, {receiver=receiver})
      end
      if matches[2] == 'لیست مدیران' then
        if next(data[tostring(msg.to.id)]['moderators']) == nil then --fix way
          return 'هیچ مدیری در این گروه وجود ندارد.'
        end
        local message = '\nلیست مدیران این گروه عبارتند از ' .. string.gsub(msg.to.print_name, '_', ' ') .. ':\n'
        for k,v in pairs(data[tostring(msg.to.id)]['moderators']) do
          data[tostring(msg.to.id)]['moderators'][tostring(k)] = nil
          save_data(_config.moderation.data, data)
        end
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] لیست مدیران را پاک کرد")
      end
      if matches[2] == 'قوانین' then 
        local data_cat = 'rules'
        data[tostring(msg.to.id)][data_cat] = nil
        save_data(_config.moderation.data, data)
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] قوانین گروه را پاک کرد")
      end
      if matches[2] == 'توضیحات' then 
        local data_cat = 'description'
        data[tostring(msg.to.id)][data_cat] = nil
        save_data(_config.moderation.data, data)
        savelog(msg.to.id, name_log.." ["..msg.from.id.."] توضیحات گروه را پاک کرد")
      end     
    end
    if matches[1] == 'خراب کردن' and matches[2] == 'گروه' then
      if not is_admin(msg) then
          return nil
      end
      if not is_realm(msg) then
          local receiver = get_receiver(msg)
          return modrem(msg),
          print("در حال بستن گروه..."),
          chat_info(receiver, killchat, {receiver=receiver})
      else
          return 'این یک گروه ریلم هست'
      end
   end
    if matches[1] == 'خراب کردن' and matches[2] == 'ریلم' then
     if not is_admin(msg) then
         return nil
     end
     if not is_group(msg) then
        local receiver = get_receiver(msg)
        return realmrem(msg),
        print("در حال بستن گروه ریلم..."),
        chat_info(receiver, killrealm, {receiver=receiver})
     else
        return 'این یک گروه هست'
     end
   end
    if matches[1] == 'راهنما' then
      if not is_momod(msg) or is_realm(msg) then
        return
      end
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] از دستور *راهنما* استفاده کرد")
      return help()
    end
    if matches[1] == 'درمورد' or matches[1] == 'ای دی' then 
      local cbres_extra = {
        chatid = msg.to.id
      }
      local username = matches[2]
      local username = username:gsub("@","")
      savelog(msg.to.id, name_log.." ["..msg.from.id.."] از دستور *درمورد* استفاده کرد "..username)
      return res_user(username,  callbackres, cbres_extra)
    end
    if matches[1] == 'اخراج غیرفعال' then
      --send_large_msg('chat#id'..msg.to.id, 'I\'m in matches[1]')
	    if not is_momod(msg) then
	      return 'فقط مدیران و سازنده قادر به اخراج غیر فعالان هست'
	    end
	    local num = 1
	    if matches[2] then
	        num = matches[2]
	    end
	    local chat_id = msg.to.id
	    local receiver = get_receiver(msg)
      return kick_inactive(chat_id, num, receiver)
    end
  end 
end

return {
	usage ={
		"modadd: Add Group In Moderations.",
		"modadd realm: Add Group As Realm.",
		"modrem: Remove Group Of Moderation.",
		"modrem realm: Removed Realm.",
		"rules: Return Group Rules.",
		"setname: Change Group Name.",
		"about: Return Group About.",
		"setphoto: Set Group Photo And Lock It.",
		"promote , promote[Reply]: Promote User In Group.",
		"demote , demote[Reply]: Demote Iser In Group.",
		"clean member: Remove All Users In Group.",
		"clean modlist: Demote All Moderation.",
		"clean rules: Clear Rules.",
		"set rules: Set Group Rules.",
		"set about: Set Group About.",
		"lock member: Nobody Can't Add User In Group.",
		"lock name: Nobdy Can't Change Group Name.",
		"lock flood: Banned Spammer If Flood Is Locked.",
		"unlock member: Anyone Can Add User In Group.",
		"unlock name: Anyone Can Change Group Name.",
		"unlock flood: No Action Execute I Spamming.",
		"owner: Return Group Owner Id.",
		"setowner: Set Group Owner.",
		"kill [Chat], kill [Realm]: Removed Group.",
		"setflood: Set Flood Sensitivity.",
		"newlink: Create New Link.",
		"link: Return Active Link For Group.",
		"kickinactive: Kick Users [Last Seen A Long Time Ago] Of Group.",
		"settings: Return Group Settings.",
		},
  patterns = {
  "^(نصب)$",
  "^(نصب) (ریلم)$",
  "^(صلب)$",
  "^(صلب) (ریلم)$",
  "^(قوانین)$",
  "^(توضیحات)$",
  "^(نصب اسم) (.*)$",
  "^(نصب عکس)$",
  "^(ارتقا) (.*)$",
  "^(ارتقا)",
  "^(راهنما)$",
  "^(پاک کردن) (.*)$",
  "^(خراب کردن) (گروه)$",
  "^(خراب کردن) (ریلم)$",
  "^(حذف مدیر) (.*)$",
  "^(حذف مدیر)",
  "^(تنظیم) ([^%s]+) (.*)$",
  "^(قفل) (.*)$",
  "^(نصب مالک) (%d+)$",
  "^(نصب مالک)",
  "^(مالک)$",
  "^(درمورد) (.*)$",
  "^(نصب مالک) (%d+) (%d+)$",-- (group id) (owner id)
  "^(باز کردن) (.*)$",
  "^(مسدود) (%d+)$",
  "^(تنظیمات)$",
-- "^[!/](public) (.*)$",
  "^(لیست مدیران)$",
  "^(لینک جدید)$",
  "^(لینک)$",
  "^(اخراج غیرفعال)$",
  "^(اخراج غیرفعال) (%d+)$",
  "^(ای دی) (.*)$",
  "%[(photo)%]",
  "^!!tgservice (.+)$",
  "%[(audio)%]",
  "%[(document)%]",
  "%[(video)%]",
  },
  run = run
}
end



