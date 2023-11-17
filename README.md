## Кейс: *"Кастомизация GNU/Linux"*

- **OS**: [NixOS](https://nixos.org)
- **Wayland композитор**: [Hyprland](https://hyprland.org)

Установочный (`live`) [образ](https://channels.nixos.org/nixos-23.05/latest-nixos-minimal-x86_64-linux.iso) NixOS

## Установка (VM)

Команды для установки внутри `live` системы:

1. Отформатировать **DOS**, два раздела: 512M `/boot`, остальное под `/`. Раздел `/boot` отметить, как `bootable`!
	```bash
	sudo -i
	cfdisk /dev/sda
	```

2. Создаём FS
	```bash
	mkfs.fat -F 32 /dev/sda1 # 512M BIOS Раздел
	mkfs.btrfs /dev/sda2     # Остальное - BTRFS
	```

3. Создаём том BTRFS и монтируем в `/`
	```bash
	mount /dev/sda2 /mnt
	btrfs subvolume create /mnt/@
	umount /mnt
	mount /dev/sda2 /mnt -o subvol=@
	mkdir /mnt/boot
	mount /dev/sda1 /mnt/boot
	```

4. Клонируем `flake`-репозиторий
	```bash
	nix-shell -p git # Если нужен helix|vim|neovim|nano, добавить сюда
	git clone https://github.com/mxxntype/mirea-nixos
	cd mirea-nixos
	```

5. Из сгенерированного `/mnt/etc/nixos/hardware-configuration.nix` надо подсмотреть `availableKernelModules` и вписать их в `nixos/hardware.nix`.
	```bash
	nixos-generate-config --root /mnt
	```

6. Перед установкой проверяем, что в `nixos/hardware.nix` правильно прописаны названия дисков и `kernelModules`. Устанавливаем пароль.
	```bash
	nixos-install --flake .#mirea-nixos
	```

7. Если все хорошо, можно перезагружаться. Можно скопировать репозиторий в новую систему (`/mnt`), чтобы не повторяться. Потом поместим в `/home/user/`.
	```bash
	cd ..
	cp -r mirea-nixos /mnt/
	sync
	reboot
	```

## После установки

1. Логинимся как `root`, устанавливаем пароль для `user` и выходим из `root`'a
	```bash
	passwd user
	exit
	```

2. Логинимся как `user`, ставим `home-manager`:
	```bash
	nix shell nixpkgs#home-manager # Только для первого rebuild

	# Новая копия репозитория
	git clone https://github.com/mxxntype/mirea-nixos

	# Или приносим старую
	sudo mv /mirea-nixos ./
	sudo chown user:wheel ./mirea-nixos -R

	cd mirea-nixos
	home-manager switch --flake .
	sudo nixos-rebuild switch --flake .

	exit # Из nix shell
	```
