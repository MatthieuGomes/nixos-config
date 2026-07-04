# Installation and migration guide
## Installation


## Migration

Automatic migrations supposes the old disk is mounted on the new system (cf [Installation](#installation)).

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
./WIP/migration/kwallet.sh <username> <old_system_path>
``` 
Where `<username>` is the username of the user and `<old_system_path>` is the path to the old system mount point (e.g. `/mnt/old_system`).


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
./migration/wifi.sh <old_system_path> y <username>
```

Where `<username>` is the username of the user and `<old_system_path>` is the path to the old system mount point (e.g. `/mnt/old_system`).

##### Else

From new install, run : 

```shell
./migration/wifi.sh <old_system_path>
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
./migration/ssh.sh <old_system_path> <username>
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


### SSH
#### Manually

- From old : 
    - Copy `~/.zsh_history`
    - Note the permissions

- From new : 
    - Paste copied files in `~/.zsh_history`
    - `sudo chown -R <username>:<group> ~/.zsh_history`
    - `sudo chmod <permissions> ~/.zsh_history`

#### Automatically

From new install, run : 

```shell
./migration/zsh.sh <old_system_path> <username>
```

Where `<username>` is the username of the user and `<old_system_path>` is the path to the old system mount point (e.g. `/mnt/old_system`).

### KDE connect

If the hostname changed, you'll need to pair the device at least once with the new hostname

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
./migration/zsh.sh <old_system_path> <username>
```

Where `<username>` is the username of the user and `<old_system_path>` is the path to the old system mount point (e.g. `/mnt/old_system`).


