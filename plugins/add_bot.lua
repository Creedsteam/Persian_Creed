--[[
Bot can join into a group by replying a message contain an invite link or by
typing !add [invite link].
URL.parse cannot parsing complicated message. So, this plugin only works for
single [invite link] in a post.
[invite link] may be preceeded but must not followed by another characters.
--]]

do

  local function parsed_url(link)
    local parsed_link = URL.parse(link)
    local parsed_path = URL.parse_path(parsed_link.path)
    i = 0
    for k,segment in pairs(parsed_path) do
      i = i + 1
      if segment == 'joinchat' then
        invite_link = string.gsub(parsed_path[i+1], '[ %c].+$', '')
        break
      end
    end
    return invite_link
  end

  local function action_by_reply(extra, success, result)
    local hash = parsed_url(result.text)
    join = import_chat_link(hash, ok_cb, false)
  end

  function run(msg, matches)
    if is_sudo(msg) then
      if msg.reply_id then
        msgr = get_message(msg.reply_id, action_by_reply, {msg=msg})
      elseif matches[1] then
        local hash = parsed_url(matches[1])
        join = import_chat_link(hash, ok_cb, false)
      end
    end
  end

  return {
    description = 'Invite the bot into a group chat via its invite link.',
    usage = {
      '!AddBot : Join a group by replying a message containing invite link.',
      '!AddBot [invite_link] : Join into a group by providing their [invite_link].'
      },
    patterns = {
      '^[/!](addBot)$',
      '^[/!](ddBot) (.*)$'
    },
    run = run
  }

end
