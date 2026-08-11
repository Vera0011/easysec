#!/bin/bash

## - Available modules - ##
ALL_BLUE_MODULES="lynis,grype,syft,grant,ssl,postgresql,audit"
ALL_BLUE_WORKFLOWS="anchore,keycloak"
ALL_RED_MODULES="proxychains"
ALL_RED_WORKFLOWS=""
ALL_ENVIRONMENTS="production,staging,testing/vagrant"

## - General variables (overriden in functions) - ##
MAIN_MENU_CHOICE=""
MODULES=""
ENVIRONMENT_MENU_CHOICE=""
ENVIRONMENT=""