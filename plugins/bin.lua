--[[
	binsh by NXij
	https://github.com/NXij/binsh/
	https://github.com/topkecleon/binsh/
	Shell output for telegram-bot.
]]--

do

function run(msg, matches)
  if is_sudo(msg) then
		return (matches[1]):read('*all')
  end
end

return {
  description = 'Run a system command.',
  usage = {
    sudo = {
      '!bin <command>\n'
      ..'\nWARNING:'
      ..'\nThis plugin interfaces with your operating system.'
      ..'\nEven without root privileges, a bad command can be harmful.\n'
      ..'\nOnly for sudoers. Turned off after use.',
    },
  },
  patterns = {
    '^bin (.*)$'
  },
  run = run,
  moderated = true
}

end
