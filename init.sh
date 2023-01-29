#!/bin/bash

set -e

echo "copying dos config"
cp -r ./dotfile/.dosbox ~/

echo -e  "mount c: $(pwd)\nc:\nPATH C:\\masm;C:\\;\ncd src" >> ~/.dosbox/dosbox-0.74-3.conf
echo "Done!"
cd ..


