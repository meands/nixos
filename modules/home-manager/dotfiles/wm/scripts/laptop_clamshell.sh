#!/usr/bin/env bash

laptop_output=eDP-1

if grep -q open /proc/acpi/button/lid/LID0/state; then
    @enable_output@
else
    @disable_output@
fi
