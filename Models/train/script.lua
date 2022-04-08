--for key, value in pairs(vanilla_model) do
--    value.setEnabled(false)
--end
local MinecartDir = model.Mounts.Minecart
local Mounts = model.Mounts
local RailState = {
  "north_south",--1
  "east_west",--2
  "ascending_east",--3
  "ascending_west",--4
  "ascending_north",--5
  "ascending_south",--6
  "south_east",--7
  "south_west",--8
  "north_east",--9
  "north_west"--10
}
local RailTypes = {
  "minecraft:rail",
  "minecraft:powered_rail",
  "minecraft:detector_rail",
  "minecraft:activator_rail"
}
Mounts.setParentType("WORLD")
MinecartDir.PlayerDoll.setTexture("Skin")
MinecartDir.PlayerDoll.setPos({0,-17,10})
function player_init()
  lastPos = player.getPos()
end
function InMine(x)
  if x and x.getType() == "minecraft:minecart" then
    for key, value in pairs(vanilla_model) do
        value.setEnabled(false)
    end
    camera.FIRST_PERSON.setPos({0,0.7,1})
    camera.THIRD_PERSON.setPos({0,0.7,1})
    if renderer.isFirstPerson() then
      MinecartDir.PlayerDoll.setEnabled(false)
    else
      MinecartDir.PlayerDoll.setEnabled(true)
    end
  else
    for key, value in pairs(vanilla_model) do
        value.setEnabled(true)
    end
    camera.FIRST_PERSON.setPos({0,0,0})
    camera.THIRD_PERSON.setPos({0,0,0})
  end
end
function getVel()
  newPos = player.getPos()
  local moved = newPos - lastPos
  Vel = moved * 20
  lastPos = newPos
  --log(Vel)
end
function Rails(x) --Rail blockstate stuff
  local vehi = player.getVehicle()
  local Ppos = player.getPos()
  local BlocksPos = {
    --[[back]]vectors.of({Ppos.x,Ppos.y+0.5,Ppos.z+1}),--1 Back top
      vectors.of({Ppos.x,Ppos.y+0.4,Ppos.z+1}),--2 Back mid
      vectors.of({Ppos.x,Ppos.y-1,Ppos.z+1}),--3 Back bot
    --[[left]]vectors.of({Ppos.x-1,Ppos.y+0.5,Ppos.z}),--4 left top
      vectors.of({Ppos.x-1,Ppos.y+0.4,Ppos.z}),--5 Left mid
      vectors.of({Ppos.x-1,Ppos.y-1,Ppos.z}),--6 left bot
    --[[right]]vectors.of({Ppos.x+1,Ppos.y+0.5,Ppos.z}),--7 Right top
      vectors.of({Ppos.x+1,Ppos.y+0.4,Ppos.z}),--8 Right mid
      vectors.of({Ppos.x+1,Ppos.y-1,Ppos.z}),--9 Right bot
    --[[front]]vectors.of({Ppos.x,Ppos.y+0.5,Ppos.z-1}),--10 Front top
      vectors.of({Ppos.x,Ppos.y+0.4,Ppos.z-1}),--11 Front mid
      vectors.of({Ppos.x,Ppos.y-1,Ppos.z-1}),--12 Front bot
  }
  local BlockPos = vectors.of({Ppos.x,Ppos.y+0.4,Ppos.z})
  local blockstate = world.getBlockState(BlockPos)
  for i=1,4 do
    if (blockstate.name == RailTypes[i]) and vehi ~= nil then
      --golbal shit
        --front
          if world.getBlockState({BlocksPos[11]}).name == RailTypes[i] then
            front = world.getBlockState({BlocksPos[11]}).properties.shape
          end
          if world.getBlockState({BlocksPos[10]}).name == RailTypes[i] then
            Ftop = world.getBlockState({BlocksPos[10]}).properties.shape
          end
          if world.getBlockState({BlocksPos[12]}).name == RailTypes[i] then
            Fbot = world.getBlockState({BlocksPos[12]}).properties.shape
          end
        --back 
          if world.getBlockState({BlocksPos[2]}).name == RailTypes[i] then
            back = world.getBlockState({BlocksPos[2]}).properties.shape
          end
          if world.getBlockState({BlocksPos[1]}).name == RailTypes[i] then
            Btop = world.getBlockState({BlocksPos[1]}).properties.shape
          end
          if world.getBlockState({BlocksPos[3]}).name == RailTypes[i] then
            Bbot = world.getBlockState({BlocksPos[3]}).properties.shape
          end
        --left
          if world.getBlockState({BlocksPos[5]}).name == RailTypes[i] then
            left = world.getBlockState({BlocksPos[5]}).properties.shape
          end
          if world.getBlockState({BlocksPos[4]}).name == RailTypes[i] then
            Ltop = world.getBlockState({BlocksPos[4]}).properties.shape
          end
          if world.getBlockState({BlocksPos[6]}).name == RailTypes[i] then
            Lbot = world.getBlockState({BlocksPos[6]}).properties.shape
          end
        --right
          if world.getBlockState({BlocksPos[8]}).name == RailTypes[i] then
            right = world.getBlockState({BlocksPos[8]}).properties.shape
          end
          if world.getBlockState({BlocksPos[7]}).name == RailTypes[i] then
            Rtop = world.getBlockState({BlocksPos[7]}).properties.shape
          end
          if world.getBlockState({BlocksPos[9]}).name == RailTypes[i] then
            Rbot = world.getBlockState({BlocksPos[9]}).properties.shape
          end
      RShape = blockstate.properties.shape
    end 
  end
  if RShape == RailState[1] then --North_south
    --straight
      if (front == RailState[1] and back == RailState[1]) and Vel.z < 0 then --Going North
        MinecartDir.setRot({0,0,0})
      elseif (front == RailState[1] and back == RailState[1]) and Vel.z > 0 then --Going South
        MinecartDir.setRot({0,180,0})
    --from left
      elseif back == RailState[9] and Vel.z < 0 then --Going North from left-
        lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,0,0},x)
      elseif front == RailState[8] and Vel.z > 0 then --Going South from left
        lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,180,0},x)
    --from right
      elseif back == RailState[10] and Vel.z < 0 then --Going North from right-
        lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,0,0},x)
      elseif front == RailState[7] and Vel.z > 0 then --Going South fron right
        lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,180,0},x)
    --to right
      elseif (front == RailState[7] and back == RailState[1]) and Vel.z < 0 then --Going North right
        MinecartDir.setRot({0,0,0})
      elseif (front == RailState[1] and back == RailState[10]) and Vel.z > 0 then --Going South right-
        MinecartDir.setRot({0,180,0})
    --to left
      elseif (front == RailState[8] and back == RailState[1]) and Vel.z < 0 then --Going North right
        MinecartDir.setRot({0,0,0})
      elseif (front == RailState[1] and back == RailState[9]) and Vel.z > 0 then --Going South right-
        MinecartDir.setRot({0,180,0})
      end
  elseif RShape == RailState[2] then --East_West
    --straight
      if (left == RailState[2] and right == RailState[2]) and Vel.x > 0 then --Going East
        MinecartDir.setRot({0,-90,0})
      elseif (left == RailState[2] and right == RailState[2]) and Vel.x < 0 then --Going West
        MinecartDir.setRot({0,90,0})
    --from left
      elseif right == RailState[10] and Vel.x < 0 then --Going West from left-
        lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,90,0},x)
      elseif left == RailState[7] and Vel.x > 0 then --Going East from left
        lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,-90,0},x)
    --from right
      elseif right == RailState[8] and Vel.x < 0 then --Going west from right
        lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,90,0},x)
      elseif left == RailState[9] and Vel.x > 0 then --Going east from right-
        lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,270,0},x)
    --to right
      elseif (left == RailState[9] and right == RailState[2]) and Vel.x < 0 then --Going West left-
        MinecartDir.setRot({0,90,0})
      elseif (left == RailState[2] and right == RailState[8]) and Vel.x > 0 then --Going east right
        MinecartDir.setRot({0,270,0})
    --to left
      elseif (left == RailState[7] and right == RailState[2]) and Vel.x < 0 then --Going West left
        MinecartDir.setRot({0,90,0})
      elseif (left == RailState[2] and right == RailState[10]) and Vel.x > 0 then --Going East left-
        MinecartDir.setRot({0,-90,0})
      end
  --SloPes N shit
  elseif RShape == RailState[3] then --up east
    --straight
      if Rtop == RailState[2] and Vel.x > 0 then --Going East
        MinecartDir.setRot({45,-90,0})
      elseif Rtop == RailState[2] and Vel.x < 0 then --Going West
        MinecartDir.setRot({45,90,0})
      end
  elseif RShape == RailState[4] then --up west
  elseif RShape == RailState[5] then --up north
  elseif RShape == RailState[6] then --Up south
  --CorNeRs wooooooh
  elseif RShape == RailState[7] then --South_east
    if (back == RailState[1] and right == RailState[2]) and Vel.x < 0 and Vel.z > 0 then --Going south
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,135,0},x)
    elseif (back == RailState[1] and right == RailState[2]) and Vel.x > 0 then --Going from east
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,-45,0},x)
    --longs
    elseif (back == RailState[10] and right == RailState[2]) and Vel.x < 0 and Vel.z > 0 then --Going south with long curve
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,135,0},x)
    elseif (back == RailState[1] and right == RailState[10]) and Vel.x > 0 and Vel.z < 0 then --Going East with long curve
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,-45,0},x)
    end
  elseif RShape == RailState[8] then --South_west
    if (back == RailState[1] and left == RailState[2]) and Vel.x > 0 and Vel.z > 0 then --Going south
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,225,0},x)
    elseif (back == RailState[1] and left == RailState[2]) and Vel.x < 0 and Vel.z < 0 then --Going West
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,45,0},x)
    --longs
    elseif (back == RailState[9] and left == RailState[2]) and Vel.x > 0 and Vel.z > 0 then --Going south with long curve
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,225,0},x)
    elseif (back == RailState[1] and left == RailState[9]) and Vel.x < 0 and Vel.z < 0 then --Going West with long curve
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,45,0},x)
    end
  elseif RShape == RailState[9] then --North_east
    if (front == RailState[1] and right == RailState[2]) and Vel.x < 0 and Vel.z < 0 then --Going north
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,45,0},x)
    elseif (front == RailState[1] and right == RailState[2]) and Vel.x > 0 and Vel.z > 0 then --Going East
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,225,0},x)
    --longs
    elseif (front == RailState[1] and right == RailState[8]) and Vel.x > 0 and Vel.z > 0 then --Going East with long curve
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,225,0},x)
    elseif (front == RailState[8] and right == RailState[2]) and Vel.x < 0 and Vel.z < 0 then --Going north with long curve
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,45,0},x)
    end
  elseif RShape == RailState[10] then --North_west
    if (front == RailState[1] and left == RailState[2]) and Vel.x > 0 and Vel.z < 0 then --Going North
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,-45,0},x)
    elseif (front == RailState[1] and left == RailState[2]) and Vel.x < 0 and Vel.z > 0 then --Going West
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,135,0},x)
    --longs
    elseif (front == RailState[7] and left == RailState[2]) and Vel.x > 0 and Vel.z < 0 then --Going North with long curve
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,-45,0},x)
    elseif (front == RailState[1] and left == RailState[7]) and Vel.x < 0 and Vel.z > 0 then --Going West with long curve
      lerp_anim(MinecartDir,"setRot",5,0,10,10,MinecartDir.getRot(),{0,135,0},x)
    end
  end
end
function tick()
  local vehicle = player.getVehicle()
  if vehicle == nil then
    Mounts.setEnabled(false)
    renderer.setMountEnabled(true)
    renderer.setMountShadowEnabled(true)
  else
    Mounts.setEnabled(true)
    renderer.setMountEnabled(false)
    renderer.setMountShadowEnabled(false)
  end
  InMine(vehicle)
  --local Brot = player.getRot()
  --MinecartDir.PlayerDoll.setRot({0,-Brot.y,0})
end
function render(delta)
  getVel()
  lerp_anim(Mounts,"setPos",4,0,4,4,vectors.worldToPart({lastPos}),vectors.worldToPart({newPos}),delta)
  Rails(delta)
end
--anim framework
  function lerp_anim(modelPath,type,speed,startTick--[[start frame]],endTick--[[end frame]],lastTick--[[how long]],startValue--[[from]],endValue--[[to]],delta)
      local clock = (world.getTime()+delta)*speed % lastTick
      if clock > startTick and clock < endTick then
        modelPath[type](tableLerp(startValue,endValue,((clock-startTick))/((endTick-startTick))))
      end
  end
  function cerp_anim(modelPath,type,speed,startTick,endTick,lastTick,startValue,endValue,startVel,endVel,delta)
    local clock = (world.getTime()+delta)*speed % lastTick
    if clock > startTick and clock < endTick then
      modelPath[type](vectors.of(startValue)+(vectors.of(endValue)-vectors.of(startValue))*vectors.of(tableCerp(0,1,startVel,endVel,((clock-startTick))/((endTick-startTick)))))
    end
  end
  function wave_anim(modelPath,type,speed,amplitude,period--[[cant be 0]],phaseShift,horisonalShift,delta)
    local clock = (world.getTime()+delta)*speed
    modelPath[type]({
      amplitude[1]*math.sin(((2*math.pi*clock)/period[1])-phaseShift[1])+horisonalShift[1],
      amplitude[2]*math.sin(((2*math.pi*clock)/period[2])-phaseShift[2])+horisonalShift[2],
      amplitude[3]*math.sin(((2*math.pi*clock)/period[3])-phaseShift[3])+horisonalShift[3]
    })
  end
  function const_anim(modelPath,type,speed,startTick,endTick,lastTick,value,delta)
    local clock = (world.getTime()+delta)*speed % lastTick
    if clock > startTick and clock < endTick then
      modelPath[type](value)
    end
  end
  function cerp(p0,p1,m0,m1,x) -- This isn't actually used in the framework, but it's useful to have
    return (2*x^3-3*x^2+1)*p0+(x^3-2*x^2+x)*m0+(-2*x^3+3*x^2)*p1+(x^3-x^2)*m1
  end
  function tableCerp(p0,p1,m0,m1,x)
    return {(2*x^3-3*x^2+1)*p0+(x^3-2*x^2+x)*m0[1]+(-2*x^3+3*x^2)*p1+(x^3-x^2)*m1[1],(2*x^3-3*x^2+1)*p0+(x^3-2*x^2+x)*m0[2]+(-2*x^3+3*x^2)*p1+(x^3-x^2)*m1[2],(2*x^3-3*x^2+1)*p0+(x^3-2*x^2+x)*m0[3]+(-2*x^3+3*x^2)*p1+(x^3-x^2)*m1[3]}
  end
  function lerp(a, b, x) -- This isn't actually used in the framework, but it's useful to have
    return a + (b - a) * x
  end
  function tableLerp(a,b,x)
    return {lerp(a[1],b[1],x), lerp(a[2],b[2],x), lerp(a[3],b[3],x)}
  end