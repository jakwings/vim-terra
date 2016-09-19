#!/usr/bin/env terra

local function collect(rules, keys, value, limit)
  local type = terralib.type
  local len = #keys
  local k0 = keys[len]
  if type(k0) == "string" and not string.match(k0, "[^_%w]") then
    local names = {}
    if len < limit and value ~= _G and type(value) == "table" then
      for k, v in pairs(value) do
        if type(k) == "string" and not string.match(k, "[^_%w]") and
            not string.match(k, "^__")
        then
          table.insert(names, k)
          table.insert(keys, k)
          collect(rules, keys, v, limit)
          table.remove(keys)
        end
      end
    end

    local format1 = "syn match   terraPredefined     @\\v<%s>@"
    local format2 = "syn match   terraPredefined     @\\v<%s%%(\\_s*\\.\\_s*%%(%s))?>@"
    local format3 = "syn match   terraPredefined     @\\v<%s%%(\\_s*\\.\\_s*%%(%s))>@"
    local key = table.concat(keys, "\\_s*\\.\\_s*")
    if next(names) ~= nil then
      table.sort(names)
      if len < 2 then
        table.insert(rules, string.format(format2, key, table.concat(names, "|")))
      else
        table.insert(rules, string.format(format3, key, table.concat(names, "|")))
      end
    elseif len == 1 then
      table.insert(rules, string.format(format1, key))
    end
  end
end

local istype = terralib.types.istype
local rules = {}
for k, v in pairs(_G) do
  if not (k == "terra" or istype(v)) then
    collect(rules, {k}, v, 3);
  end
end

table.sort(rules)

print("\" Predefined Variables {")
for i, n in ipairs(rules) do
  print(rules[i])
end
print("hi def link terraPredefined     Identifier")
print("\" Predefined Variables }")
