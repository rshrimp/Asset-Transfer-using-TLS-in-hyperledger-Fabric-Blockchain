
#!/bin/bash
#ORDERER_CA=./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem

export FABRIC_START_WAIT=5

echo -e '-----------------------\e[5;32;40m Install chaincodes\e[m---------------------------------------------------------'

echo " ----------------------------- For test channel --------------------------------------------"
docker exec cli.Org1 bash -c 'peer chaincode install  -p transfer -n transferchaincode -v 0'

sleep ${FABRIC_START_WAIT}
docker exec cli.Org2 bash -c 'peer chaincode install -p transfer -n transferchaincode -v 0'


echo -e "-----------------------'\e[5;32;40m Instantiate chaincodes\e[m---------------------------------------------------------"


docker exec cli.Org1 bash -c "peer chaincode instantiate --tls true --cafile ./crypto/ordererOrganizations/transfer.com/orderers/orderer.transfer.com/msp/tlscacerts/tlsca.transfer.com-cert.pem -C test -n transferchaincode -v 0 -c '{\"Args\":[]}' "

echo -e "----------------------'\e[5;32;40m END\e[m\'---------------------------------------------------------"
