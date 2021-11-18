#!/bin/bash
echo -e "\033[35m"
echo -e "https://t.me/ro_cryptoo"
echo -e "https://t.me/whitelistx1000"

echo -ne "\033[35m██████╗░░█████╗░  "
echo -e "\033[34m░█████╗░██████╗░██╗░░░██╗██████╗░████████╗░█████╗░"

echo -ne "\033[35m██╔══██╗██╔══██╗  "
echo -e "\033[34m██╔══██╗██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔══██╗"

echo -ne "\033[35m██████╔╝██║░░██║  "
echo -e "\033[34m██║░░╚═╝██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░░██║"

echo -ne "\033[35m██╔══██╗██║░░██║  "
echo -e "\033[34m██║░░██╗██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░░██║"

echo -ne "\033[35m██║░░██║╚█████╔╝  "
echo -e "\033[34m╚█████╔╝██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚█████╔╝"

echo -ne "\033[35m╚═╝░░╚═╝░╚════╝░  "
echo -e "\033[34m░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚════╝░"

echo -e "\033[35m"


. <(wget -qO- https://raw.githubusercontent.com/Kallen-c/utils/main/installers/install_go.sh)
. <(wget -qO- https://raw.githubusercontent.com/Kallen-c/utils/main/installers/install_ufw.sh)
git clone https://github.com/persistenceOne/assetMantle.git
cd assetMantle
git fetch --tags
git checkout v0.1.1
make install

if [ ! $MANTLE_KEY_NAME ]; then
	read -p "Enter keyname: " MANTLE_KEY_NAME
fi
sleep 1
echo 'export MANTLE_KEY_NAME='$MANTLE_KEY_NAME >> $HOME/.profile

if [ ! $MANTLE_NODE_NAME ]; then
	read -p "Enter NODE name: " MANTLE_NODE_NAME
fi
sleep 1
echo 'export MANTLE_NODE_NAME='$MANTLE_NODE_NAME >> $HOME/.profile

if [ ! $MANTLE_SERVERIP_NAME ]; then
	read -p "Enter SERVERIP name: " MANTLE_SERVERIP_NAME
fi
sleep 1
echo 'export MANTLE_SERVERIP_NAME='$MANTLE_SERVERIP_NAME >> $HOME/.profile

assetClient keys add "$MANTLE_KEY_NAME"
assetNode init "$MANTLE_NODE_NAME" --chain-id test-mantle-1

wget https://raw.githubusercontent.com/persistenceOne/genesisTransactions/master/test-mantle-1/final_genesis.json --output-document=${HOME}/.assetNode/config/genesis.json

MANTLE_PEERS="9641267efa0a93409d15ff3ccd15e8da86a5f60b\@65\.0\.45\.171\:26656\,a9668820073e0d272431e2c30ca9334d3ed22141\@82\.65\.223\.126\:26656\,0c34daf66b3670322d00e0f4593ca07736377ced\@142\.4\.216\.69\:26656\,3573f0af265166beb2d55f6ec3c3a3bf22297e4e\@135\.181\.139\.153\:26656\,c1f3ddb331ca43e0f93349b08d510c5d80ed9a5a\@13\.234\.66\.128\:26656\,8cf1d7933b60de02b87e2c13ee90cc78ee770e49\@65\.2\.30\.162\:26656\,6f761a62b87dc660096949762afb5aa9287b909d\@15\.206\.79\.55\:26656"
MANTLE_SEEDS="08ab4552a74dd7e211fc79432918d35818a67189\@52\.69\.58\.231\:26656\,449a0f1b7dafc142cf23a1f6166bbbf035edfb10\@13\.232\.85\.66\:26656\,5b27a6d4cf33909c0e5b217789e7455e261941d1\@15\.222\.29\.207\:26656"
sed -i 's,^\(persistent_peers[ ]*=\).*,\1"'"$MANTLE_PEERS"'",g' ${HOME}/.assetNode/config/config.toml

sed -i 's,^\(seeds[ ]*=\).*,\1"'"$MANTLE_SEEDS"'",g' ${HOME}/.assetNode/config/config.toml

if [ ! $MANTLE_SERVERIP_NAME ]; then
	read -p "Enter SERVER IP : " MANTLE_SERVERIP_NAME
fi
sleep 1
echo 'export MANTLE_SERVERIP_NAME='$MANTLE_SERVERIP_NAME >> $HOME/.profile
sed -i 's,^\(external_address[ ]*=\).*,\1"tcp://'"$MANTLE_SERVERIP_NAME"'\:26656",g' ${HOME}/.assetNode/config/config.toml


if [ ! $MANTLE_GASPRICE_NAME ]; then
	read -p "Enter min gas price with the minimum price you want (example 0.005umantle) for the security of the network: " MANTLE_GASPRICE_NAME
fi
sleep 1
echo 'export MANTLE_GASPRICE_NAME='$MANTLE_GASPRICE_NAME >> $HOME/.profile
sed -i 's,^\(minimum-gas-prices[ ]*=\).*,\1"'"$MANTLE_GASPRICE_NAME"'",g' ${HOME}/.assetNode/config/app.toml


assetNode start


echo -e "\033[0m"
