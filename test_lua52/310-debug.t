#! /usr/bin/lua
--
-- lua-TestMore : <http://fperrad.github.com/lua-TestMore/>
--
-- Copyright (C) 2009-2010, Perrad Francois
--
-- This code is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--

--[[

=head1 Lua Debug Library

=head2 Synopsis

    % prove 310-debug.t

=head2 Description

Tests Lua Debug Library

See "Lua 5.2 Reference Manual", section 6.10 "The Debug Library",
L<http://www.lua.org/manual/5.2/manual.html#6.10>.

See "Programming in Lua", section 23 "The Debug Library".

=cut

]]

require 'Test.More'

plan(26)

debug = require 'debug'

if arg[-1] == 'luajit' then
    skip("LuaJIT: getuservalue", 2)
else
    local u = debug.getuservalue(require 'io'.stdout)
    type_ok(u, 'table', "function getuservalue")
    u = debug.getuservalue(debug)
    is(u, nil)
end

hook = debug.gethook()
is(hook, nil, "function gethook")

info = debug.getinfo(is)
type_ok(info, 'table', "function getinfo (function)")
is(info.func, is, " .func")

info = debug.getinfo(1)
type_ok(info, 'table', "function getinfo (level)")
like(info.func, "^function: [0]?[Xx]?%x+", " .func")

is(debug.getinfo(12), nil, "function getinfo (too depth)")

error_like(function () debug.getinfo('bad') end,
           "bad argument #1 to 'getinfo' %(function or level expected%)",
           "function getinfo (bad arg)")

local name, value = debug.getlocal(0, 1)
type_ok(name, 'string', "function getlocal (level)")
is(value, 0)

error_like(function () debug.getlocal(42, 1) end,
           "bad argument #1 to 'getlocal' %(level out of range%)",
           "function getlocal (out of range)")

if arg[-1] == 'luajit' then
    skip("LuaJIT: getlocal (func)", 2)
else
    local name, value = debug.getlocal(like, 1)
    type_ok(name, 'string', "function getlocal (func)")
    is(value, nil)
end

t = {}
is(debug.getmetatable(t), nil, "function getmetatable")
t1 = {}
setmetatable(t, t1)
is(debug.getmetatable(t), t1)

local reg = debug.getregistry()
type_ok(reg, 'table', "function getregistry")
type_ok(reg._LOADED, 'table')

local name = debug.getupvalue(plan, 1)
type_ok(name, 'string', "function getupvalue")

if arg[-1] == 'luajit' then
    skip("LuaJIT: setuservalue", 3)
else
    local u = io.tmpfile()
    local old = debug.getuservalue(u)
    r = debug.setuservalue(u, nil)
    is(r, u, "function setuservalue")
    is(debug.getuservalue(u), nil)
    r = debug.setuservalue(u, old)
    is(debug.getuservalue(u), old)
end

t = {}
t1 = {}
is(debug.setmetatable(t, t1), true, "function setmetatable")
is(getmetatable(t), t1)

like(debug.traceback(), "^stack traceback:\n", "function traceback")

like(debug.traceback("message\n"), "^message\n\nstack traceback:\n", "function traceback with message")

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4:
