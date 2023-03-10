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
| /home          | /dev/sdb1 | XFS                         |
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

# Pripájanie diskov

