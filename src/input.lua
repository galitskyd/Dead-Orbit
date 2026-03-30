-- === input (stat(28) raw keyboard) ===
keys={}

function read_input()
 keys={}
 local n=0
 while stat(28) and n<16 do
  keys[stat(31)]=true
  n+=1
 end
end

function key(k)
 return keys[k]
end
