#!/bin/bash

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
