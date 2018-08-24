#!/bin/bash

export FABRIC_START_WAIT=5
#ORDERER_CA=./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem


echo -e "-------------------------\e[5;32;40mNow Creating and Joining  channels\e[m -----------------------------"
docker exec cli.Org1 bash -c 'peer channel create  -c test -f ./channels/test.tx -o  orderer.transfer.com:7050 --tls true --cafile ./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem'
sleep ${FABRIC_START_WAIT}
docker exec cli.Org1 bash -c 'peer channel join  -b test.block'
sleep ${FABRIC_START_WAIT}

docker exec cli.Org2 bash -c 'peer channel join  -b test.block'
sleep ${FABRIC_START_WAIT}


echo -e ".. \e[5;32;40muse the anchor peer update transactions:\e[m"

docker exec cli.Org1 bash -c 'peer channel update --tls true --cafile ./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem -o orderer.transfer.com:7050 -c test -f ./channels/testanchor.tx'

# docker exec cli.Org2 bash -c 'peer channel update -o orderer.transfer.com:7050 -c test -f ./channels/testanchor.tx'
#sleep ${FABRIC_START_WAIT}
