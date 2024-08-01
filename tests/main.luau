local dict = require(script.Parent.Dict)

local new = dict()

print(new:get(1)) -- nil

new:set("myKey", "myVal") -- or you can just do `new[myKey] = "myVal"`

print(new:get(1)) -- myVal

new:set("myKey2", "myVal2")
new:set("myKey3", "myVal3")

print(new:slice(1, 2)) --  { myKey = myVal, myKey2 = myVal2 }

print(new:values()) --  { myVal, myVal2, myVal3 }
print(new:keys()) -- { myKey, myKey2, myKey3 }

print(new:len()) -- 3
print(#new) -- 3

local new2 = dict {myKey3 = "myKey3", myKey4 = "myVal4"}

print(new + new2) -- { myKey = myVal, myKey2 = myVal2, myKey3 = myVal3, myKey4 = myVal4 }
print(new - new2) -- { myKey = myVal, myKey2 = myVal2 }

-- ...
