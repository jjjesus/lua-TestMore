#! /usr/bin/lua
--
-- lua-TestMore : <http://fperrad.github.com/lua-TestMore/>
--
-- Copyright (C) 2010, Perrad Francois
--
-- This code is licensed under the terms of the MIT/X11 license,
-- like Lua itself.
--

--[[

=head1 Lua Lexicography

=head2 Synopsis

    % prove 203-lexico.t

=head2 Description

See "Lua 5.2 Reference Manual", section 3.1 "Lexical Conventions",
L<http://www.lua.org/manual/5.2/manual.html#3.1>.

=cut

--]]

require 'Test.More'

plan(35)

is("\65", "A")
is("\065", "A")
is("\x41", "A")
is("\x3d", "=")
is("\x3D", "=")

is(string.byte("\a"), 7)
is(string.byte("\b"), 8)
is(string.byte("\f"), 12)
is(string.byte("\n"), 10)
is(string.byte("\r"), 13)
is(string.byte("\t"), 9)
is(string.byte("\v"), 11)
is(string.byte("\\"), 92)

is(string.len("A\0B"), 3)

f, msg = loadstring [[a = "A\300"]]
like(msg, "^[^:]+:%d+: .- escape .- near")

f, msg = loadstring [[a = "A\xyz"]]
like(msg, "^[^:]+:%d+: .- near")

f, msg = loadstring [[a = " unfinished string ]]
like(msg, "^[^:]+:%d+: unfinished string near")

f, msg = loadstring [[a = " unfinished string
]]
like(msg, "^[^:]+:%d+: unfinished string near")

f, msg = loadstring [[a = " unfinished string \
]]
like(msg, "^[^:]+:%d+: unfinished string near")

f, msg = loadstring [[a = " unfinished string \]]
like(msg, "^[^:]+:%d+: unfinished string near")

f, msg = loadstring "a = [[ unfinished long string "
like(msg, "^[^:]+:%d+: unfinished long string near")

f, msg = loadstring "a = [== invalid long string delimiter "
like(msg, "^[^:]+:%d+: invalid long string delimiter near")

a = 'alo\n123"'
is('alo\n123"', a)
is("alo\n123\"", a)
is('\97lo\10\04923"', a)
is([[alo
123"]], a)
is([==[
alo
123"]==], a)
is("alo\n\*
123\"", a)

f, msg = loadstring [[a = " escape \* unauthorized
new line" ]]
like(msg, "^[^:]+:%d+: unfinished string near")

is(3.0, 3)
is(314.16e-2, 3.1416)
is(0.31416E1, 3.1416)
is(0xff, 255)
is(0x56, 86)

--[===[
--[[
--[=[
    nested long comments
--]=]
--]]
--]===]

f, msg = loadstring "  --[[ unfinished long comment "
like(msg, "^[^:]+:%d+: unfinished long comment near")

-- Local Variables:
--   mode: lua
--   lua-indent-level: 4
--   fill-column: 100
-- End:
-- vim: ft=lua expandtab shiftwidth=4:
