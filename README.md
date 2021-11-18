# Dotfile configuration

## Additional configs

Set keyboard layout to `us` and `de` and switch on `alt+space`:

```shell
localectl --no-convert set-x11-keymap us,de pc105 "" grp:alt_space_toggle
```

To set lightdm HiDPI, add the following line to
`/etc/lightdm/lightdm-gtk-greeter.conf` under `[greeter]` (see [Arch
Wiki](https://wiki.archlinux.org/title/User:Ctag/HiDPI#LightDM_(GTK)):

```
xfg-dpi=196
```

Create Cronjob to create automatic backups:


