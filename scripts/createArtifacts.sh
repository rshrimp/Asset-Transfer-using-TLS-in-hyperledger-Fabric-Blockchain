#!/bin/bash

export FABRIC_START_WAIT=5
export FABRIC_CFG_PATH=./

#echo -e "\e[5;32;40mgenerating certificates in crypto-config folder for all entities\e[m "
#cryptogen generate --config crypto-config.yaml
#sleep ${FABRIC_START_WAIT}



echo -e "\e[5;32;40mgenerating geneis block\e[m "
mkdir orderer
configtxgen -profile TRANSFEROrdererGenesis -outputBlock ./orderer/genesis.block
sleep ${FABRIC_START_WAIT}
echo -e "\e[5;32;40mcreate the channel configuration blocks with this configuration file, by using the other profiles\e[m "

mkdir channels
configtxgen -profile TestChannel -outputCreateChannelTx ./channels/test.tx -channelID test
sleep ${FABRIC_START_WAIT}


echo -e "\e[5;32;40mgenerate the anchor peer update transactions\e[m "

configtxgen -profile TestChannel -outputAnchorPeersUpdate ./channels/testanchor.tx -channelID test -asOrg Org1MSP
sleep ${FABRIC_START_WAIT}
