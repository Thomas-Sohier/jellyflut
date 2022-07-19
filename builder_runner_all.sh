
for dir in ./packages/*; do (cd "$dir" && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs); done
