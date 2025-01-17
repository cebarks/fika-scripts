base_dir := "/mnt/tank/sptd-test"
clients := "3"

backend_dir := base_dir / "backend"
client_dir := base_dir / "dc"

config_dir := base_dir / "config"
mods_dir := base_dir / "mods"

overlay_dir := base_dir / "overlay"
overlay_dc_dir := overlay_dir / "dc"
overlay_backend_dir := overlay_dir / "backend"
work_dir := overlay_dir / "work"

persist_dir := base_dir / "persist"
persist_dc_dir := persist_dir / "dc"
persist_backend_dir := persist_dir / "backend"


overlay_dc_str := (
    overlay_dc_dir + ":" +
    mods_dir + ":" +
    config_dir 
)
overlay_backend_str := (
    overlay_backend_dir + ":" +
    mods_dir + ":" +
    config_dir
)

status:
    podman-compose ps

logs TARGET:
    podman-compose logs -f {{TARGET}}

start SERVICE: mount
    podman-compose up -d {{SERVICE}}
stop SERVICE: unmount
    podman-compose down {{SERVICE}}

start-all: mount
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

stop-all: unmount
    podman-compose down

restart: stop-all start-all

restart-clients:
    podman-compose restart dc{1..{{clients}}}

restart-backend:
    podman-compose restart backend

copy-mods:
    cp -rv /export/public/mods/* {{backend_dir}}/
    cp -r /export/public/mods/* {{base_dir}}/dc1/

    rm SPT/BepInEx/plugins/Fika.Dedicated.dll

list-mods:
    ls -1d {{backend_dir}}/user/mods/*
    find {{backend_dir}}/BepInEx/plugins -name "*.dll"

cleanup:
    find {{base_dir}} -name "LICENSE-*" -delete -print
dry-cleanup:
    find {{base_dir}} -name "LICENSE-*"

backup:
    cp -r {{base_dir}} {{base_dir}}-backups/sptd_$(date --iso-8601=seconds)

mkdirs:
    mkdir -p {{backend_dir}}

    mkdir -p {{config_dir}}
    mkdir -p {{mods_dir}}

    mkdir -p {{overlay_dir}}
    mkdir -p {{overlay_dc_dir}}
    mkdir -p {{overlay_backend_dir}}
    mkdir -p {{work_dir}}

    mkdir -p {{persist_dir}}
    mkdir -p {{persist_backend_dir}}

mount: mkdirs
    @echo "Creating backend overlay..."
    mkdir -p {{work_dir}}-backend
    sudo mount -t overlay overlay -o lowerdir={{overlay_backend_str}},upperdir={{persist_backend_dir}},workdir={{work_dir}}-backend {{backend_dir}}
    @echo "Done."

    # clients
    @echo "Creating overlays for {{clients}} dedicated clients..."
    for i in {1..{{clients}}}; do \
        mkdir -p {{work_dir}}-dc$i; \
        mkdir -p {{persist_dc_dir}}$i; \
        mkdir -p {{client_dir}}$i; \
        sudo mount -t overlay overlay -o lowerdir={{overlay_dc_str}},upperdir={{persist_dc_dir}}$i,workdir={{work_dir}}-dc$i {{client_dir}}$i; \
    done
    @echo "Done."

unmount:
    #!/usr/bin/env sh
    echo Unmounting overlays...
    sudo umount {{backend_dir}} 
    for i in {1..{{clients}}}; do
        sudo umount {{client_dir}}$i
    done
    echo Done.

set-configs:
    # set correct ports for dc2 & dc3
    sed -i 's/UDP Port = 25565/UDP Port = 25566/' {{base_dir}}/dc2/BepInEx/config/com.fika.core.cfg
    sed -i 's/UDP Port = 25565/UDP Port = 25567/' {{base_dir}}/dc3/BepInEx/config/com.fika.core.cfg
