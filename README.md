# X-DiscordWidget
A resource for FiveM for Discord Profile Widgets, The code is by no means the cleanest I've written but it does the job and is basically a drag and drop solution, it only runs when a player selects their character so performance isn't really a concern.

## Requirements
- ESX Legacy
- Discord Application
- Any oxmysql supported database resource

## Guide
Here's a really nice guide on how to create the actual widget, This resource stands in for the 
- Application Identities 
- Widget Management 
sections
### (Link)[https://chloecinders.com/blog/discord-widgets#displaying-the-widget-on-your-profile]

Once you have created your application go to server/main.lua and fill in the values at the top of the file
Currently the code is setup for a set of 4 text variables with the ids
- Last Played
- Playtime
- First Flight -- When they first joined the server
- Standing -- Player / Admin / Banned
You are free to change the IDs in the afformentioned file to match your setup


