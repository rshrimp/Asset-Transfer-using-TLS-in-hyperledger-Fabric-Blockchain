#!/bin/bash

export FABRIC_START_WAIT=2
  export FABRIC_query_WAIT=5


echo -e "------------------------\e[5;32;40mNow creating real estates on the records blockchain\e[m ----------------------------------------------------"
docker exec cli.Org1 bash -c "peer chaincode invoke --tls true --cafile ./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem -C test -n transferchaincode -v 0 -c '{\"Args\":[\"createAsset\", \"123\", \"5 High Strret, CA 75000 \", \"John Doe\"]}'"

docker exec cli.Org1 bash -c "peer chaincode invoke --tls true --cafile ./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem -C test -n transferchaincode -v 0 -c '{\"Args\":[\"createAsset\", \"456\", \"15 High Strret, TX 75001 \", \"Alice Chang\"]}'"

docker exec cli.Org1 bash -c "peer chaincode invoke --tls true --cafile ./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem -C test -n transferchaincode -v 0 -c '{\"Args\":[\"createAsset\", \"789\", \"555 High Strret, OH 75002 \", \"Kim Jung\"]}'"

docker exec cli.Org1 bash -c "peer chaincode invoke --tls true --cafile ./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem -C test -n transferchaincode -v 0 -c '{\"Args\":[\"createAsset\", \"101112\", \"666 High Strret, PA 75003 \", \"Rocky Matt\"]}'"

docker exec cli.Org1 bash -c "peer chaincode invoke --tls true --cafile ./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem -C test -n transferchaincode -v 0 -c '{\"Args\":[\"createAsset\", \"131415\", \"777 High Strret, MI 75004 \", \"Bruce Lee\"]}'"

docker exec cli.Org1 bash -c "peer chaincode invoke --tls true --cafile ./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem -C test -n transferchaincode -v 0 -c '{\"Args\":[\"createAsset\", \"161718\", \"888 High Strret, MA 75005 \", \"Katy Perry\"]}'"

docker exec cli.Org1 bash -c "peer chaincode invoke --tls true --cafile ./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem -C test -n transferchaincode -v 0 -c '{\"Args\":[\"createAsset\", \"192021\", \"999 High Strret, LA 75006 \", \"Fung Shim\"]}'"



sleep ${FABRIC_START_WAIT}


echo -e " ...........\e[5;32;40m  now running a query on ledger to dump the ledger data\e[m"
docker exec cli.Org1 bash -c "peer chaincode query -C test -n transferchaincode -v 0 -c '{\"Args\":[\"queryAll\"]}'"
sleep ${FABRIC_query_WAIT}
