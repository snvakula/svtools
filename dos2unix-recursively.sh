#!/bin/bash

find . -name "*" -type f -exec dos2unix {} \;
