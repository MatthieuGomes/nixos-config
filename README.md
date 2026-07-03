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
    - `chown -R matthieu:users <wallet_file>`
    - `chmod <permissions> <wallet_file>`
    - Import Kwallet (encrypted or not) in new install from `KDE Wallet Manager`
    - Remove wallet file from `~`

OR 

- From old : 
    - Copy files from `~/.local/share/kwalletd/`
    - Note the permissions

- From new :
    - Paste copied files in `~/.local/share/kwalletd/`
    - `chown -R matthieu:users ~/.local/share/kwalletd/`
    - `chmod <permissions> ~/.local/share/kwalletd/`
    - `chmod <permissions> ~/.local/share/kwalletd/<wallet_file>` for each wallet file
 
#### Automatically

From new install run 

```shell
./WIP/migration/kwallet.sh <username> <old_system_path>
``` 
Where `<username>` is the username of the user and `<old_system_path>` is the path to the old system mount point (e.g. `/mnt/old_system`).


### WIFI

#### Manually

##### If kwallet not migrated yet 

- Migrate KWallet first (see [KWallet](#kwallet))

##### Then

- Copy `/etc/NetworkManager` to new install
- Note permissions
- `sudo systemctl restart NetworkManager`

#### Automatically

##### If kwallet not migrated yet 

From new install run 

```shell
./migration/wifi.sh <old_system_path> y <username>
```

Where `<username>` is the username of the user and `<old_system_path>` is the path to the old system mount point (e.g. `/mnt/old_system`).

##### Else

From new install run 

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
    - `sudo chown -R <username>:users ~/.ssh`
    - `sudo chmod <permissions> ~/.ssh`

#### Automatically

From new install, run : 

```shell
./migration/ssh.sh <old_system_path> y <username>
```

Where `<username>` is the username of the user and `<old_system_path>` is the path to the old system mount point (e.g. `/mnt/old_system`).


### Authentificator

- 


### zsh history

- On old : 
    - Copy `~/.zsh_history`
    - Note the permissions

- On new :
    - Paste copied file in `~`
    - `chown matthieu:users ~/.zsh_history`
    - `chmod <permissions> ~/.zsh_history`



