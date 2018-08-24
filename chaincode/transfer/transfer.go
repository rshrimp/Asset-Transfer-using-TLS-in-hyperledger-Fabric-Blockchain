package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"time"

	"github.com/hyperledger/fabric/core/chaincode/shim" // import for Chaincode Interface
	pb "github.com/hyperledger/fabric/protos/peer"      // import for peer response
)

// Defined to implement chaincode interface
type Transfer struct {
}

// Define our struct to store assets in Blockchain, start fields upper case for JSON
type Asset struct {
	Snumber            string // This one will be our key
	Description        string
	Owner              string
	Status             string // this will contain its status on the exchange
	TransactionHistory map[string]string
}

/* Implement Init
Nothing to do here
*/
func (c *Transfer) Init(stub shim.ChaincodeStubInterface) pb.Response {

	return shim.Success(nil)

}

//utility funtion to get time
func getTimeNow() string {
	var formatedTime string
	t := time.Now()
	formatedTime = t.Format(time.RFC1123)
	return formatedTime
}

/* Implement Invoke
This works because we instantiate the chaincode with the producers in the channels. (See the section chaincode) If the caller is the same caller who
 instantiated the chaincode, then he is a producer and is allowed to create a block on the specified channel
*/
func (c *Transfer) Invoke(stub shim.ChaincodeStubInterface) pb.Response {

	function, args := stub.GetFunctionAndParameters() // get function name and args

	switch function {
	case "createAsset":
		// asset is produced and available
		return c.createAsset(stub, args)
	case "transferAsset":
		// transfer the asset from one owner to another
		return c.transferAsset(stub, args)
	case "queryAll":
		// Stock query
		return c.queryAll(stub)
	case "queryDetail":
		// Get details of a computer
		return c.queryDetail(stub, args)
	default:
		return shim.Error("Available functions: createAsset, transferAsset,  queryStock, queryDetail")
	}

}

// createAsset puts an available asset in the Blockchain
func (c *Transfer) createAsset(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	if len(args) != 3 {
		return shim.Error("createAsset arguments usage: Serialnumber, Description, Owner")
	}

	TransactionHistory := make(map[string]string)
	TransactionHistory["createAsset"] = getTimeNow()
	// A newly created asset is available
	asset := Asset{args[0], args[1], args[2], "Created", TransactionHistory}

	// Use JSON to store in the Blockchain
	assetAsBytes, err := json.Marshal(asset)

	if err != nil {
		return shim.Error(err.Error())
	}

	// Use serial number as key
	err = stub.PutState(asset.Snumber, assetAsBytes)

	if err != nil {
		return shim.Error(err.Error())
	}
	return shim.Success(nil)
}

// transferAsset handles changing of owner
func (c *Transfer) transferAsset(stub shim.ChaincodeStubInterface, args []string) pb.Response {
	if len(args) != 2 {
		return shim.Error("This function needs the serial number and new owner as argument")
	}

	// Look for the serial number
	v, err := stub.GetState(args[0])
	if err != nil {
		return shim.Error("Serialnumber " + args[0] + " not found ")
	}

	// Get Information from Blockchain
	var asset Asset
	// Decode JSON data
	json.Unmarshal(v, &asset)

	oldOwner := asset.Owner
	// Change the status
	asset.Owner = args[1]
	//update the status with time and database
	asset.Status = "transferred"
	//now we add the transaction history for the asset transfer
	//we use timstamp as the key in the map
	key := "transferAsset" + getTimeNow()
	asset.TransactionHistory[key] = "Asset transferred from: " + oldOwner + " to new owner: " + args[1] + " on:" + getTimeNow()
	// Encode JSON data
	assetAsBytes, err := json.Marshal(asset)

	// Store in the Blockchain
	err = stub.PutState(asset.Snumber, assetAsBytes)
	if err != nil {
		return shim.Error(err.Error())
	}
	return shim.Success(nil)
}

///query all dumps the entire ledger

func (c *Transfer) queryAll(stub shim.ChaincodeStubInterface) pb.Response {

	// resultIterator is a StateQueryIteratorInterface
	resultsIterator, err := stub.GetStateByRange("", "")
	if err != nil {
		return shim.Error(err.Error())
	}
	defer resultsIterator.Close()

	// buffer is a JSON array containing QueryResults
	var buffer bytes.Buffer
	buffer.WriteString("[")

	bArrayMemberAlreadyWritten := false
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return shim.Error(err.Error())
		}
		// Add a comma before array members, suppress it for the first array member
		if bArrayMemberAlreadyWritten == true {
			buffer.WriteString("\n,")
		}
		buffer.WriteString("{\"Key\":")
		buffer.WriteString("\"")
		buffer.WriteString(queryResponse.Key)
		buffer.WriteString("\"")

		buffer.WriteString(", \"Record\":")
		// Record is a JSON object, so we write as-is
		buffer.WriteString(string(queryResponse.Value))
		buffer.WriteString("}\n")
		bArrayMemberAlreadyWritten = true
	}
	buffer.WriteString("\n]")

	fmt.Printf("- queryAll:\n%s\n", buffer.String())

	return shim.Success(buffer.Bytes())
}

// queryDetail gives all fields of stored data and needs the serial number
func (c *Transfer) queryDetail(stub shim.ChaincodeStubInterface, args []string) pb.Response {

	if len(args) != 1 {
		return shim.Error("queryDetail Incorrect number of arguments. Expecting 1")
	}
	// Look for the serial number
	asBytes, err := stub.GetState(args[0])
	if err != nil {
		return shim.Error("Serial number " + args[0] + " not found")
	}
	return shim.Success(asBytes)

}

func main() {
	err := shim.Start(new(Transfer))
	if err != nil {
		fmt.Printf("Error starting chaincode sample: %s", err)
	}
}
