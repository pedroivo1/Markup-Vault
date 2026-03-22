# CachyOS Configuration

This documentation contains post-installation network, system and apps configuration.

## Execution Protocol (System)

Execute the network module and grant execution permissions:
```sh
chmod +x *.sh
./wifi.sh
```

> obs: Every time you change your location you should run `./wifi.sh` so the system will update to faster regional servers (e.g., relocating from Brazil to Canada, not from Brazil to Paraguay).

Reboot the equipment to apply the deep hardware power rules:
```sh
shutdown -r now
```

Upon returning to the system, execute the application and environment configuration script:
```sh
./setup.sh
```

### KDE Plasma Panel

#### Panel Configuration

1. Right click on task bar:
2. Click `Show Panel Configuration`

| Parameter | Value |
| :--- | :--- |
| Position | Bottom |
| Alignment | Center |
| Width | Fill width |
| Visibility | Dodge windows |
| Opacity | Adaptive |
| Floating | Panel and applets |
| Panel Height | 36 |
| Focus shortcut | None |

#### Panel Widgets

1. Right click on task bar:
2. Click `Add or Manage Widgets...`

- Application Launcher
- Digital Clock
- Icons-Only Task Manager
- System Tray

## Apps

### Okular Configuration

Open Okular.

#### Map the "Invert Colors" toggle:

- Navigate to: Settings -> Configure Keyboard Shortcuts...
- Search for: Change Colors
- Click the Shortcut column, select Custom, and input: Ctrl + R
- Apply and exit.
