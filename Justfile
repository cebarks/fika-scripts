status:
    podman-compose ps

logs TARGET:
    podman-compose logs -f {{ TARGET }}

start:
    podman-compose up -d backend
    sleep 30
    podman-compose up -d dc1 dc2 dc3

list-players:
    curl --silent -X GET -H "responsecompressed: 0" http://mars.grv.st:6969/fika/presence/get | jq

broadcast MESSAGE:
    curl --output /dev/null -X POST -H "requestcompressed: 0" \
    -H "Content-Type: application/json" \
    -d '{"notification": "{{ MESSAGE }}", "notificationIcon": 0}' \
    mars.grv.st:6969/fika/notification/push

stop:
    podman-compose down

restart: stop start

restart-clients:
    podman-compose restart dc1 dc2 dc3

restart-backend:
    podman-compose restart fika

copy-mods:
    cp -rv /export/public/mods/* /mnt/tank/sptd/SPT/
    cp -rv /export/public/mods/* /mnt/tank/sptd/SPT-dc1/
    cp -rv /export/public/mods/* /mnt/tank/sptd/SPT-dc2/
    cp -rv /export/public/mods/* /mnt/tank/sptd/SPT-dc3/

    rm SPT/BepInEx/plugins/Fika.Dedicated.dll

list-mods:
    ls -1d /mnt/tank/sptd/SPT/user/mods/*
    find /mnt/tank/sptd/SPT/BepInEx/plugins -name "*.dll"

cleanup:
dry-cleanup:
    find /mnt/tank/sptd -name "LICENSE-*"

backup:
    cp -r /mnt/tank/sptd /mnt/tank/sptd-backups/sptd_$(date --iso-8601=seconds)

set-configs:
    # set correct ports for dc2 & dc3
    sed -i 's/UDP Port = 25565/UDP Port = 25566/' /mnt/tank/sptd/SPT-dc2/BepInEx/config/com.fika.core.cfg
    sed -i 's/UDP Port = 25565/UDP Port = 25567/' /mnt/tank/sptd/SPT-dc3/BepInEx/config/com.fika.core.cfg

    # enable co-op quest sharing
    sed -i 's/"sharedQuestProgression": false/"sharedQuestProgression": true/' /mnt/tank/sptd/SPT/user/mods/fika-server/assets/configs/fika.jsonc

    # increase Ram cleaner interval from 5 to 2 minutes
    sed -i 's/RAM Clean Interval = 5/RAM Clean Interval = 2/' /mnt/tank/sptd/SPT-dc1/BepInEx/config/com.fika.dedicated.cfg
    sed -i 's/RAM Clean Interval = 5/RAM Clean Interval = 2/' /mnt/tank/sptd/SPT-dc2/BepInEx/config/com.fika.dedicated.cfg
    sed -i 's/RAM Clean Interval = 5/RAM Clean Interval = 2/' /mnt/tank/sptd/SPT-dc3/BepInEx/config/com.fika.dedicated.cfg

    sed -i 's/Update Rate = 60/Update Rate = 75/' /mnt/tank/sptd/SPT-dc1/BepInEx/config/com.fika.dedicated.cfg
    sed -i 's/Update Rate = 60/Update Rate = 75/' /mnt/tank/sptd/SPT-dc2/BepInEx/config/com.fika.dedicated.cfg
    sed -i 's/Update Rate = 60/Update Rate = 75/' /mnt/tank/sptd/SPT-dc3/BepInEx/config/com.fika.dedicated.cfg

    sed -i 's/Send Rate = Medium/Send Rate = High/' /mnt/tank/sptd/SPT-dc1/BepInEx/config/com.fika.core.cfg
    sed -i 's/Send Rate = Medium/Send Rate = High/' /mnt/tank/sptd/SPT-dc2/BepInEx/config/com.fika.core.cfg
    sed -i 's/Send Rate = Medium/Send Rate = High/' /mnt/tank/sptd/SPT-dc3/BepInEx/config/com.fika.core.cfg

    # set `Live Like` Preset instead of random
    # TODO: set up symlinks instead
    # sed -i 's/Moar Preset = Random/Moar Preset = Live Like/' /mnt/tank/sptd/SPT-dc1/BepInEx/config/MOAR.settings.cfg
    # sed -i 's/Moar Preset = Random/Moar Preset = Live Like/' /mnt/tank/sptd/SPT-dc2/BepInEx/config/MOAR.settings.cfg
    # sed -i 's/Moar Preset = Random/Moar Preset = Live Like/' /mnt/tank/sptd/SPT-dc3/BepInEx/config/MOAR.settings.cfg

    # set PMCs to spawn in the first half of raid
    sed -i 's/"pmcWaveDistribution": 0.8/"pmcWaveDistribution": 1/' /mnt/tank/sptd/SPT/user/mods/DewardianDev-MOAR/config/config.json

    # set MOAR preset options for bot spawning
    sed -i 's/Preset Announce On\/Off = true/Preset Announce On\/Off = false/' /mnt/tank/sptd/SPT-dc1/BepInEx/config/MOAR.settings.cfg
    sed -i 's/Preset Announce On\/Off = true/Preset Announce On\/Off = false/' /mnt/tank/sptd/SPT-dc2/BepInEx/config/MOAR.settings.cfg
    sed -i 's/Preset Announce On\/Off = true/Preset Announce On\/Off = false/' /mnt/tank/sptd/SPT-dc3/BepInEx/config/MOAR.settings.cfg

    sed -i 's/Starting PMCS On\/Off = true/Starting PMCS On\/Off = false/' /mnt/tank/sptd/SPT-dc1/BepInEx/config/MOAR.settings.cfg
    sed -i 's/Starting PMCS On\/Off = true/Starting PMCS On\/Off = false/' /mnt/tank/sptd/SPT-dc2/BepInEx/config/MOAR.settings.cfg
    sed -i 's/Starting PMCS On\/Off = true/Starting PMCS On\/Off = false/' /mnt/tank/sptd/SPT-dc3/BepInEx/config/MOAR.settings.cfg

    sed -i 's/"live-like": 25/"live-like": 70/' /mnt/tank/sptd/SPT/user/mods/DewardianDev-MOAR/config/PresetWeightings.json
    sed -i 's/"more-scavs": 8/"more-scavs": 10/' /mnt/tank/sptd/SPT/user/mods/DewardianDev-MOAR/config/PresetWeightings.json
    sed -i 's/"more-pmcs": 8/"more-pmcs": 15/' /mnt/tank/sptd/SPT/user/mods/DewardianDev-MOAR/config/PresetWeightings.json
    sed -i 's/"more-scavs-and-pmcs": 5/"more-scavs-and-pmcs": 5/' /mnt/tank/sptd/SPT/user/mods/DewardianDev-MOAR/config/PresetWeightings.json
    sed -i 's/"main-boss-roaming": 5/"main-boss-roaming": 0/' /mnt/tank/sptd/SPT/user/mods/DewardianDev-MOAR/config/PresetWeightings.json
    sed -i 's/"sniper-buddies": 4/"sniper-buddies": 0/' /mnt/tank/sptd/SPT/user/mods/DewardianDev-MOAR/config/PresetWeightings.json
    sed -i 's/"boss-invasion": 2/"boss-invasion": 0/' /mnt/tank/sptd/SPT/user/mods/DewardianDev-MOAR/config/PresetWeightings.json
