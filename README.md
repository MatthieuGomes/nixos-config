# Installation and migration guide

## Installation

### Clean (MANDATORY)
#### Manually

- Create a `NewNixOs` folder in `mnt` if it doesn't exist yet
- Reformat the partition you want to install your new NixOS install in with the label `NixOS` (in `ext4`)
- Reformat the partition you want to put the new bootloader in with the label `NBOOTLOADER` (in `fat32`)

#### Automatically

```shell
./WIP/migration/clean.sh
``` 


### Installation
#### Manually

- Mount the partition you want to install your new NixOS install in on `/mnt/NewNixOs`
- Create a `boot` folder in `/mnt/NewNixOs`
- Mount the partition you want to put the new bootloader in on `/mnt/NewNixOs/boot`
- Create a `etc` folder in `/mnt/NewNixOs`
- `rsync -a` the folder you keep your nixos config in `/mnt/NewNixOs/etc/`
    - if the folder you keep your nixos confif in is not called `nixos`, rename the `/mnt/NewNixOs/etc/<nixos-config-folder>` folder into `/mnt/NewNixOs/etc/nixos`
- `sudo nixos-generate-config --root /mnt/NewNixOs`
- `sudo nixos-install --root /mnt/NewNixOs --flake /mnt/NewNixOs/etc/nixos#NixOS --show-trace`
- Enter your root password for the new install twice (as asked)
- `sudo nixos-enter --root /mnt/NewNixOs --command "passwd <username>"` and type twice your user password
- `sudo nixos-enter --root /mnt/NewNixOs --command "chown -R <username>:users /etc/nixos/"` and type twice your user password

#### Automatically

```shell
./WIP/migration/installation.sh <new_sys_part> <new_mnt_point> <new_boot_part> <current_nixos_config_folder> <username>
``` 

Where `<new_sys_part>` is the device corresponding to the partition you want to install your new NixOS in (e.g. `/dev/nvmeXnYpZ`),`<new_mnt_point>` is the path to the new system mount point (e.g. `/mnt/new_system`), `<new_sys_part>` is the device corresponding to the partition you want to put the new bootloader in (e.g. `/dev/nvmeXnYpZ`), `<current_nixos_config_folder>` is the path to thte folder containing the current nixos config, and `<username>` is the username of the user.



## Migration

### Preparation (MANDATORY)
#### Manually

- Create a `OldNixOS` folder in `mnt` if it doesn't exist yet
- Mount the partition of the old NixOS install on `/mnt/OldNixOS`

#### Automatically

```shell
./WIP/migration/prepare.sh
``` 

### KWallet
#### Manually

- From old : 
    - Export Kwallet (encrypted or not) in old install from `KDE Wallet Manager` 
    - Copy wallet file
    - Note the permissions

- From new :
    - Paste copied wallet file in `~`
    - `sudo chown -R <username>:<group> <wallet_file>`
    - `sudo chmod <permissions> <wallet_file>`
    - Import Kwallet (encrypted or not) in new install from `KDE Wallet Manager`
    - Remove wallet file from `~`

OR 

- From old : 
    - Copy files from `~/.local/share/kwalletd/`
    - Note the permissions

- From new :
    - Paste copied files in `~/.local/share/kwalletd/`
    - `sudo chown -R <username>:<group> ~/.local/share/kwalletd/`
    - `sudo chmod <permissions> ~/.local/share/kwalletd/`
    - `sudo chmod <permissions> ~/.local/share/kwalletd/<wallet_file>` for each wallet file
 
#### Automatically

From new install, run : 

```shell
./WIP/migration/kwallet.sh <old_system_path> <username>
``` 
Where `<old_system_path>` is the path to the old system mount point (e.g. `/mnt/old_system`) and `<username>` is the username of the user.


### WIFI

#### Manually
##### If kwallet not migrated yet 

- Migrate KWallet first (see [KWallet](#kwallet))

##### Then

- From old : 
    - Copy `/etc/NetworkManager/system-connections`
    - Note permissions

- From new : 
    - Paste copied files in `/etc/NetworkManager/system-connections`
    - `sudo chown -R <username>:<group> /etc/NetworkManager/system-connections`
    - `sudo chmod <permissions> /etc/NetworkManager/system-connections`
    - `sudo systemctl restart NetworkManager.service`

#### Automatically
##### If kwallet not migrated yet 

From new install, run : 

```shell
./WIP/migration/wifi.sh <old_system_path> y <username>
```

Where `<username>` is the username of the user and `<old_system_path>` is the path to the old system mount point (e.g. `/mnt/old_system`).

##### Else

From new install, run : 

```shell
./WIP/migration/wifi.sh <old_system_path>
```

Where `<old_system_path>` is the path to the old system mount point (e.g. `/mnt/old_system`).

### SSH
#### Manually

- From old : 
    - Copy `~/.ssh`
    - Note the permissions

- From new : 
    - Paste copied files in `~/.ssh`
    - `sudo chown -R <username>:<group> ~/.ssh`
    - `sudo chmod <permissions> ~/.ssh`

#### Automatically

From new install, run : 

```shell
./WIP/migration/ssh.sh <old_system_path> <username>
```

Where `<username>` is the username of the user and `<old_system_path>` is the path to the old system mount point (e.g. `/mnt/old_system`).


### Authentificator
#### Manually

- From old : 
    - Open Authenticator > Backup & Restore > Backup > Authenticator
    - Close Autenticator
    - Copy generated file

- From new : 
    - Paste copied file in `~`
    - `sudo chown -R <username>:<group> ~/<file>`
    - Open Authenticator > Backup & Restore > Restore > Authenticator
    - Select file
    - Close Autenticator
    - Delete file


### zsh history
#### Manually

- From old : 
    - Copy `~/.zsh_history`
    - Note the permissions

- From new : 
    - Remove `~/.zsh_history`
    - Paste copied files in `~/.zsh_history`
    - `sudo chown -R <username>:<group> ~/.zsh_history`
    - `sudo chmod <permissions> ~/.zsh_history`

#### Automatically

From new install, run : 

```shell
./WIP/migration/zsh.sh <old_system_path> <username>
```

Where `<username>` is the username of the user and `<old_system_path>` is the path to the old system mount point (e.g. `/mnt/old_system`).


### KDE connect

If the hostname changed, you'll need to pair the device at least once with the new hostname 

!!! NOT 100 % SURE IT WORKS, needs more testing !!!

#### Manually

- From old : 
    - Copy `~/.config/kdeconnect`
    - Note the permissions

- From new : 
    - Move `~/.config/kdeconnect/config` to `~/.config/config-tmp` 
    - Paste copied files in `~/.config/kdeconnect`
    - Move `~/.config/config-tmp` to `~/.config/kdeconnect/config` 
    - `sudo chown -R <username>:<group> ~/.config/kdeconnect/config`
    - `sudo chmod <permissions> ~/.config/kdeconnect/config`

#### Automatically

From new install, run : 

```shell
./WIP/migration/kdeconnect.sh <old_system_path> <username>
```

Where `<username>` is the username of the user and `<old_system_path>` is the path to the old system mount point (e.g. `/mnt/old_system`).

Then go to your phone/device > KDEConnect > Pair new device. The device should automatically connect itself to the PC.


### Bluetooth 

!!! WORK ONLY WITH MONO BLUETOOTH ADAPTER

#### Manually

- From old : 
    - Copy files inside `/var/lib/bluetooth/<mac-address>/`
    - Note the permissions

- From new : 
    - `sudo systemctl stop bluetooth.service`
    - Remove files in `/var/lib/bluetooth/<mac-address>/`
    - Paste copied files in `/var/lib/bluetooth/<mac-address>/`
    - `sudo chown -R root:root ~/var/lib/bluetooth/<mac-address>/<files>`
    - `sudo chmod <permissions> /var/lib/bluetooth/<mac-address>/<files>`
    - `sudo systemctl restart bluetooth.service`

#### Automatically

From new install, run : 

```shell
./WIP/migration/bluetooth.sh <old_system_path>
```

Where `<old_system_path>` is the path to the old system mount point (e.g. `/mnt/old_system`).