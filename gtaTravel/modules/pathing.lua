pathing = {
    gtaTravelDestination = nil
}

function pathing.toggleHead()
    local headItem = "Items.PlayerMaPhotomodeHead"
    if string.find(tostring(Game.GetPlayer():GetResolvedGenderName()), "Female") then
        headItem = "Items.PlayerWaPhotomodeHead"
    end

    local ts = Game.GetTransactionSystem()
    local gameItemID = GetSingleton('gameItemID')
    local tdbid = TweakDBID.new(headItem)
    local itemID = gameItemID:FromTDBID(tdbid)

        if ts:HasItem(Game.GetPlayer(), itemID) == false then
            Game.AddToInventory(headItem, 1)
        end

    Game.EquipItemOnPlayer(headItem, "TppHead")
end

function pathing.distanceVector(from, to) -- Get distance between two vectors, ignoring z
    return math.sqrt((to.x - from.x)^2 + (to.y - from.y)^2)
end

function pathing.xyOffset(distance) -- Calculate xy offset by distance traveled along players viewing vector
    offset = Vector4.new(0,0,0,0)
    dir = Game.GetCameraSystem():GetActiveCameraForward()
    offset.x = dir.x * distance
    offset.y = dir.y * distance
    return offset
end

function pathing.pUp(pos, speed) -- Calculate new position along players view vector
    dir = Game.GetCameraSystem():GetActiveCameraForward()
    pos.x = pos.x - (dir.x * speed)
    pos.y = pos.y - (dir.y * speed)
    pos.z = pos.z - (dir.z * speed)
    return pos
end

function pathing.upPath(gtaTravel)
    local settings = gtaTravel.settings.upwardPath

    local speedIncrement = settings.speedIncrement
    local fullSpeed = settings.topSpeed
    local playerTpDistance = settings.playerTpDistance

    local distanceTodo = settings.camHeight - Game.GetPlayer():GetWorldPosition().z

    local speed = 0
    local distanceDone = 0 
    local distanceUntilFullspeed = 0
    local rampUpDone = false
    local startingSlowDown = false
    local triggerCamOffset = false
    local camZOffset = 2

    local playerPosition = Game.GetPlayer():GetWorldPosition()

    if pathing.gtaTravelDestination.z > settings.camHeight - 25 then -- Target above maxCamHeight
         distanceTodo = (pathing.gtaTravelDestination.z - playerPosition.z)  + gtaTravel.settings.downPath.playerTpDistance
    end

    if playerPosition.z > settings.camHeight then -- Player above maxCamHeight
        distanceTodo = (playerPosition.z  + 100) - playerPosition.z
    end

    while distanceDone < distanceTodo do
        pathing.path[pathing.steps] = Vector4.new(0, pathing.path[pathing.steps - 1].y, 0, 0)
        pathing.positions[pathing.steps] = Vector4.new(playerPosition.x, playerPosition.y, playerPosition.z, playerPosition.w) -- Required since vector4 in that case gets treated like a lua table -> Would change original value

        if rampUpDone then 
            playerPosition = pathing.pUp(playerPosition, speed)
            pathing.positions[pathing.steps] = Vector4.new(playerPosition.x, playerPosition.y, playerPosition.z, playerPosition.w)
            if triggerCamOffset == false then 
                triggerCamOffset = true
                pathing.path[pathing.steps] = Vector4.new(0, 0 + camZOffset, 0, 0)
                playerPosition = pathing.pUp(playerPosition, distanceDone + camZOffset)
                pathing.positions[pathing.steps] = Vector4.new(playerPosition.x, playerPosition.y, playerPosition.z, playerPosition.w)
            end
        end

        if (distanceTodo - distanceDone) < distanceUntilFullspeed then
            speed = speed - speedIncrement
            startingSlowDown = true
        elseif speed < fullSpeed and not (rampUpDone) then
            speed = speed + speedIncrement
            distanceUntilFullspeed = distanceDone
            pathing.path[pathing.steps] = Vector4.new(0, -distanceDone, 0, 0)
        elseif not rampUpDone then
            pathing.path[pathing.steps] = Vector4.new(0, -distanceDone, 0, 0)
        end

        if distanceDone > playerTpDistance or startingSlowDown then
            rampUpDone = true
        end

        distanceDone = distanceDone + speed
        pathing.steps = pathing.steps + 1
    end

end

function pathing.sidePath(gtaTravel)
    local settings = gtaTravel.settings.sidePath

    local speedTop = settings.topSpeed
    local speedIncrement = settings.speedIncrement

    local playerPos = pathing.positions[pathing.steps - 1]      
    local destination = pathing.gtaTravelDestination

    local destOffset = pathing.xyOffset((playerPos.z - destination.z) / - (Game.GetCameraSystem():GetActiveCameraForward().z))
    local destination = Vector4.new(destination.x - destOffset.x, destination.y - destOffset.y, destination.z, 1)

    local distanceLong = pathing.distanceVector(playerPos, destination)
    local distanceXYZ = Vector4.new(destination.x - playerPos.x, destination.y - playerPos.y, destination.z - playerPos.z, 1)
    local distLongDone = 0
    local distToFullSpeed = 0
    local speedCurrently = 0

    while distLongDone < distanceLong do
        if (distanceLong - distLongDone) < distToFullSpeed then 
            speedCurrently = speedCurrently - speedIncrement
        elseif speedCurrently < speedTop then 
            speedCurrently = speedCurrently + speedIncrement
            distToFullSpeed = distLongDone 
        end

        distLongDone = distLongDone + pathing.distanceVector(Vector4.new(pathing.positions[pathing.steps - 1].x, pathing.positions[pathing.steps - 1].y, 0, 0), Vector4.new(pathing.positions[pathing.steps - 1].x + distanceXYZ.x / (distanceLong / speedCurrently), pathing.positions[pathing.steps - 1].y + distanceXYZ.y / (distanceLong / speedCurrently), 0, 0) )

        pathing.positions[pathing.steps] = Vector4.new(pathing.positions[pathing.steps - 1].x + distanceXYZ.x / (distanceLong / speedCurrently), pathing.positions[pathing.steps - 1].y + distanceXYZ.y / (distanceLong / speedCurrently),  pathing.positions[pathing.steps - 1].z,  pathing.positions[pathing.steps - 1].w)
        pathing.path[pathing.steps] =  pathing.path[pathing.steps - 1]
        pathing.steps = pathing.steps + 1  
    end
    pathing.positions[pathing.steps - 1] = Vector4.new(destination.x, destination.y, pathing.positions[pathing.steps - 1].z, 0)
end

function pathing.downPath(gtaTravel)
    local settings = gtaTravel.settings.downPath

    local playerTpDistance = settings.playerTpDistance
    local speedIncrement = settings.speedIncrement
    local fullSpeed = settings.topSpeed

    local speed = 0
    local distanceDone = 0
    local distanceUntilFullspeed = 0
    local distanceTodo = (pathing.positions[pathing.steps - 1].z - pathing.gtaTravelDestination.z)
    local switchToCam = false
    local startingSlowDown = false
    local factor = - (Game.GetCameraSystem():GetActiveCameraForward().z)

    if not (distanceTodo / 2 > playerTpDistance) then
        playerTpDistance = (distanceTodo / 2) - 2
    end

    local playerPosition = pathing.positions[pathing.steps]

    while distanceDone < distanceTodo do
        pathing.path[pathing.steps] = Vector4.new(0, pathing.path[pathing.steps - 1].y, 0, 0)
        playerPosition = pathing.positions[pathing.steps - 1]
        pathing.positions[pathing.steps] = Vector4.new(playerPosition.x, playerPosition.y, playerPosition.z, playerPosition.w)

        if switchToCam then 
            factor = 1
            pathing.path[pathing.steps] = Vector4.new(0, -(distanceTodo - distanceDone), 0, 0)
            pathing.positions[pathing.steps] = pathing.gtaTravelDestination
        end

        if (distanceTodo - distanceDone) < distanceUntilFullspeed then
            speed = speed - speedIncrement
            startingSlowDown = true
        elseif speed < fullSpeed then
            speed = speed + speedIncrement
            distanceUntilFullspeed = distanceDone
            playerPosition = pathing.pUp(playerPosition, -speed)
            pathing.positions[pathing.steps] = Vector4.new(playerPosition.x, playerPosition.y, playerPosition.z, playerPosition.w)
        elseif not switchToCam then
            playerPosition = pathing.pUp(playerPosition, -speed)
            pathing.positions[pathing.steps] = Vector4.new(playerPosition.x, playerPosition.y, playerPosition.z, playerPosition.w)
        end

        if distanceDone > distanceTodo - playerTpDistance or startingSlowDown then
            switchToCam = true
        end
        distanceDone = distanceDone + (speed * factor)
        pathing.steps = pathing.steps + 1
    end
    pathing.path[pathing.steps - 1] = Vector4.new(0,0,0,0)
end

function pathing.generatePath(gtaTravel)
    pathing.path = {[0] = Vector4.new(0, 0, 0, 0)}
    pathing.positions = {}
    pathing.steps = 1

    pathing.upPath(gtaTravel)
    pathing.sidePath(gtaTravel)
    pathing.downPath(gtaTravel)
end

return pathing