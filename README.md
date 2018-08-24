# Asset Transfer using hyperledger Fabric

1.  This isfinal product demonstrating  setting up 2 orgs with 2 peers each.
It includes all the requirements as listed below.
2.  Using Solo orderer
3.  Fabric CA for certificates.
4.  It includes a node.js app for invoking chaincode.
5.  *TLS is enabled*
6.    node js app is a client invoking chaincode

## Transfer Consortium Setup
1. Two peers for each organization
2. Pre-created Member Service Providers (MSP) for authentication and identification
3. An Orderer using SOLO
4. _Testchannel_ – this channel is public blockchain both orgs have read and write access to it.

## Directory Structure
```
├── app				        
      ├── app.js
├── chaincode				        
      ├── transfer			
        ├── transfer.go
├── channels
├── crypto-config		
├── cli.yaml
├── configtx.yaml
├── crypto-config.yaml
├── crypto.sh to generate CA certs
├── docker-compose-transfer.yaml                  
├── peer.yaml
├── README.md
├── scripts
    ├──chaincodeInstallInstantiate.sh
    ├──cleanup.sh
    ├──createArtifacts.sh
    ├──creatChannels.sh
    ├──createLedgerEntries.sh
    ├──createTransferRequest.sh    
    ├──query.sh
    ├──queryAll.sh
    ├──setupNetwork.sh    
    ├──start_network.sh
    ├──stop_network.sh
```

* `cd transfercaapp`  

## Setup network
* Run the following command to kill any stale or active containers:

  `./scripts/cleanup.sh`

* Skip this step if want to use the generated CA certs and app setup.

Create artifacts ( genesis block and channel info) if need to be (orderer genesis block and channels).
_But dont have to if you want to run it as it is._
_This script is not going to create crypto-config folder for certs as it is already generated.
But if you wish you can delete the crypto-config folder that was created before and then run crypto.sh script to generate the CA certs_
You will then need to follow setup.tx in app directory to setup node app for keys.

  `./scripts/createArtifacts.sh`


* start network with start option
  `./scripts/start_network.sh`

* `./scripts/setupNetwork.sh` this script creates channels, join channels, instantiates and installs chaincode, populates ledger with initial entries. It will also dump the entire ledgers at the end.


##### Now run asset transfer request.  

OPTION -1:

The script runs transfer request multiple times on the same asset id=123 to show the updates which are printed at the end of the script runs
`./scripts/createTransferRequest.sh`

```{
  "Snumber": "123",
  "Description": "5 High Strret, CA 75000 ",
  "Owner": "Rishi ",
  "Status": "transferred",
  "TransactionHistory": {
    "createAsset": "Wed, 14 Mar 2018 19:04:51 UTC",
    "transferAssetWed, 14 Mar 2018 19:06:15 UTC": "Asset transferred from: John Doe to new owner:xx on:Wed, 14 Mar 2018 19:06:15 UTC",
yy    "transferAssetWed, 14 Mar 2018 19:07:53 UTC": "Asset transferred from: Raj  to new owner: Tiger  on:Wed, 14 Mar 2018 19:07:53 UTC",
    "transferAssetWed, 14 Mar 2018 19:07:58 UTC": "Asset transferred from: Tiger  to new owner: Rishi  on:Wed, 14 Mar 2018 19:07:58 UTC"
  }
}```

OPTION -2: Running from the app.js

*app is also set up. (to start from scratch- Please follow the steps in steps.txt in app folder to setup node.js app and then follow the directions below.)
You will need to copy private key in app/certs folder to ~/.hfc-key-store if use the generated artifacts else app will not work.

cd /app
node app.js
Running from the app.js in a browser
open http://localhost:4000
