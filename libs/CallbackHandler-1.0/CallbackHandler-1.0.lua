--[[
Name: CallbackHandler-1.0
Revision: $Revision: 1 $
Author: Tekkub Stoutwrithe (tekkub@gmail.com) — compatible subset used by LibSharedMedia-3.0
License: All Rights Reserved, public domain style as the original library
]]

local MAJOR, MINOR = "CallbackHandler-1.0", 7
local lib = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then
    return
end

local function SafeCall(func, ...)
    local ok, err = pcall(func, ...)
    if not ok then
        geterrorhandler()(err)
    end
end

function lib:New(target, register_name, unregister_name, unregister_all_name)
    register_name = register_name or "RegisterCallback"
    unregister_name = unregister_name or "UnregisterCallback"
    unregister_all_name = unregister_all_name or "UnregisterAllCallbacks"

    local events = {}
    local registry = {}

    function registry:Fire(event_name, ...)
        local handlers = events[event_name]
        if not handlers then
            return
        end
        for index = 1, #handlers do
            local entry = handlers[index]
            if type(entry.method) == "function" then
                SafeCall(entry.method, entry.arg or entry.owner, event_name, ...)
            elseif entry.owner and type(entry.owner[entry.method]) == "function" then
                SafeCall(entry.owner[entry.method], entry.owner, event_name, ...)
            end
        end
    end

    target[register_name] = function(owner, event_name, method, arg)
        if type(event_name) ~= "string" then
            error("Usage: RegisterCallback(event, method[, arg])", 2)
        end
        if type(method) ~= "string" and type(method) ~= "function" then
            error("Usage: RegisterCallback(event, method[, arg])", 2)
        end
        local handlers = events[event_name]
        if not handlers then
            handlers = {}
            events[event_name] = handlers
        end
        for index = 1, #handlers do
            if handlers[index].owner == owner then
                handlers[index].method = method
                handlers[index].arg = arg
                return
            end
        end
        handlers[#handlers + 1] = {
            owner = owner,
            method = method,
            arg = arg,
        }
    end

    target[unregister_name] = function(owner, event_name)
        local handlers = events[event_name]
        if not handlers then
            return
        end
        for index = #handlers, 1, -1 do
            if handlers[index].owner == owner then
                table.remove(handlers, index)
            end
        end
    end

    target[unregister_all_name] = function(owner)
        for _, handlers in pairs(events) do
            for index = #handlers, 1, -1 do
                if handlers[index].owner == owner then
                    table.remove(handlers, index)
                end
            end
        end
    end

    return registry
end
