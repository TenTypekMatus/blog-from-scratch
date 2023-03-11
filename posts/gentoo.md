# Ako nainštalovať Gentoo **správne**

Asi (možno) viete, čo to je Gentoo. A ak nie, tak vám to poviem. Je to linuxová distribúcia, ktorá je známa svojou prispôsobiteľnosťou, kde si môžete systém vyladiť do posledného detailu. Niektorí ľudia na internete hovoria, že nainštalovať Gentoo je ťažké, ale ono to v skutočnosti nie je ťažké. No tak sa na to poďme pozrieť

# Výber inštalačného média

## Trochu o Gentoo

Keďže Gentoo je tzv. **meta-distribúcia**, tak to znamená, že tá distribúcia sa neinštaluje pekným grafickým inštalátorom, ale pekne krásne cez príkazový riadok. A dokonca Gentoo nemá ani vlastné ISO, ktorého prostredie nevyzerá ako Windows XP. Ale ja mám na toto riešenie. Volá sa [SystemRescueCD](https://www.system-rescue.org/), pričom toto prostredie je veľmi jednoduché na používanie a aj celkom “lajtové” na systémové prostriedky. Dá sa vypáliť na USB pomocou [Rúfusu](https://rufus.ie), [Etcheru](https://balena.io-etcher) alebo aj pomocou [`dd`](https://wiki.installgentoo.com/wiki/GNU/Linux#Making_a_bootable_USB_installer). Inštrukcie nájdete na ich stránkach. Keď budete mať SystemRescueCD vypálené na USB, reštartujte počítač, lebo potrebujeme spustiť SystemRescueCD z USB. Tu napíšem, ako spustiť SysRescue z USB na mojich zariadeniach (počítač s základnou doskou od MSI a notebook od HP), ale ak by vás zaujímalo, ako spustiť SysRescue na iných zariadeniach, tak si [pozrite tento link](https://techofide.com/blogs/boot-menu-option-keys-for-all-computers-and-laptops-updated-list-2021-techofide/), kde je uvedené, ako sa nabootovať do USB na iných notebookov/počítačov aj od iných výrobcov. Keď budete nabootovaní do SysRescueCD, tak napíšte `startx` do terminálu a napojte sa na Wi-Fi (nemusíte sa pripájať na Wi-Fi, ak je do PC/notebooku pripojený Ethernet kábel). Keď budete napojení na Wi-Fi, tak môžeme prejsť na ďalší krok

# Rozdelenie diskov

<details>
<summary>Varovanie</summary>
Predtým, než začneme rozdeľovať disky, je **vysoko** odporúčané, aby ste si zálohovali **VŠETKY** dáta na disku, na ktorý chcete Gentoo nainštalovať. Ak ste predtým mali zapnutý OneDrive/Dropbox/iCloud, tak by to nemal byť problém. V opačnom prípade **ihneď** reštartujte počítač a skopírujte si všetky dáta dáta niekde, napríklad na USB disk. Keď ich budete mať skopírované, tak sa môžete vrátiť hore, ak ste zabudli, ako spustiť SysRescue z USB.
</details>
Ak toto už budete mať urobené, tak sa môžeme pustiť do rozdelenia disku/diskov. Do tabuľky dole som dal príklad, ako si rozporciovať disk.

| Bod pripojenia | Partícia  | Súborový systém             |
| -------------- | --------- | --------------------------- |
| /boot          | /dev/sda1 | ESP (lepší názov pre FAT32) |
| /              | /dev/sda2 | XFS                         |

> Poznámka: vždy napíšte `lsblk` do terminálu predtým, než budete pokračovať

Budeme používať `fdisk` na rozporciovanie diskov. Takže stlačte `Control+Alt+T` a napíšte `fdisk` a potom okopírujte toto:

```bash
disk="/dev/sda" # Upravte si toto podľa seba

echo "g
n
1

+1G
ef00
n
2

w
" | fdisk $disk
mkfs.fat -F 32 "${disk}1"
mkfs.xfs "${disk}2"
```

Keď to budete mať, tak sa môžete vrhnúť na pripájanie diskov

# Pripájanie diskov, rozbaľovanie a nastavovanie

## Pripájanie diskov

Keď budete mať toto hore vyriešené, tak si môžeme pripojiť disky na `/mnt/gentoo`, lokáciu, kde najskôr pripojíme tzv. root partíciu, a potom tam budeme pripájať ďaľšie partície. Čiže, poďme s tým začať. Môžete si skopírovať tieto príkazy, ktoré vám napíšem dole:

```bash
mkdir -p /mnt/gentoo
mount "${disk}2" /mnt/gentoo
mkdir -p /mnt/gentoo/boot
mount "${disk}1" /mnt/gentoo/boot
```

Keď ste tie príkazy hore opísali/okopírovali, tak je najvyšší čas, aby ste sa prehodili na `/mnt/gentoo`, tak je najvyšší čas, aby ste zamierili na [gentoo.org/downloads](https://gentoo.org/downloads), kde si vyberieme tzv. tarball so systémovými súbormi. Ja vám tu dám aj takú tabuľku, pomocou ktorej sa môžete rozhodnúť, ktorý link na tarball skopírovať.

| Typ tarballu                                                                                                                                                                                                                                                                                                                                                                                                                            | Inicializačný systém | Vysvetlenie/Popis                                                                                                               |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| Desktop                                                                                                                                                                                                                                                                                                                                                                                                                                 | OpenRC/SystemD       | Tarball pre PC/notebooky. Obsahuje Xorg, Rust (nemyslím tú hru) a veci, ktoré by zabrali príliš dlho na normálnych počítačoch   |
| No multilib                                                                                                                                                                                                                                                                                                                                                                                                                             | OpenRC/SystemD       | Podobne ako Desktop tarball, ale neobsahuje Xorg a iné veci, ktoré obsahuje Desktop tarball + ešte na ňom nespustíte Steam      |
| Hardened                                                                                                                                                                                                                                                                                                                                                                                                                                | OpenRC               | Bez Xorgu, vhodný na servery (sú aj lepšie linuxové distribúcie na servery, ale ok)                                             |
| MUSL                                                                                                                                                                                                                                                                                                                                                                                                                                    | OpenRC               | Knižnica pre C bez zbytočností. S týmto tarballom nespustíte 50% softvéru, ba dokonca aj inštalátor ovládačov pre GPU od Nvidie |
| Osobne odporúčam Desktop tarball, lebo obsahuje všetko potrebné, čo by ste tak potrebovali na tzv. daily-driving tejto distribúcie. Predpokladám, že viete stlačiť pravé tlačidlo myši a kliknúť na tlačidlo Copy Link Address. Keď ten link budete mať skopírovaný, tak sa prekliknite naspäť do terminálu a zadajte tam `wget <adresa, ktorú ste skopírovali predtým>` a stlačte Enter. Počkajte chvíľu a potom napíšte tento príkaz: |                      |                                                                                                                                 |

```bash
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner
```

Keď ten tarball budete mať rozbalený, tak treba nastaviť Portage, čo je správca balíkov pre Gentoo. Takže, napíšte `nano -w /mnt/gentoo/etc/portage/make.conf` a nastavte si tam tie hodnoty pre hardvér. Odporúčam pozrieť [túto wikistránku](https://wiki.gentoo.org/wiki/Safe_CFLAGS), kde si nájdete svoj procesor podľa názvu produktovej rady (Skylake, Picasso atď.), a ak chcete nejakú predlohu, tak ja vám ju tu dám:

```conf
COMMON_FLAGS="-O2 -pipe"
CFLAGS="${COMMON_FLAGS}"
CXXFLAGS="${COMMON_FLAGS}"
FCFLAGS="${COMMON_FLAGS}"
FFLAGS="${COMMON_FLAGS}"
MAKEOPTS="-j12"
# NOTE: This stage was built with the bindist Use flag enabled

# This sets the language of build output to English.
# Please keep this setting intact when reporting bugs.
LC_MESSAGES=C
USE="X -gpm usb pulseaudio gles2 daemon qt5 dist-kernel firmware build initramfs redistributable system-bootloader icons elogind"
ACCEPT_KEYWORDS="~amd64"
VIDEO_CARDS="nvidia"
GRUB_PLATFORMS="efi-64"
ACCEPT_LICENSE="* @FREE @BINARY-REDISTRIBUTABLE @EULA"
FEATURES="-collision-protect sandbox buildpkg noman noinfo nodoc"
```
Anyway, ak ste si skopírovali tú konfiguráciu hore, tak ju vložte do `make.conf` súboru. A teraz sa poďme vrhnúť na 