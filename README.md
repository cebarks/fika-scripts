# Fika podman-compose companion scripts

## justfile config
There are a few variables declared at the top of the Justfile that can be edited such as basedir install location and number of dedicated clients.

## Directories
You can run `just mkdirs` to create the required folder structure.

| dir | usage |
|-----|-------|
| backend/ | spt backend container runtime directory |
| config/ | mod configs to be apply over defaults |
| dc*/ | dedicated client container runtime directory |
| mods/ | mods to be loaded into the runtime directories |
| overlay/ | install location for default spt backend and dedicated client directories (as well as overlayfs workdirs) |
| overlay/dc/ | base install of dedicated clients (where SPTarkov install goes) |
| overlay/backend/ | base install of spt backend (where SPT.Server.exe goes) |
| overlay/work-*/ | overlayfs workdirs. unimportant to end-user |
| persist/ | any changes made while the server is running will end up here instead of in `$base_dir/dc*` or `$base_dir/backend`. If there are files here, you'll probably want them moved to another directory above. //TODO implement auto sorting of `persist/**/*` |
