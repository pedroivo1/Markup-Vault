# CachyOS Configuration

This documentation contains the automated post-installation and network optimization scripts for the CachyOS operating system.

## Execution Protocol (System)

All commands must be executed strictly under standard user jurisdiction (`$`). The system will automatically request privilege elevation (`sudo`) when necessary.

Execute the network module and grant execution permissions:
```sh
chmod +x *.sh
./wifi.sh
```

> obs: Every time you change your location you should run ./wifi.sh so the system will update to faster regional servers (e.g., relocating from Brazil to Canada, not from Brazil to Paraguay).

Reboot the equipment to apply the deep hardware power rules:
```sh
shutdown -r now
```

Upon returning to the system, execute the application and environment configuration script:
```sh
./setup.sh
```

## Panel Configuration
Right click on task bar:

Click `Show Panel Configuration`
```
Position: Bottom
Alignment: Center
Width: Fill width
Visibility: Dodge windows
Opacity: Adaptive
Floating: Panel and applets

Panel Height: 36
Focus shortcut: None
```

Right click on task bar:

Click `Add or Manage Widgets...`
```
application Launcher
Digital Clock
Icons-Only Task Manager
System Tray
```
