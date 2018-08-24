#!/bin/bash

export FABRIC_START_WAIT=20

docker exec cli.Org1 bash -c "peer chaincode query -C test -n transferchaincode -v 0 -c '{\"Args\":[\"queryDetail\",\"123\"]}'"
