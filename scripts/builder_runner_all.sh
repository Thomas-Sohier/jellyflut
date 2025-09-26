#!/bin/bash

# This script will run the build_runner for all the packages in the project
# It will also run the pub get for all the packages
# First we run the pub get and build_runner for the root
echo "Running pub get for root"
flutter pub get &>/dev/null
echo "Running build_runner for root"
flutter pub run build_runner build --delete-conflicting-outputs > /dev/null

# We build in priority the package jellyflut_models on which most the app depends to
(
    cd ./packages/jellyflut_models || exit
    echo "Running pub get for jellyflut_models"
    flutter pub get &>/dev/null
    echo "Running build_runner for jellyflut_models"
    flutter pub run build_runner build --delete-conflicting-outputs > /dev/null
)

# Then we run the pub get and build_runner for all the packages
for dir in ./packages/*;
do 
    (
        cd "$dir" || exit
        echo "Running pub get for $dir"
        flutter pub get &>/dev/null
        # if the folder containe a build.yaml file then we run the build_runner
        if [ -f "build.yaml" ]; then
            echo "Running build_runner for $dir"
            flutter pub run build_runner build --delete-conflicting-outputs > /dev/null
        fi
    )
done
