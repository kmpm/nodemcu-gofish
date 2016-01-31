
srv=net.createServer(net.TCP)


function notFound(conn)
	conn:send("HTTP/1.1 404 file not found\r\nX-Powered-By: GoFish/0.1\r\n")
	conn:close()
end

function getFile(conn, url, method)
	--GET
	log('getFile(' .. url .. ', ' .. method ..')' )
	local DataToGet = 0
    local complete = false
    local function onSent()
        log('onSent')
        if DataToGet>=0 and method=="GET" and not complete then
            if file.open('files/' .. url, "r") then
                file.seek("set", DataToGet)
                local line=file.read(512)
                file.close()
                if line then
                    --log("sending:" .. DataToGet .. line)
                    DataToGet = DataToGet + 512
                    if string.len(line)<512 then
                        complete = true
                    end
                    conn:send(line)
                end
            end
        else 
            conn:close()
            collectgarbage()
            log('sent file')
        end 
    end
    
	conn:on("sent", onSent)
  	
    conn:send("HTTP/1.1 200 OK\r\nX-Powered-By: GoFish/0.1\r\n\r\n")
end

function getTable(conn, url, response)
    local function onSent()
        log('rows left' .. #response)
        if #response >0 then conn:send(table.remove(response,1))
        else 
            conn:close()
            collectgarbage()
        end
    end
    conn:on("sent", onSent)
    conn:send("HTTP/1.1 200 OK\r\nX-Powered-By: GoFish/0.1\r\n\r\n")
end

function getStatus(conn, url, method)
    log('getStatus')
	--conn:send("Content-Type: text/html; charset=utf-8\r\n")
	--majorVer, minorVer, devVer, chipid, flashid, flashsize, flashmode, flashspeed = node.info();
	local response = {"<html><body><h1>System status</h1>", 
        "<p>Free memory: " .. node.heap() .. " Bytes</p>",
        "<p>Chip Id: " .. chipid .. "</p>",
        "<p>Flash Size: " .. flashsize .. " kBytes</p>",
        "<p>Node Version: " .. majorVer .. "." .. minorVer .. "." .. devVer .. "</p>",
        "<p>System uptime: " .. tmr.now()/1000000 .. " seconds </p>",
        "<p>Last msg:" .. last_msg .. "</p>",
        "</body></html>"}
    getTable(conn, url, response)
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
		log(method, url, vars)
	end

	if url==nil or url=="" then
        log('no url requested')
		url="index.htm"
	end
    
    log('url:' .. url)
	-- some ugly magic for Apple IOS Devices
	if string.find(url, "/") ~= nil then
	   log("Slash found")
	   local invurl=string.reverse(url)
	   local a,b=string.find(invurl, "/", 1)
	   url=string.sub(url, string.len(url)-(a-2))
	   log("Neue URL= " .. url)
	end

	if string.len(url)>= 25 then
		url = string.sub (url,1,25)
	   log("url trimmed to max 25:" .. url)
	end

	log("route:" .. url)
	local route = routes[url]
	log("got a route")
	if (route ~= nil) then
		log("route found")
        
        route(conn, url, method) 
        
	else
		log("not found: 404")
		notFound(conn)
	end
end

conn:on("receive", httpReceive)


end)

log("HTTP Server is now listening. Free Heap:" .. node.heap())
