## Кейс: *"Кастомизация GNU/Linux"*

- **OS**: [NixOS](https://nixos.org)
- **Wayland композитор**: [Hyprland](https://hyprland.org)

## Установка (VM)

1. Установочный (`live`) [образ](https://channels.nixos.org/nixos-23.05/latest-nixos-minimal-x86_64-linux.iso) NixOS
2. Команды для установки внутри `live` системы:
```shell
nix-shell -p git
git clone https://github.com/mxxntype/mirea-nixos
cd mirea-nixos
sudo nixos-install --flake .#mirea-nixos
```
