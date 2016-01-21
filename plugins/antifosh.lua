


local function run(msg)
    
    local data = load_data(_config.moderation.data)
    
     if data[tostring(msg.to.id)]['settings']['antifosh'] == 'yes' then
      
    
if not is_momod(msg) then
    
    
chat_del_user('chat#id'..msg.to.id, 'user#id'..msg.from.id, ok_cb, true)
    local msgads = 'Dont say bad words here '
   local receiver = msg.to.id
    send_large_msg('chat#id'..receiver, msgads.."\n", ok_cb, false)
	
      end
   end
end
    
return {patterns = {
"[Kk][Oo][Ss][Nn][Aa][Nn][Tt]",
"[Kk][Oo][Nn][Ii]",
"[Kk][Ii][Rr][Ii]",
"[Kk][Ii][Rr]",
"[Jj][Ee][Nn][Dd][Ee]",
"[Kk][Hh][Aa][Rr]",
"[Kk][Oo][Ss][Ii]",
"کونی",
"کیری",
"کسکش",
"کونده",
"جنده",
"کس ننه",
"گاییدم",
"نگاییدم",
"بگا",
"گاییدن",
"دیوث",
"اوبی",
"قحبه",
"بسیک",
"سیکتر",
"سیک",
"خوارکسته",
"خوارکسده",
}, run = run}
