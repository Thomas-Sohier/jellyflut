# jellyflut

A jellyfin client made in Flutter

It's an alpha, soooooo for now, few things work...

## Todo

- [x] SQLite to have logging and to save server URL
- [x] Browse all files (for now only the first item of a collection)
- [ ] BIGGEST THING TO DO make transcoding work, for now i don't know how to check if file can be direct play and if no how to tell jellyfin to send me the correct url
- [ ] Correct all flutter things, make things faster

## Screens

![Image of login screen](./img/login.jpg){:width="300px"}
![Image of home](./img/home.jpg){:width="300px"}
![Image of details](./img/details.jpg){:width="300px"}

## Getting Started

How to test ?

```bash
git clone https://github.com/Thomas-Sohier/jellyflut.git
cd jellyflut
flutter packages get
flutter packages upgrade
flutter run
```

How to build ? (Android)

```bash
flutter build apk --release
```
