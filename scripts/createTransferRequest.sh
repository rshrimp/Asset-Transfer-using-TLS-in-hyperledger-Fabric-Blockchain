#!/bin/bash

export FABRIC_START_WAIT=5

echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo -e "----\e[5;32;40mAsset Transfer Request  \e[m"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"

docker exec cli.Org1 bash -c "peer chaincode invoke --tls true --cafile ./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem -C test -n transferchaincode -v 0 -c '{\"Args\":[\"transferAsset\", \"123\", \"Raj Shimpi\"]}'"
sleep ${FABRIC_START_WAIT}

docker exec cli.Org1 bash -c "peer chaincode invoke --tls true --cafile ./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem -C test -n transferchaincode -v 0 -c '{\"Args\":[\"transferAsset\", \"123\", \"Tiger Shimpi\"]}'"
sleep ${FABRIC_START_WAIT}

docker exec cli.Org1 bash -c "peer chaincode invoke --tls true --cafile ./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem -C test -n transferchaincode -v 0 -c '{\"Args\":[\"transferAsset\", \"123\", \"Rishi Shimpi\"]}'"
sleep ${FABRIC_START_WAIT}

echo -e "----\e[5;32;40m Now query the same asset to check Asset Transfer updates  \e[m"

docker exec cli.Org1 bash -c "peer chaincode query -C test -n transferchaincode -v 0 -c '{\"Args\":[\"queryDetail\", \"123\"]}'"
