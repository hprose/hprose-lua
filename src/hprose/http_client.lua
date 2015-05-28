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
 * LastModified: May 28, 2015                             *
 * Author: Ma Bingyao <andot@hprose.com>                  *
 *                                                        *
\**********************************************************/
--]]

local Client = require("hprose.client")
local http   = require("socket.http")
local ltn12  = require("ltn12")
local concat = table.concat
local error  = error

local HttpClient = Client:new()

function HttpClient:new(uri)
    local o = Client:new(uri)
    setmetatable(o, self)
    self.__index = self
    o.keepAlive = true
    o.keepAliveTimeout = 300
    o.proxy = nil
    o.timeout = 30
    o.header = {}
    return o
end

function HttpClient:sendAndReceive(data)
    http.TIMEOUT = self.timeout
    local resp_body = {}
    local req_header = {}
    for name, value in pairs(self.header) do
      req_header[name] = value
    end
    req_header['content-length'] = data:len()
    req_header['content-type'] = 'text/plain'
    if self.keepAlive then
        req_header['connection'] = 'keep-alive'
        req_header['keep-alive'] = self.keepAliveTimeout
    else
        req_header['connection'] = 'close'
    end
    local resp, resp_code, resp_header, resp_status = http.request{
        url = self.uri,
        sink = ltn12.sink.table(resp_body),
        method = 'POST',
        headers = req_header,
        source = ltn12.source.string(data),
        proxy = self.proxy
    }
    if resp_code == 200 then
        return concat(resp_body)
    else
        error(resp_code .. ': ' .. resp_status)
    end
end

return HttpClient
