part of 'sections.dart';

class ThemeSwitcherSection extends StatelessWidget {
  ThemeSwitcherSection({super.key});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: 'theme'.tr(),
      titleTextStyle: Theme.of(context).textTheme.headline6,
      tiles: [
        SettingsTile(
            title: 'theme'.tr(),
            onPressed: (context) => ThemeProvider().toggleTheme(),
            trailing: Consumer<ThemeProvider>(
                builder: (context, ThemeProvider themeNotifier, child) =>
                    themeNotifier.isDarkMode ? Icon(Icons.dark_mode) : Icon(Icons.light_mode))),
        SettingsTile(
            title: 'primary_color'.tr(),
            onPressed: editPrimaryColor,
            trailing: Consumer<ThemeProvider>(
                builder: (context, ThemeProvider themeNotifier, child) => Icon(
                      Icons.circle,
                      color: ThemeProvider().getThemeData.colorScheme.primary,
                    )))
      ],
    );
  }

  void editPrimaryColor(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('edit_infos'.tr()),
            actions: [
              Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TextButton(onPressed: context.router.root.pop, child: Text('save'.tr())))
            ],
            content: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 350, maxHeight: 150),
              child: ColorPicker(
                  displayThumbColor: false,
                  hexInputBar: false,
                  enableAlpha: false,
                  portraitOnly: true,
                  colorPickerWidth: 300,
                  labelTypes: [],
                  colorHistory: [],
                  pickerAreaHeightPercent: 0,
                  paletteType: PaletteType.hsl,
                  pickerColor: ThemeProvider().getThemeData.colorScheme.primary,
                  onColorChanged: (Color selectedColor) => ThemeProvider().editSeedColorTheme(selectedColor)),
            )));
  }
}
