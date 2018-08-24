#!/bin/bash
docker-compose -f docker-compose-transfer.yaml down

sleep 10

./scripts/cleanup.sh
