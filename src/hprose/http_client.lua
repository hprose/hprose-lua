--[[
/**********************************************************\
|                                                          |
|                          hprose                          |
|                                                          |
| Official WebSite: http://www.hprose.com/                 |
|                   http://www.hprose.org/                 |
|                                                          |
\**********************************************************/

/**********************************************************\
 *                                                        *
 * hprose/http_client.lua                                 *
 *                                                        *
 * hprose HTTP Client for Lua                             *
 *                                                        *
 * LastModified: May 14, 2014                             *
 * Author: Ma Bingyao <andot@hprose.com>                  *
 *                                                        *
\**********************************************************/
--]]

local Client = require("hprose.client")
local unpack = unpack
local pairs  = pairs

local HttpClient = Client:new()

HttpClient.keepAlive = true
HttpClient.keepAliveTimeout = 300
HttpClient.proxy = nil
HttpClient.timeout = 30
HttpClient.header = {}

local function writer(content, buffer)
    content.data = content.data .. buffer
    return #buffer
end

require('luacurl')
local c = curl.new()
c:setopt(curl.OPT_HTTP_VERSION, 1.1)
c:setopt(curl.OPT_HEADER, false)
c:setopt(curl.OPT_SSLENGINE_DEFAULT, true)
c:setopt(curl.OPT_SSL_VERIFYPEER, false)
c:setopt(curl.OPT_SSL_VERIFYHOST, 0)
c:setopt(curl.OPT_NOPROGRESS, true)
c:setopt(curl.OPT_NOSIGNAL, true)
c:setopt(curl.OPT_COOKIESESSION, true)
c:setopt(curl.OPT_COOKIEJAR, "cookie")
c:setopt(curl.OPT_COOKIEFILE, "cookie")
c:setopt(curl.OPT_POST, true)
c:setopt(curl.OPT_HEADERFUNCTION, writer)
c:setopt(curl.OPT_WRITEFUNCTION, writer)

function HttpClient:sendAndReceive(data)
    local header = {data = ''}
    local document = {data = ''}
    c:setopt(curl.OPT_URL, self.uri)
    c:setopt(curl.OPT_POSTFIELDS, data)
    c:setopt(curl.OPT_POSTFIELDSIZE, #data)
    c:setopt(curl.OPT_HEADERDATA, header)
    c:setopt(curl.OPT_WRITEDATA, document)
    local headerArray = {'Cache-Control: no-cache'}
    if self.keepAlive then
        headerArray[#headerArray + 1] = "Connection: keep-alive"
        headerArray[#headerArray + 1] = "Keep-Alive: " .. self.keepAliveTimeout
    else
        headerArray[#headerArray + 1] = "Connection: close"
    end
    for name, value in pairs(self.header) do
        headerArray[#headerArray + 1] = name .. ": " .. value
    end
    c:setopt(curl.OPT_HTTPHEADER, unpack(headerArray))
    if self.proxy then
        c:setopt(curl.OPT_PROXY, self.proxy)
    end
    c:perform()
    local response_code = c:getinfo(curl.INFO_RESPONSE_CODE)
    if response_code == 200 then
        return document.data
    else
        error(string.match(header.data, 'HTTP/%d%.%d%s+' .. response_code .. '%s+([^\r]+)'))
    end
end

return HttpClient