# Installation and migration guide
## Installation


## Migration

Automatic migrations supposes the new disk is mounted on the old system and the new system is installed (cf [Installation](#installation)).

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

run `./migration/kwallet-mig.sh <username> <new_system_path>` from old install, where `<username>` is the username of the user and `<new_system_path>` is the path to the new system (e.g. `/mnt/new_system`).


### WIFI

#### Pre-requisites

- Migrate KWallet first (see [KWallet](#kwallet))

#### Manually

- Copy `/etc/NetworkManager` to new install
- Note permissions



- `sudo systemctl restart NetworkManager`
#### Automatically
From old install, run:
`./migration/kwallet-mig.sh`

### SSH

- Copy `~/.ssh` to new install
- `chown -R matthieu:users ~/.ssh`

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



