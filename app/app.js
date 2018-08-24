'use strict'; // self-defence

// Functions
const hfc = require('fabric-client');
const fs = require('fs');

let channel;
const enrolUser = function(client, options) {
  return hfc.newDefaultKeyValueStore({ path: options.wallet_path })
    .then(wallet => {
      client.setStateStore(wallet);
      return client.getUserContext(options.user_id, true);
    });
};

/* const initNetwork = function(client, options, target) {
  let channel;
  try {
    channel = client.newChannel(options.channel_id);
    const peer = client.newPeer(options.peer_url);
    target.push(peer);
    channel.addPeer(peer);
    channel.addOrderer(client.newOrderer(options.orderer_url));
  } catch(e) { // channel already exists
    channel = client.getChannel(options.channel_id);
  }
  return channel;
};
*/
const initNetwork = function(client, options, target) {
 let channel;
 try {
   channel = client.newChannel(options.channel_id);
   const peertlscacert = fs.readFileSync('./certs/peer-cert.pem');
   const orderertlscacert = fs.readFileSync('./certs/orderer-cert.pem');
   const peer = client.newPeer(options.peer_url,
     {
       pem: Buffer.from(peertlscacert).toString(),
       'ssl-target-name-override': "peer0.Org1.com"
     });
   target.push(peer);
   channel.addPeer(peer);
   channel.addOrderer(client.newOrderer(options.orderer_url,
     {
       pem: Buffer.from(orderertlscacert).toString(),
       'ssl-target-name-override': "orderer.transfer.com"
     }));
 } catch(e) { // channel already exists
   channel = client.getChannel(options.channel_id);
 }
 return channel;
};


const transactionProposal = function(client, channel, request) {
  request.txId = client.newTransactionID();
  return channel.sendTransactionProposal(request);
};

const responseInspect = function(results) {
  const proposalResponses = results[0];
  const proposal = results[1];
  const header = results[2];

  if (proposalResponses && proposalResponses.length > 0 &&
    proposalResponses[0].response &&
    proposalResponses[0].response.status === 200) {
    return true;
  }
  return false;
};

const sendOrderer = function(channel, request) {
  return channel.sendTransaction(request);
};

const client = new hfc();
const target = [];

// Function invokes transfer
function invoke(opt, param) {
  return enrolUser(client, opt)
    .then(user => {
      if(typeof user === "undefined" || !user.isEnrolled())
        throw "User not enrolled";

      channel = initNetwork(client, opt, target);
      const request = {
          targets: target,
          chaincodeId: opt.chaincode_id,
          fcn: 'transferAsset',
          args: param,
          chainId: opt.channel_id,
          txId: null
      };
      return transactionProposal(client, channel, request);
    })
    .then(results => {
      if (responseInspect(results)) {
        const request = {
          proposalResponses: results[0],
          proposal: results[1],
          header: results[2]
        };
        return sendOrderer(channel, request);
      } else {
        throw "Response is bad";
      }
    })
    .catch(err => {
      console.log(err);
      throw err;
    });
};

// Options
const options = {
  Org1: {
    wallet_path: './certs',
    user_id: 'Org1Admin',
    channel_id: 'test',
    chaincode_id: 'transferchaincode',
    peer_url: 'grpcs://localhost:7051',
    orderer_url: 'grpcs://localhost:7050'
  }
};


// Server
const express = require("express");
const app = express();
const http = require('http');
const bodyParser = require('body-parser');
const path = require('path');

app.engine('html', require('ejs').renderFile);

const server = http.createServer(app).listen(4000, function() {});
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(__dirname));
app.set('views', __dirname);

app.post('/invoke', function(req, res, next) {
  const args = req.body.args;
  invoke(options[args[0]], args.slice(1))
    .then(() => res.send("Chaincode invoked successfully"))
    .catch(err => {
      res.status(500);
      res.send(err.toString());
    });
});

app.get('/', function(req, res) {
  res.render('UI.html');
});
