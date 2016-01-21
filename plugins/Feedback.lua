do

function run(msg, matches)

local fuse = '#DearAdminًںکœ we have recived a new feedback just now : #newfeedback \n\nid : ' .. msg.from.id .. '\n\nName : ' .. msg.from.print_name ..'\n\nusernameâ–¶ï¸ڈ :@ ' .. msg.from.username  ..'\n\pmn :\n\n\n' .. matches[1] 
local fuses = '!printf user#id' .. msg.from.id


    local text = matches[1]
 bannedidone = string.find(msg.from.id, '123')
        bannedidtwo =string.find(msg.from.id, '465')       
   bannedidthree =string.find(msg.from.id, '678')  


        print(msg.to.id)

        if bannedidone or bannedidtwo or bannedidthree then                    --for banned people
                return 'You are banned to send a feedback'
 else


                 local sends0 = send_msg('chat#82481072', fuse, ok_cb, false)

 return 'Your request has been sended to The Moderators ! '

     

end

end
return {
  description = "Feedback",

  usage = "!feedback : send maseage to admins with bot",
  patterns = {
    "^![Ff]eedback (.*)$"

  },
  run = run
}

end
