#!/bin/bash

cp root_new.config buildroot/.config
cd buildroot
make menuconfig
make
