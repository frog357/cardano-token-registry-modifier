# cardano-token-registry-modifier
Fetches the cardano-token-registry repo and creates output of files that are easier to use in your application.
I needed a method to integrate decimals into my application.
This script will create a folder structure that your application can process to make integtrating tokens easier.
Run the bash script to create an output folder containing a folder for each asset in the registry.
The output will be:
./output
./output/${policyID}${assetHex}/
./output/${policyID}${assetHex}/logo.png
./output/${policyID}${assetHex}/decimals.txt
./output/${policyID}${assetHex}/ticker.txt
./output/${policyID}${assetHex}/name.txt

Now in your application you can simply check if a file exists in a given folder to obtain the information necessary to properly display Cardano Native Tokens with their decimal representation.
