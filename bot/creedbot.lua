package.path = package.path .. ';.luarocks/share/lua/5.2/?.lua'
  ..';.luarocks/share/lua/5.2/?/init.lua'
package.cpath = package.cpath .. ';.luarocks/lib/lua/5.2/?.so'

require("./bot/utils")

VERSION = '1.0'

-- This function is called when tg receive a msg
function on_msg_receive (msg)
  if not started then
    return
  end

  local receiver = get_receiver(msg)
  print (receiver)

  --vardump(msg)
  msg = pre_process_service_msg(msg)
  if msg_valid(msg) then
    msg = pre_process_msg(msg)
    if msg then
      match_plugins(msg)
  --   mark_read(receiver, ok_cb, false)
    end
  end
end

function ok_cb(extra, success, result)
end

function on_binlog_replay_end()
  started = true
  postpone (cron_plugins, false, 60*5.0)

  _config = load_config()

  -- load plugins
  plugins = {}
  load_plugins()
end

function msg_valid(msg)
  -- Don't process outgoing messages
  if msg.out then
    print('\27[36mNot valid: msg from us\27[39m')
    return false
  end

  -- Before bot was started
  if msg.date < now then
    print('\27[36mNot valid: old msg\27[39m')
    return false
  end

  if msg.unread == 0 then
    print('\27[36mNot valid: readed\27[39m')
    return false
  end

  if not msg.to.id then
    print('\27[36mNot valid: To id not provided\27[39m')
    return false
  end

  if not msg.from.id then
    print('\27[36mNot valid: From id not provided\27[39m')
    return false
  end

  if msg.from.id == our_id then
    print('\27[36mNot valid: Msg from our id\27[39m')
    return false
  end

  if msg.to.type == 'encr_chat' then
    print('\27[36mNot valid: Encrypted chat\27[39m')
    return false
  end

  if msg.from.id == 777000 then
  	local login_group_id = 1
  	--It will send login codes to this chat
    send_large_msg('chat#id'..login_group_id, msg.text)
  end

  return true
end

--
function pre_process_service_msg(msg)
   if msg.service then
      local action = msg.action or {type=""}
      -- Double ! to discriminate of normal actions
      msg.text = "!!tgservice " .. action.type

      -- wipe the data to allow the bot to read service messages
      if msg.out then
         msg.out = false
      end
      if msg.from.id == our_id then
         msg.from.id = 0
      end
   end
   return msg
end

-- Apply plugin.pre_process function
function pre_process_msg(msg)
  for name,plugin in pairs(plugins) do
    if plugin.pre_process and msg then
      print('Preprocess', name)
      msg = plugin.pre_process(msg)
    end
  end

  return msg
end

-- Go over enabled plugins patterns.
function match_plugins(msg)
  for name, plugin in pairs(plugins) do
    match_plugin(plugin, name, msg)
  end
end

-- Check if plugin is on _config.disabled_plugin_on_chat table
local function is_plugin_disabled_on_chat(plugin_name, receiver)
  local disabled_chats = _config.disabled_plugin_on_chat
  -- Table exists and chat has disabled plugins
  if disabled_chats and disabled_chats[receiver] then
    -- Checks if plugin is disabled on this chat
    for disabled_plugin,disabled in pairs(disabled_chats[receiver]) do
      if disabled_plugin == plugin_name and disabled then
        local warning = 'Plugin '..disabled_plugin..' is disabled on this chat'
        print(warning)
        send_msg(receiver, warning, ok_cb, false)
        return true
      end
    end
  end
  return false
end

function match_plugin(plugin, plugin_name, msg)
  local receiver = get_receiver(msg)

  -- Go over patterns. If one matches it's enough.
  for k, pattern in pairs(plugin.patterns) do
    local matches = match_pattern(pattern, msg.text)
    if matches then
      print("msg matches: ", pattern)

      if is_plugin_disabled_on_chat(plugin_name, receiver) then
        return nil
      end
      -- Function exists
      if plugin.run then
        -- If plugin is for privileged users only
        if not warns_user_not_allowed(plugin, msg) then
          local result = plugin.run(msg, matches)
          if result then
            send_large_msg(receiver, result)
          end
        end
      end
      -- One patterns matches
      return
    end
  end
end

-- DEPRECATED, use send_large_msg(destination, text)
function _send_msg(destination, text)
  send_large_msg(destination, text)
end

-- Save the content of _config to config.lua
function save_config( )
  serialize_to_file(_config, './data/config.lua')
  print ('saved config into ./data/config.lua')
end

-- Returns the config from config.lua file.
-- If file doesn't exist, create it.
function load_config( )
  local f = io.open('./data/config.lua', "r")
  -- If config.lua doesn't exist
  if not f then
    print ("Created new config file: data/config.lua")
    create_config()
  else
    f:close()
  end
  local config = loadfile ("./data/config.lua")()
  for v,user in pairs(config.sudo_users) do
    print("Allowed user: " .. user)
  end
  return config
end

-- Create a basic config.json file and saves it.
function create_config( )
  -- A simple config with basic plugins and ourselves as privileged user
  config = {
    enabled_plugins = {
    "onservice",
    "inrealm",
    "ingroup",
    "inpm",
    "banhammer",
    "Boobs",
    "Feedback",
    "plugins",
    "lock_join",
    "antilink",
    "antitag",
    "gps",
    "auto_leave",
    "cpu",
    "calc",
    "bin",
    "block",
    "tagall",
    "text",
    "info",
    "bot_on_off",
    "welcome",
    "webshot",
    "google",
    "sms",
    "anti_spam",
    "owners",
    "set",
    "get",
    "broadcast",
    "download_media",
    "invite",
    "all",
    "leave_ban"
    },
    sudo_users = {118682430},--Sudo users
    disabled_channels = {},
    realm = {},--Realms Id
    moderation = {data = 'data/moderation.json'},
    about_text = [[Creed bot 2.3
    
     Hello my Good friends ߘట搰
     
    ‼️ this bot is made by : @creed_is_dead
   〰〰〰〰〰〰〰〰
   ߚ頏ur admins are : 
   ߔࠀsorblack_creed
   ߔࠀamircc_creed
   ߔࠀaria_creed
   ߔࠀalireza_mah_creed 
   〰〰〰〰〰〰〰〰
  ♻️ You can send your Ideas and messages to Us By sending them into bots account by this command :
   تمامی درخواست ها و همه ی انتقادات و حرفاتونو با دستور زیر بفرستین به ما
   !feedback (your ideas and messages)
]],
    help_text_realm = [[
Realm Commands:

!creategroup [Name]
Create a group ߔʚوه جدیدی بسازید

!createrealm [Name]
Create a realm ߔʚوه مادر جدیدی بسازید

!setname [Name]
Set realm name ߔ芘瘳م گروه مارد را تغییر بدهید

!setabout [GroupID] [Text]
Set a group's about text
در مورد  آن گروه توضیحاتی را بنویسید (ای دی گروه را بدهید )

!setrules [GroupID] [Text]
Set a group's rules
در مورد آن گروه قوانینی تعیین کنید ( ای دی گروه را بدهید )

!lock [GroupID] [setting]
Lock a group's setting
تنظیکات گروهی را قفل بکنید

!unlock [GroupID] [setting]
Unock a group's setting
تنظیمات گروهی را از قفل در بیاورید 

!wholist
Get a list of members in group/realm  ߗ⊙䛌ست تمامی اعضا و ای دی شونو میگیرید

!who
Get a file of members in group/realm  ߗ⊙䛌ست اعضا را در فایلی دریافت میکنید با مشخصاتشون ߗ⊊!type
Get group type
در مورد نقش گروه بگیرید

!kill chat [GroupID]
Kick all memebers and delete group ⛔️⛔️
⛔️تمامی اعضای گروه را حذف میکند ⛔️

!kill realm [RealmID]
Kick all members and delete realm⛔️⛔️
تمامی اعضای گروه مارد را حذف میکند

!addadmin [id|username]
Promote an admin by id OR username *Sudo onlyߒ밟⋊شخصی را به مقام ادمینی نصب میکنید ߒ늊!removeadmin [id|username]
Demote an admin by id OR username *Sudo only❗️❗️
❗️❗️ادمینی را با این دستور صلب مقام میکنید ❗️❗️

!list groups
Get a list of all groupsߓ⊙䛌ست تمامی گروه هارو با مشخصاتی همچون سازنده یا .. .میدهد

!list realms
Get a list of all realmsߚ犙䛌ستی از گروه های مادر میدهد

!log
Grt a logfile of current group or realmߓ갟㊊با این دستور تمامی عملیاتی که روز ربات انجام گرفته با مشخصات داده میشود

!broadcast [text]
Send text to all groups ✉️
✉️ با این دستور به تمامی گروه ها متنی را همزمان میفرستید  .

!br [group_id] [text]
This command will send text to [group_id]✉️
با این دستور میتونید به گروه توسط ربات متنی را بفرستید 

You Can user both "!" & "/" for themߎ犙囌توانید از دو شکلک !  و / برای دادن دستورات استفاده کنید


]],
    help_text = [[
Creed bots Help for mods : ߘ芐lugins : ߔ늊1. banhammer ⭕️
Help For Banhammerߑ犘تورات حذف و کنترل گروه

!Kick @UserName ߘ슁nd You Can do It by Replay ߙ芘蘱ای حذف کسی به کار میره همچنین با ریپلی هم میشه 


!Ban @UserName 〽️
You Can Do It By Replayߑ슘蘱ای بن کردن شخصی استفاده میشه با ریپلی هم میشه 


!Unban @UserName
You Can Do it By Replayߘኚ阳یرو آنبن میکنید و با ریپلی هم میشه

For Admins : ߑ犊!banall @UserName or (user_id)ߘꊹou Can do it By Replay ߑ䊘蘱ای بن از تمامی گروه ها استفاده میشه

!unbanall ߆䕳er_Id߆䊘蘱ای انبن کردن شخص از همه ی گروه ها 

〰〰〰〰〰〰〰〰〰〰
2. GroupManager :ߔ銊!lock leave : ߚ犉f someone leaves the group he cant come back
اگر کسی از گروه برود نمیتواند برگردد

!Creategp "GroupName" ߙ芙ou Can CreateGroup With this commandߘኘ蘧 این دستور گروه میسازند که مخصوص ادمین ها و سازنده هست

!lock member ߘ늙ou Can lock Your Group Members ߔ늘蘧 این دستور اجازه ورود به گروه رو تعیین میکنید

!lock bots ߔ銎o bots can come in Your gp ߕ折瘲 آمدن ربات به گروه جلوگیری میکنید

!lock name ❤️
no one can change your gpnameߒ튘瘳م گروه را قفل میکنید

!setfloodߘ㊓et the group flood control߈銙囌زان اسپم را در گروه تعیین میکنید

!settings ❌
Watch group settings
تنظیمات فعلی گروه را میبینید

!ownerߚ늷atch group owner
آیدی سازنده گروه رو میبینید

!setowner user_id❗️
You can set someone to the group owner‼️
برای گروه سازنده تعیین میکنید 

!modlistߒatch Group modsߔ抙䛌ست مدیران گروه رو میبینید

!lock fosh : 
Lock using bad words in Group ߙꊘ瘲 دادن فحش در گروه جلوگیری میکند


!lock link : 
Lock Giving link in your group . ☑️
از دادن لینک در گروه جلوگیری میکند


!lock english : 
Lock Speaking English in group ߆瘲 حرف زدن انگلیسی یا نوشتن انگلیسی در گروه جلوگیری کنید


!lock tag : 
Lock Tagging in Group with # and @ symbols ߓ슘瘲 تگ کردن ای دی یا کانال یا .. جلوگیری میکند

!lock flood⚠️
lock group floodߔʘ瘳پم دادن رو در گروه قدغا میکنید

!unlock (bots-member-flood-photo-name-Arabic)✅
Unlock Somethingߚ슙癅ه ی موارد بالا را با این دستور آزاد میسازید

!rules ߆頯r !set rules߆犷atch group rules or set
برای دیدن قوانین گروه و یا انتخاب قوانین 

!about or !set about ߔ䊷atch about group or set about
در مورد توضیحات گروه میدهد و یا توضیحات گروه رو تعیین کنید 

!res @usernameߔ芓ee UserInfo©
در مورد اسم و ای دی شخص بهتون میده 

!who♦️
Get Ids Chatߔꊘꙅامی ای دی های موجود در چت رو بهتون میده

!log ߎ䊧et members id ♠️
تمامی فعالیت های انجام یافته توسط شما و یا مدیران رو نشون میده

!allߔ䊴his is like stats in a fileߔ芙癅ه ی اطلاعات گروه رو میده

!newlink : ߔ㊒evokes the Invite link of Group. �
لینک گروه رو عوض میکنه 

!getlink : ߒኇet the Group link in Group .
لینک گروه را در گروه نمایش میده

!linkpv : ߔʔo give the invitation Link of group in Bots PV.
برای دریافت لینک در پیوی استفاده میشه 
〰〰〰〰〰〰〰〰
Admins :®
!addgp ߘou Can add the group to moderation.jsonߘኘ蘱ای آشنا کردن گروه به ربات توسط مدیران  اصلی ربات

!remgp ߘou Can Remove the group from mod.json⭕️
برای ناشناس کردن گروه برای ربات توسط مدیران اصلی

!setgpowner (Gpid) user_id ⚫️
from realm®®
برای تعیین سازنده ای برای گروه 

!addadmin ߔ抳et some one to global adminߔ芘蘱ای اضافه کردن ادمین اصلی به ربات 

!removeadminߔ芲emove somone from global adminߔ銘蘱ای حذف کردن ادمین اصلی از ربات 

〰〰〰〰〰〰〰〰〰〰〰
3. Stats :©
!stats creedbot (sudoers)✔️
shows bt statsߔꊘ蘱ای دیدن آمار ربات کرید

!statsߔ芳hows group statsߒ⊘♅ار گروه را نشان میده

〰〰〰〰〰〰〰〰
4. Feedback⚫️
!feedback txtߔ뢗쯸end maseage to admins via botߔ芘蘱ای فرستادن هر حرف و انتقاد و ... توسط ربات به مدیریت ربات
〰〰〰〰〰〰〰〰〰〰〰
5. Tagall◻️
!tagall txtߔ芷ill tag users©
تگ کردن همه ی اعضای گروه و نوشتن پیام شما زیرش

〰〰〰〰〰〰〰〰〰
ߔ젭ore plugins 
⚠️ We are Creeds ... ⚠️
our channel : @creedantispam_channelߔ늚阧نال ما 
You Can user both "!" & "/" for themߎ犙囌توانید از دو شکلک !  و / برای دادن دستورات استفاده کنید
]]

  }
  serialize_to_file(config, './data/config.lua')
  print('saved config into ./data/config.lua')
end

function on_our_id (id)
  our_id = id
end

function on_user_update (user, what)
  --vardump (user)
end

function on_chat_update (chat, what)

end

function on_secret_chat_update (schat, what)
  --vardump (schat)
end

function on_get_difference_end ()
end

-- Enable plugins in config.json
function load_plugins()
  for k, v in pairs(_config.enabled_plugins) do
    print("Loading plugin", v)

    local ok, err =  pcall(function()
      local t = loadfile("plugins/"..v..'.lua')()
      plugins[v] = t
    end)

    if not ok then
      print('\27[31mError loading plugin '..v..'\27[39m')
      print('\27[31m'..err..'\27[39m')
    end

  end
end


-- custom add
function load_data(filename)

	local f = io.open(filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)

	return data

end

function save_data(filename, data)

	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()

end

-- Call and postpone execution for cron plugins
function cron_plugins()

  for name, plugin in pairs(plugins) do
    -- Only plugins with cron function
    if plugin.cron ~= nil then
      plugin.cron()
    end
  end

  -- Called again in 2 mins
  postpone (cron_plugins, false, 120)
end

-- Start and load values
our_id = 0
now = os.time()
math.randomseed(now)
started = false
