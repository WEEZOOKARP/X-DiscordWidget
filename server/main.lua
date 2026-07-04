local BOT_TOKEN = ""
local CLIENT_ID = ""
local OAUTH_LINK = ""
local PlayTime = {}

local function UpdatePlayerWidget(source, discordId, firstFlight, playtimeData, group)
    local playtime = "Who knows" 
    local playtime = string.format("%d Days, %d Hours", playtimeData.days, playtimeData.hours)

    local lastPlayed = os.date("%d %B %Y")
    local firstFlight = firstFlight
    local standing = group

    local payload = {
        username = GetPlayerName(source), 
        data = {
            dynamic = {
                { type = 1, name = "Last Played", value = lastPlayed },
                { type = 1, name = "Playtime", value = playtime },
                { type = 1, name = "First Flight", value = firstFlight },
                { type = 1, name = "Standing", value = standing }
            }
        }
    }

    local url = string.format("https://discord.com/api/v9/applications/%s/users/%s/identities/0/profile", CLIENT_ID, discordId)

    PerformHttpRequest(url, function(err, text, headers)
        if err == 200 or err == 201 or err == 204 then
            print("^2[Widgets] Successfully updated profile for " .. GetPlayerName(source) .. "^0")
        
        elseif err == 401 or err == 403 then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 0, 0},
                multiline = true,
                args = {"System", "To show your server stats on your Discord profile, authorize our app here: " .. OAUTH_LINK}
            })
            
        else
            print("^1[Widgets] Failed to update profile for " .. GetPlayerName(source) .. ". Code: " .. tostring(err) .. "^0")
            print("Response: " .. tostring(text))
        end
    end, "PATCH", json.encode(payload), {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bot " .. BOT_TOKEN
    })
end

AddEventHandler('esx:playerLoaded', function (playerId, xPlayer, isNew)
    local src = playerId
    local discordId = nil
    local identifier = xPlayer.identifier
    local query = "SELECT DATE_FORMAT(created_at, '%D %M %Y') as joinDate FROM users WHERE identifier = ?"
    local result = MySQL.single.await(query, { identifier })
    local firstFlight = "Unknown"
    if result and result.joinDate then
        firstFlight = result.joinDate
    end
    local group = "Player"
    if xPlayer.group == "god" or xPlayer.group == "admin" then
        group = "Staff"
    elseif xPlayer.group == "mod" then
        group = "Moderator"
    end

    local playtime = xPlayer.getPlayTime()
    PlayTime.src = {}
    PlayTime.src["days"] = math.floor(playtime / 86400)
    PlayTime.src["hours"] = math.floor((playtime % 86400) / 3600)

    local identifiers = GetPlayerIdentifiers(src)
    for _, id in ipairs(identifiers) do
        if string.find(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end

    if discordId then
        UpdatePlayerWidget(src, discordId, firstFlight, PlayTime.src, group)
    else
        print("^3[Widgets] " .. GetPlayerName(src) .. " joined without Discord open/linked.^0")
    end
end)
