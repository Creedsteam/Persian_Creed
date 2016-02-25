local function set_bot_photo(msg, success, result)
  local receiver = get_receiver(msg)
  if success then
    local file = 'data/photos/bot.jpg'
    print('فایل دانلود شد به:', result)
    os.rename(result, file)
    print('فایل انتقال یافت به:', file)
    set_profile_photo(file, ok_cb, false)
    send_large_msg(receiver, 'عکس تغییر یافت', ok_cb, false)
    redis:del("bot:photo")
  else
    print('Error downloading: '..msg.id)
    send_large_msg(receiver, 'ناموفق شد . لطفا بعدا امتحان کنید', ok_cb, false)
  end
end
local function parsed_url(link)
  local parsed_link = URL.parse(link)
  local parsed_path = URL.parse_path(parsed_link.path)
  return parsed_path[2]
end
local function get_contact_list_callback (cb_extra, success, result)
  local text = " "
  for k,v in pairs(result) do
    if v.print_name and v.id and v.phone then
      text = text..string.gsub(v.print_name ,  "_" , " ").." ["..v.id.."] = "..v.phone.."\n"
    end
  end
  local file = io.open("contact_list.txt", "w")
  file:write(text)
  file:flush()
  file:close()
  send_document("user#id"..cb_extra.target,"contact_list.txt", ok_cb, false)--.txt format
  local file = io.open("contact_list.json", "w")
  file:write(json:encode_pretty(result))
  file:flush()
  file:close()
  send_document("user#id"..cb_extra.target,"contact_list.json", ok_cb, false)--json format
end
local function user_info_callback(cb_extra, success, result)
  result.access_hash = nil
  result.flags = nil
  result.phone = nil
  if result.username then
    result.username = '@'..result.username
  end
  result.print_name = result.print_name:gsub("_","")
  local text = serpent.block(result, {comment=false})
  text = text:gsub("[{}]", "")
  text = text:gsub('"', "")
  text = text:gsub(",","")
  if cb_extra.msg.to.type == "chat" then
    send_large_msg("chat#id"..cb_extra.msg.to.id, text)
  else
    send_large_msg("user#id"..cb_extra.msg.to.id, text)
  end
end
local function get_dialog_list_callback(cb_extra, success, result)
  local text = ""
  for k,v in pairs(result) do
    if v.peer then
      if v.peer.type == "chat" then
        text = text.."group{"..v.peer.title.."}["..v.peer.id.."]("..v.peer.members_num..")"
      else
        if v.peer.print_name and v.peer.id then
          text = text.."user{"..v.peer.print_name.."}["..v.peer.id.."]"
        end
        if v.peer.username then
          text = text.."("..v.peer.username..")"
        end
        if v.peer.phone then
          text = text.."'"..v.peer.phone.."'"
        end
      end
    end
    if v.message then
      text = text..'\nlast msg >\nmsg id = '..v.message.id
      if v.message.text then
        text = text .. "\n text = "..v.message.text
      end
      if v.message.action then
        text = text.."\n"..serpent.block(v.message.action, {comment=false})
      end
      if v.message.from then
        if v.message.from.print_name then
          text = text.."\n از طرف > \n"..string.gsub(v.message.from.print_name, "_"," ").."["..v.message.from.id.."]"
        end
        if v.message.from.username then
          text = text.."( "..v.message.from.username.." )"
        end
        if v.message.from.phone then
          text = text.."' "..v.message.from.phone.." '"
        end
      end
    end
    text = text.."\n\n"
  end
  local file = io.open("dialog_list.txt", "w")
  file:write(text)
  file:flush()
  file:close()
  send_document("user#id"..cb_extra.target,"dialog_list.txt", ok_cb, false)--.txt format
  local file = io.open("dialog_list.json", "w")
  file:write(json:encode_pretty(result))
  file:flush()
  file:close()
  send_document("user#id"..cb_extra.target,"dialog_list.json", ok_cb, false)--json format
end
local function run(msg,matches)
    local data = load_data(_config.moderation.data)
    local receiver = get_receiver(msg)
    local group = msg.to.id
    if not is_admin(msg) then
    	return
    end
    if msg.media then
      	if msg.media.type == 'photo' and redis:get("bot:photo") then
      		if redis:get("bot:photo") == 'waiting' then
        		load_photo(msg.id, set_bot_photo, msg)
      		end
      	end
    end
    if matches[1] == "نصب عکس ربات" then
    	redis:set("bot:photo", "waiting")
    	return 'لطفا عکس جدید را ارسال کنید'
    end
    if matches[1] == "خواندن" then
    	if matches[2] == "روشن" then
    		redis:set("bot:markread", "on")
    		return "پیام ها خوانده میشوند"
    	end
    	if matches[2] == "خاموش" then
    		redis:del("bot:markread")
    		return "پیام ها خوانده نمیشوند"
    	end
    	return
    end
    if matches[1] == "پیام به" then
    	send_large_msg("user#id"..matches[2],matches[3])
    	return "Msg sent"
    end
    if matches[1] == "بلاک" then
    	if is_admin2(matches[2]) then
    		return "شما قادر به بلاک کردن ادمین ها نیستید"
    	end
    	block_user("user#id"..matches[2],ok_cb,false)
    	return "کاربر بلاک شد از ربات"
    end
    if matches[1] == "آنبلاک" then
    	unblock_user("user#id"..matches[2],ok_cb,false)
    	return "کاربر از ربات آنبلاک شد"
    end
    if matches[1] == "جوین" then--join by group link
    	local hash = parsed_url(matches[2])
    	import_chat_link(hash,ok_cb,false)
    end
    if matches[1] == "مخاطبان" then
      get_contact_list(get_contact_list_callback, {target = msg.from.id})
      return "من لیست مخاطبانم را به پیوی شما فرستادم"
    end
    if matches[1] == "حذف مخاطب" then
      del_contact("user#id"..matches[2],ok_cb,false)
      return "کاربره "..matches[2].." از لیست مخاطبانم حذف شد"
    end
    if matches[1] == "لیست مکالمه" then
      get_dialog_list(get_dialog_list_callback, {target = msg.from.id})
      return "من لیست مالکمه را به پیام شخصی شما فرستادم"
    end
    if matches[1] == "کیست" then
      user_info("user#id"..matches[2],user_info_callback,{msg=msg})
    end
    if matches[1] == "sync_gbans" then
    	if not is_sudo(msg) then-- Sudo only
    		return
    	end
    end
    return
end
return {
  patterns = {
	"^(پیام به) (%d+) (.*)$",
	"^(جوین) (.*)$",
	"^(آنبلاک) (%d+)$",
	"^(بلاک) (%d+)$",
	"^(خواندن) (روشن)$",
	"^(خواندن) (خاموش)$",
	"^(تنظیم عکس ربات)$",
	"%[(photo)%]",
	"^(مخاطبان)$",
	"^(لیست مکالمه)$",
	"^(حذف مخاطب) (%d+)$",
	"^(کیست) (%d+)$",
  },
  run = run,
}
--By @imandaneshi :)
--https://github.com/SEEDTEAM/TeleSeed/blob/master/plugins/admin.lua
