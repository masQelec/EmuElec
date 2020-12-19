#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2020-present Shanti Gilbert (https://github.com/shantigilbert)

. /etc/profile 

# If there is a new version copy the files
if [[ -e "/storage/roms/bios/pico-8" ]]; then
    cp -rf /storage/roms/bios/pico-8 /emuelec/bin/
    rm -rf /storage/roms/bios/pico-8
    chmod +x /emuelec/bin/pico-8/pico8_dyn
    touch /storage/roms/pico-8/splore.p8
fi 

if [[ "$EE_DEVICE" == "Amlogic" ]]; then
set_audio alsa
mv /storage/.config/asound.conf /storage/.config/asound.conf2
fi

mkdir -p /emuelec/configs/pico-8

if [[ ! -L "/emuelec/configs/pico-8/sdl_controllers.txt" ]]; then
    rm /emuelec/configs/pico-8/sdl_controllers.txt
    ln -sf /storage/.config/SDL-GameControllerDB/gamecontrollerdb.txt /emuelec/configs/pico-8/sdl_controllers.txt
fi

CART=name=$(echo "${1}" | cut -f 1 -d '.')

if [[ "${CART}" == *"/splore"* ]]; then
    /emuelec/bin/pico-8/pico8_dyn -splore -home /emuelec/configs/pico-8 -root_path /storage/roms/pico-8 -joystick 0
else
    /emuelec/bin/pico-8/pico8_dyn -run ${CART} -home /emuelec/configs/pico-8 -root_path /storage/roms/pico-8 -joystick 0
fi

if [[ "$EE_DEVICE" == "Amlogic" ]]; then
set_audio default
mv /storage/.config/asound.conf2 /storage/.config/asound.conf
fi
