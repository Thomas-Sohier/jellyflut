#!/bin/bash

# This script will run the build_runner for all the packages in the project
# It will also run the pub get for all the packages
# First we run the pub get and build_runner for the root
flutter pub get &>/dev/null && echo "Running pub get for root"
echo "Running build_runner for root"
flutter pub run build_runner build --delete-conflicting-outputs > /dev/null

# Then we run the pub get and build_runner for all the packages
for dir in ./packages/*;
do 
    (
        cd "$dir" || exit
        flutter pub get &>/dev/null && echo "Running pub get for $dir"
        # if the folder containe a build.yaml file then we run the build_runner
        if [ -f "build.yaml" ]; then
            echo "Running build_runner for $dir"
            flutter pub run build_runner build --delete-conflicting-outputs > /dev/null
        fi
    )
done
