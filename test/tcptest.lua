local hprose = require("hprose")
local client = hprose.TcpClient:new("tcp://127.0.0.1:4321")
client.timeout = 30000
local stub = client:useService()
print(stub.hello('world'))
print(stub.hello('hprose'))
