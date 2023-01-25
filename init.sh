#!/bin/bash

set -e
echo "copying dos config"
cp -r ./dotfile/.dosbox ~/
echo "Done!"
cd ..
mv ./AssemblyLanguageEnv ./dos


