baseDir := "/mnt/tank/sptd"
backendDir := baseDir / "backend"

status:
    podman-compose ps

logs TARGET:
    podman-compose logs -f {{TARGET}}

start:
    podman-compose up -d backend
    sleep 30
    podman-compose up -d dc1 dc2 dc3

list-players:
    curl --silent -X GET -H "responsecompressed: 0" http://mars.grv.st:6969/fika/presence/get | jq

broadcast MESSAGE:
    curl --output /dev/null -X POST -H "requestcompressed: 0" \
    -H "Content-Type: application/json" \
    -d '{"notification": "{{MESSAGE}}", "notificationIcon": 0}' \
    http://mars.grv.st:6969/fika/notification/push

stop:
    podman-compose down

restart: stop start

restart-clients:
    podman-compose restart dc1 dc2 dc3

restart-backend:
    podman-compose restart fika

copy-mods:
    cp -rv /export/public/mods/* {{backendDir}}/
    cp -r /export/public/mods/* {{baseDir}}/dc1/
    cp -r /export/public/mods/* {{baseDir}}/dc3/
    cp -r /export/public/mods/* {{baseDir}}/dc2/

    rm SPT/BepInEx/plugins/Fika.Dedicated.dll

list-mods:
    ls -1d {{backendDir}}/user/mods/*
    find {{backendDir}}/BepInEx/plugins -name "*.dll"

cleanup:
    find {{baseDir}} -name "LICENSE-*" -delete -print
dry-cleanup:
    find {{baseDir}} -name "LICENSE-*"

backup:
    cp -r {{baseDir}} {{baseDir}}-backups/sptd_$(date --iso-8601=seconds)

set-configs:
    # set correct ports for dc2 & dc3
    sed -i 's/UDP Port = 25565/UDP Port = 25566/' {{baseDir}}/dc2/BepInEx/config/com.fika.core.cfg
    sed -i 's/UDP Port = 25565/UDP Port = 25567/' {{baseDir}}/dc3/BepInEx/config/com.fika.core.cfg

    # enable co-op quest sharing
    sed -i 's/"sharedQuestProgression": false/"sharedQuestProgression": true/' {{backendDir}}/user/mods/fika-server/assets/configs/fika.jsonc

    # increase Ram cleaner interval from 5 to 2 minutes
    sed -i 's/RAM Clean Interval = 5/RAM Clean Interval = 2/' {{baseDir}}/dc1/BepInEx/config/com.fika.dedicated.cfg
    sed -i 's/RAM Clean Interval = 5/RAM Clean Interval = 2/' {{baseDir}}/dc2/BepInEx/config/com.fika.dedicated.cfg
    sed -i 's/RAM Clean Interval = 5/RAM Clean Interval = 2/' {{baseDir}}/dc3/BepInEx/config/com.fika.dedicated.cfg

    sed -i 's/Update Rate = 60/Update Rate = 75/' {{baseDir}}/dc1/BepInEx/config/com.fika.dedicated.cfg
    sed -i 's/Update Rate = 60/Update Rate = 75/' {{baseDir}}/dc2/BepInEx/config/com.fika.dedicated.cfg
    sed -i 's/Update Rate = 60/Update Rate = 75/' {{baseDir}}/dc3/BepInEx/config/com.fika.dedicated.cfg

    sed -i 's/Send Rate = Medium/Send Rate = High/' {{baseDir}}/dc1/BepInEx/config/com.fika.core.cfg
    sed -i 's/Send Rate = Medium/Send Rate = High/' {{baseDir}}/dc2/BepInEx/config/com.fika.core.cfg
    sed -i 's/Send Rate = Medium/Send Rate = High/' {{baseDir}}/dc3/BepInEx/config/com.fika.core.cfg

    # set PMCs to spawn in the first half of raid
    sed -i 's/"pmcWaveDistribution": 0.8/"pmcWaveDistribution": 1/' {{backendDir}}/user/mods/DewardianDev-MOAR/config/config.json

    # set MOAR preset options for bot spawning
    sed -i 's/Preset Announce On\/Off = true/Preset Announce On\/Off = false/' {{baseDir}}/dc1/BepInEx/config/MOAR.settings.cfg
    sed -i 's/Preset Announce On\/Off = true/Preset Announce On\/Off = false/' {{baseDir}}/dc2/BepInEx/config/MOAR.settings.cfg
    sed -i 's/Preset Announce On\/Off = true/Preset Announce On\/Off = false/' {{baseDir}}/dc3/BepInEx/config/MOAR.settings.cfg

    sed -i 's/Starting PMCS On\/Off = true/Starting PMCS On\/Off = false/' {{baseDir}}/dc1/BepInEx/config/MOAR.settings.cfg
    sed -i 's/Starting PMCS On\/Off = true/Starting PMCS On\/Off = false/' {{baseDir}}/dc2/BepInEx/config/MOAR.settings.cfg
    sed -i 's/Starting PMCS On\/Off = true/Starting PMCS On\/Off = false/' {{baseDir}}/dc3/BepInEx/config/MOAR.settings.cfg

    sed -i 's/"live-like": 25/"live-like": 70/' {{backendDir}}/user/mods/DewardianDev-MOAR/config/PresetWeightings.json
    sed -i 's/"more-scavs": 8/"more-scavs": 10/' {{backendDir}}/user/mods/DewardianDev-MOAR/config/PresetWeightings.json
    sed -i 's/"more-pmcs": 8/"more-pmcs": 15/' {{backendDir}}/user/mods/DewardianDev-MOAR/config/PresetWeightings.json
    sed -i 's/"more-scavs-and-pmcs": 5/"more-scavs-and-pmcs": 5/' {{backendDir}}/user/mods/DewardianDev-MOAR/config/PresetWeightings.json
    sed -i 's/"main-boss-roaming": 5/"main-boss-roaming": 0/' {{backendDir}}/user/mods/DewardianDev-MOAR/config/PresetWeightings.json
    sed -i 's/"sniper-buddies": 4/"sniper-buddies": 0/' {{backendDir}}/user/mods/DewardianDev-MOAR/config/PresetWeightings.json
    sed -i 's/"boss-invasion": 2/"boss-invasion": 0/' {{backendDir}}/user/mods/DewardianDev-MOAR/config/PresetWeightings.json
