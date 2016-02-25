do
 function run(msg, matches)
 local fuse = 'پیام جدیدی دریافت شد !!\n\nنام کاربریش: @''\n\nآی دی کاربر : ' .. msg.from.id .. '\n\nای دی گروه : ' .. msg.to.id .. '\n\nاسم کاربر: ' .. msg.from.print_name .. '\n\nنظر:\n\n'  .. matches[1]
 local fuses = '!printf user#id' .. msg.from.id
 local text = matches[1]
 local sends = send_msg('user#id118682430', fuse, ok_cb, false)
 return 'نظرات شما به درستی ارسال شد'
 end
end
return {
description = "Feedback",
usage = "feedback message",
patterns = {
 "^(ارسال نظر)(.*)$"
 },
 run = run
}
