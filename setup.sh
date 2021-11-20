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
sleep 1


exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
	echo ''
else
  sudo apt install curl -y < "/dev/null"
fi
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi

function setVa {
	if [ ! $MANTLE_NODENAME ]; then
		read -p "Enter node name: " MANTLE_NODENAME
		echo 'export MANTLE_NODENAME='\"${MANTLE_NODENAME}\" >> $HOME/.bash_profile
	fi
	echo -e '\n\e[34mYour node name:' $MANTLE_NODENAME '\e[0m\n'
	if [ ! $MANTLE_WALLET ]; then
		read -p "Enter wallet name: " MANTLE_WALLET
		echo 'export MANTLE_WALLET='\"${MANTLE_WALLET}\" >> $HOME/.bash_profile
	fi
	echo -e '\n\e[34mYour wallet name:' $MANTLE_WALLET '\e[0m\n'
	echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
	echo 'export MANTLE_CHAIN=test-mantle-1' >> $HOME/.bash_profile
	. $HOME/.bash_profile
	sleep 1
}

function sswap {
	echo -e '\n\e[34mSet up swapfile\e[0m\n'
  echo -e '\n\e[34m[Swap] Starting...\e[0m\n'
  grep -q "swapfile" /etc/fstab
  if [[ ! $? -ne 0 ]]; then
    echo -e '\n\e[34m[Swap] Swap file exist, skip.\e[0m\n'
  else
    cd $HOME
    sudo fallocate -l 4G $HOME/swapfile
    sudo dd if=/dev/zero of=swapfile bs=1K count=4M
    sudo chmod 600 $HOME/swapfile
    sudo mkswap $HOME/swapfile
    sudo swapon $HOME/swapfile
    sudo swapon --show
    echo $HOME'/swapfile swap swap defaults 0 0' >> /etc/fstab
    echo -e '\n\e[34m[Swap] Done\e[0m\n'
  fi
}

function goInst {
	echo -e '\n\e[34mInstall Go\e[0m\n' && sleep 1
	cd $HOME
	wget -O go1.16.5.linux-amd64.tar.gz https://golang.org/dl/go1.16.5.linux-amd64.tar.gz
	rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.5.linux-amd64.tar.gz && rm go1.16.5.linux-amd64.tar.gz
	echo 'export GOROOT=/usr/local/go' >> $HOME/.bash_profile
	echo 'export GOPATH=$HOME/go' >> $HOME/.bash_profile
	echo 'export GO111MODULE=on' >> $HOME/.bash_profile
	echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile && . $HOME/.bash_profile
	go version
}

function depsInst {
	echo -e '\n\e[34mPreparing to install\e[0m\n' && sleep 1
	cd $HOME
	sudo apt update
	sudo apt install make clang pkg-config libssl-dev build-essential git jq ncdu expect -y < "/dev/null"
	goInst
}

function crKey {
echo -e '\n\e[34mGenerating assetMantle keys...\e[0m\n' && sleep 1
echo -e "\n\e[45mWait some time before creating key...\e[0m\n"
sleep 5
mkdir -p $HOME/.assetClient
$HOME/go/bin/assetClient keys add $MANTLE_WALLET --keyring-backend test --output json &>> $HOME/.assetClient/validator_key.json
echo -e "You can find your mnemonic by the following command:"
echo -e "\e[32mcat $HOME/.assetClient/validator_key.json\e[39m"
export MANTLE_WALLET_ADDRESS=`$HOME/go/bin/assetClient keys show $MANTLE_WALLET --keyring-backend test -a`
echo 'export MANTLE_WALLET_ADDRESS='${MANTLE_WALLET_ADDRESS} >> $HOME/.bash_profile
. $HOME/.bash_profile
echo -e '\n\e[45mYour wallet address:' $MANTLE_WALLET_ADDRESS '\e[0m\n'
}

function fund {
echo -e "\n\e[45mRequesting funds...\e[0m\n"
curl -d "{\"address\": \"$MANTLE_WALLET_ADDRESS\"}" -H "Content-Type: application/json"  https://api.testnet.assetmantle.one/faucet/faucetRequest
echo -e "\n\e[45mVerify balance...\e[0m\n"
sleep 60
mantleAmountTmp=`assetClient q account $MANTLE_WALLET_ADDRESS | grep amount | sed -E 's/.*"([^"]+)".*/\1/'`
if [ "$mantleAmountTmp" -gt 0 ]; then
	echo -e "Your wallet balance was \e[32mfunded\e[39m!"
else
	echo -e "Your wallet balance \e[34mwas not funded\e[39m, please request again.\e[0m"
	echo -e "Request command: \e[7mcurl -d '{\"address\":\"$MANTLE_WALLET_ADDRESS\"}' -H 'Content-Type: application/json'  https://api.testnet.assetmantle.one/faucet/faucetRequest\e[0m"
	echo -e "Check your wallet balance: \e[7m$(which assetClient) q account ${MANTLE_WALLET_ADDRESS}\e[0m"
fi
}

function validatorC {
echo -e "\n\e[45mCreating validator...\e[0m\n"
export MANTLE_CHAIN=`cat $HOME/.assetNode/config/genesis.json | jq .chain_id | sed -E 's/.*"([^"]+)".*/\1/'`
$(which assetClient) tx staking create-validator -y --amount=9700000umantle --pubkey=`$(which assetNode) tendermint show-validator` --moniker=$MANTLE_NODENAME --commission-rate=0.10 --commission-max-rate=0.20 --commission-max-change-rate=0.01 --min-self-delegation=1 --from=$MANTLE_WALLET --keyring-backend test --chain-id=$MANTLE_CHAIN --fees 1500umantle
echo -e "\n\e[45mVerify your validator status...\e[0m\n"
sleep 30
mantleVPTmp=`curl -s localhost:26657/status | jq .result.validator_info.voting_power | sed -E 's/.*"([^"]+)".*/\1/'`
MANTLE_VALOPER=$(assetClient keys show $MANTLE_WALLET --keyring-backend test --bech val -a)
mantleValidatorString=$(assetClient q staking validators -o json | jq -r '.[] | [.operator_address, .status] | @csv' | grep $MANTLE_VALOPER | column -t -s",")
mantleValidatorStatus=$(echo $mantleValidatorString | awk {'print $2'})
if [ -z "${mantleValidatorString}" ]; then
	echo -e "Your validator was \e[34mnot created\e[39m.\e[0m"
	echo -e "Create validator command: \n\e[7m$(which assetClient) tx staking create-validator -y --amount=9000000umantle --pubkey=`$(which assetNode) tendermint show-validator` --moniker=$MANTLE_NODENAME --commission-rate=0.10 --commission-max-rate=0.20 --commission-max-change-rate=0.01 --min-self-delegation=1 --from=$MANTLE_WALLET --keyring-backend test --chain-id=$MANTLE_CHAIN --fees 1500umantle\e[0m"
else
	if [ "$mantleValidatorStatus" -eq 2 ]; then
		echo -e "You are \e[32mactive validator\e[39m now!"
	else
		echo -e "Your validator not in the \e[34mactive validator set\e[39m.\e[0m"
		echo -e "Increase your \e[34mbond\e[39m amount if you want to be in the active validator set.\e[0m"
	fi
fi
}

function syncCheck {
. $HOME/.bash_profile
while sleep 5; do
sync_info=`curl -s localhost:26657/status | jq .result.sync_info`
latest_block_height=`echo $sync_info | jq -r .latest_block_height`
echo -en "\r\rCurrent block: $latest_block_height"
if test `echo "$sync_info" | jq -r .catching_up` == false; then
echo -e "\nYour node was \e[32msynced\e[39m!"
fund
validatorC
break
else
echo -n ", syncing..."
fi
done
}

function iSoft {
	echo -e '\n\e[34mInstall software\e[0m\n' && sleep 1
	cd $HOME
	git clone https://github.com/persistenceOne/assetMantle.git
	cd assetMantle
	git fetch --tags
	git checkout v0.1.1
	make install
	assetNode version
	assetNode init $MANTLE_NODENAME --chain-id $MANTLE_CHAIN
	wget -q -O $HOME/.assetNode/config/genesis.json "https://raw.githubusercontent.com/persistenceOne/genesisTransactions/master/test-mantle-1/final_genesis.json"
	sha256sum $HOME/.assetNode/config/genesis.json
	assetNode unsafe-reset-all
	sed -i.bak -e "s/^minimum-gas-prices = \"\"/minimum-gas-prices = \"0.005umantle\"/" $HOME/.assetNode/config/app.toml
	sed -i '/\[grpc\]/{:a;n;/enabled/s/false/true/;Ta};/\[api\]/{:a;n;/enable/s/false/true/;Ta;}' $HOME/.assetNode/config/app.toml
	external_address=`curl -s ifconfig.me`
	peers="9a8a1d3e135531dc452172ce439dc20386064560@75.119.141.248:26656,55e140356200cecaa8f47b24cbbef6147caadda2@192.168.61.24:26656,a9668820073e0d272431e2c30ca9334d3ed22141@192.168.1.77:26656,0c34daf66b3670322d00e0f4593ca07736377ced@142.4.216.69:26656"
	sed -i.bak -e "s/^external_address = \"\"/external_address = \"$external_address:26656\"/; s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.assetNode/config/config.toml
	wget -O $HOME/.assetNode/config/addrbook.json https://raw.githubusercontent.com/Kallen-c/assetmantle/main/addr.json
}

function iServ {
echo -e '\n\e[34mRunning\e[0m\n' && sleep 1
echo -e '\n\e[34mCreating a service\e[0m\n' && sleep 1

echo "[Unit]
Description=Asset Mantle Node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which assetNode) start
Restart=always
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
" > $HOME/assetd.service
sudo mv $HOME/assetd.service /etc/systemd/system
sudo tee <<EOF >/dev/null /etc/systemd/journald.conf
Storage=persistent
EOF
sudo systemctl restart systemd-journald
sudo systemctl daemon-reload
echo -e '\n\e[34mRunning a service\e[0m\n' && sleep 1
sudo systemctl enable assetd
sudo systemctl restart assetd
echo -e '\n\e[34mCheck node status\e[0m\n' && sleep 1
if [[ `service assetd status | grep active` =~ "running" ]]; then
  echo -e "Your Asset Mantle node \e[32minstalled and works\e[39m!"
  echo -e "You can check node status by the command \e[7mservice assetd status\e[0m"
  echo -e "Press \e[7mQ\e[0m for exit from status menu"
else
  echo -e "Your Asset Mantle node \e[34mwas not installed correctly\e[39m, please reinstall."
fi
. $HOME/.bash_profile
}

function disableAssetMantle {
	sudo systemctl disable assetd
	sudo systemctl stop assetd
}

PS3='Please enter your choice (input your option number and press enter): '
options=("Install" "Disable" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Install")
            echo -e '\n\e[34mYou choose install...\e[0m\n' && sleep 1
			setVa
			sswap
			depsInst
			iSoft
			iServ
			crKey
			syncCheck
			echo -e '\n\e[34mInstallation complete!\e[0m\n' && sleep 1
			break
            ;;
		"Disable")
            echo -e '\n\e[34mYou choose disable...\e[0m\n' && sleep 1
			disableAssetMantle
			echo -e '\n\e[34massetMantle was disabled!\e[0m\n' && sleep 1
			break
            ;;
        "Quit")
            break
            ;;
        *) echo -e "\e[91minvalid option $REPLY\e[0m";;
    esac
done
