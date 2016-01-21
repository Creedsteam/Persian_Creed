do

  local function googlethat(query)
    local url        = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&safe=active&&rsz=5&'
    local parameters = 'q='..(URL.escape(query) or '')

    -- Do the request
    local res, code = https.request(url..parameters)
    if code ~=200 then return nil  end
    local data = json:decode(res)

    local results = {}
    for key,result in ipairs(data.responseData.results) do
      table.insert(results, {
        result.titleNoFormatting,
        result.unescapedUrl or result.url
      })
    end
    return results
  end

  local function stringlinks(results)
    local stringresults=''
    i = 0
    for key,val in ipairs(results) do
      i = i+1
      stringresults=stringresults..i..'. '..val[1]..'\n'..val[2]..'\n'
    end
    return stringresults
  end

  local function run(msg, matches)
    -- comment this line if you want this plugin works in private message.
    if not is_chat_msg(msg) then return nil end

    local results = googlethat(matches[1])
    return stringlinks(results)
  end

  return {
    description = 'Returns five results from Google. Safe search is enabled by default.',
    usage = ' !google [terms]: Searches Google and send results',
    patterns = {
      '^!google (.*)$',
      '^%.[g|G]oogle (.*)$'
    },
    run = run
  }

end
