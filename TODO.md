remove skin service from DCs
add MOAR settings to `set-config`
remove quest tracker
look into emulating a client request a dedicated host


## Get presence of connected players
curl --silent -X GET -H "responsecompressed: 0" http://mars.grv.st:6969/fika/presence/get | jq

## Broadcast Command
curl -X POST -H "requestcompressed: 0" -H "Content-Type: application/json" -d '{"notification": "Testing 123!", "notificationIcon": 0}' mars.grv.st:6969/fika/notification/push


## SPT_data/Server/configs/backup.json
