
srv=net.createServer(net.TCP)




function notFound(conn)
	conn:send("HTTP/1.1 404 file not found")
	conn:close()
end

function getFile(conn, url, method)
	--GET
	-- print("getFile")
	local DataToGet = 0
	conn:send("\r\n")
	conn:on("sent", function(conn)
		if DataToGet>=0 and method=="GET" then
			if file.open(url, "r") then
				file.seek("set", DataToGet)
				local line=file.read(512)
				file.close()
				if line then
					conn:send(line)
					-- print ("sending:" .. DataToGet)
					DataToGet = DataToGet + 512
					if (string.len(line)==512) then
						return
					end
				end
			end
		end
		conn:close()
		-- print("gotFile")
  	end)
end

function getStatus(conn, url, method)
	conn:send("Content-Type: text/html; charset=utf-8\r\n")
	majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info();
	conn:send("\r\n<html><body><h1>System status</h1>")
	conn:send("<p>Free memory: " .. node.heap() .. " Bytes</p>")
	conn:send("<p>Chip Id: " .. chipid .. "</p>")
	conn:send("<p>Flash Size: " .. flashsize .. " kBytes</p>")
	conn:send("<p>Node Version: " .. majorVer .. "." .. minorVer .. "." .. devVer .. "</p>")
	conn:send("<p>System uptime: " .. tmr.now()/1000000 .. " seconds </p>")
	conn:send("<p>Last msg:" .. last_msg .. "</p>")
	conn:send("</body></html>")
	conn:close()
end

local routes= {
	["index.htm"] = getFile,
	["status.htm"] = getStatus
}

srv:listen(80, function(conn)

local rnrn=0
local Status = 0

local method=""
local url=""
local vars=""
local sending = false


function httpReceive(conn, payload)
	if Status==0 then
		_, _, method, url, vars = string.find(payload, "([A-Z]+) /([^?]*)%??(.*) HTTP")
		-- print(method, url, vars)
	end

	if url==nil then
		url="index.htm"
	end

	if url=="" then
		url="index.htm"
	end

	-- some ugly magic for Apple IOS Devices
	if string.find(url, "/") ~= nil then
	 --print ("Slash found")
	 local invurl=string.reverse(url)
	 local a,b=string.find(invurl, "/", 1)
	 url=string.sub(url, string.len(url)-(a-2))
	 --print ("Neue URL= " .. url)
	end

	if string.len(url)>= 25 then
		url = string.sub (url,1,25)
	--	print ("cut down URL")
	end

	-- print("route:" .. url)
	local route = routes[url]
	-- print("got a route")
	if (route ~= nil) then
		-- print("route found")
		conn:send("HTTP/1.1 200 OK\r\nX-Powered-By: GoFish/0.1\r\n")
		route(conn, url, method)
	else
		-- print("not found: 404")
		notFound(conn)
	end


end

conn:on("receive", httpReceive)


end)


print("HTTP Server is now listening. Free Heap:", node.heap())