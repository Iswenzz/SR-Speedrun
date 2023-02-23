#!/bin/bash
source .cod4env

mysqldump -u root -p speedrun > ~/backup.sql
