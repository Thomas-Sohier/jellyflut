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
                    themeNotifier.isDarkMode
                        ? Icon(Icons.light_mode)
                        : Icon(Icons.dark_mode)))
      ],
    );
  }
}
