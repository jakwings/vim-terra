#!/usr/bin/env terra

local istype = terralib.types.istype
local types = {}
local others = {}

for k, v in pairs(terralib.types) do
  if type(k) == "string" and istype(v) then
    if rawget(_G, k) == v then
      table.insert(types, k)
    else
      table.insert(others, k)
    end
  end
end

print("\" Builtin Types {")
if next(types) ~= nil then
  table.sort(types)
  print("syn keyword terraType           " .. table.concat(types, " "))
end
if next(others) ~= nil then
  table.sort(others)
  local fmt = "syn match   terraType           " ..
      "@\\v<terralib\\_s*\\.\\_s*types\\_s*\\.\\_s*%%(%s)>@"
  print(string.format(fmt, table.concat(others, "|")))
end
print("hi def link terraType           Type")
print("\" Builtin Types }")
