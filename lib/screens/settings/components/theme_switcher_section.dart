part of 'sections.dart';

class ThemeSection extends StatelessWidget {
  ThemeSection({super.key});

  @override
  SettingsSection build(BuildContext context) {
    return SettingsSection(
      title: Text('theme'.tr(), style: Theme.of(context).textTheme.titleLarge),
      tiles: [
        SettingsTile(
            title: Text('theme'.tr(),
                style: Theme.of(context).textTheme.titleLarge),
            onPressed: (context) => ThemeProvider().toggleTheme(),
            trailing: Consumer<ThemeProvider>(
                builder: (context, ThemeProvider themeNotifier, child) =>
                    themeNotifier.isDarkMode
                        ? Icon(Icons.dark_mode)
                        : Icon(Icons.light_mode))),
        SettingsTile(
            title: Text('primary_color'.tr()),
            onPressed: editPrimaryColor,
            trailing: Consumer<ThemeProvider>(
                builder: (context, ThemeProvider themeNotifier, child) => Icon(
                      Icons.circle,
                      color: ThemeProvider().getThemeData.colorScheme.primary,
                    ))),
        SettingsTile(
          title: Text('contrast_details'.tr()),
          trailing: const DetailsContrastSwitch(),
        ),
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
                  child: TextButton(
                      onPressed: context.router.root.back,
                      child: Text('save'.tr())))
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
                  onColorChanged: (Color selectedColor) =>
                      ThemeProvider().editSeedColorTheme(selectedColor)),
            )));
  }
}
