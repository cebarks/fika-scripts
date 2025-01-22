remove skin service from DCs
add MOAR settings to `set-config`
remove quest tracker
look into emulating a client request a dedicated host


## Get presence of connected players
curl --silent -X GET -H "responsecompressed: 0" http://mars.grv.st:6969/fika/presence/get | jq

## Broadcast Command
curl -X POST -H "requestcompressed: 0" -H "Content-Type: application/json" -d '{"notification": "Testing 123!", "notificationIcon": 0}' mars.grv.st:6969/fika/notification/push


## SPT_data/Server/configs/backup.json

## Config Notes
### All the seasons
```
{
  "enable": true,
  "seasonLength": {
    "SUMMER": 10,
    "AUTUMN": 10,
    "WINTER": 10,
    "SPRING": 10,
    "AUTUMN_LATE": 10,
    "SPRING_EARLY": 10,
    "STORM": 10
  },
  "randomSeason": true,
  "randomSeasonWeighting": {
    "SUMMER": 1,
    "AUTUMN": 1,
    "WINTER": 1,
    "SPRING": 1,
    "AUTUMN_LATE": 1,
    "SPRING_EARLY": 1,
    "STORM": 1
  },
  "enableMoodyDefault": true,
  "consoleMessages": true
}
```
