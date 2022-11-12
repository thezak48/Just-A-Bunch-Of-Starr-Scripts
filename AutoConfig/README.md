# AutoConfig
A script to auto populate your Radarr & Sonarr with the TRaSH Guides recommended naming scheme as well as other media management settings

## Setup
First grab the script and config
```bash
wget https://raw.githubusercontent.com/thezak48/Just-A-Bunch-Of-Starr-Scripts/zak-dev/AutoConfig/autoConfig.bash
wget https://raw.githubusercontent.com/thezak48/Just-A-Bunch-Of-Starr-Scripts/zak-dev/AutoConfig/config.conf
chmod +x ./autoConfig.bash
```
Populate the `config.conf` with your arr URL and API Key, enable the autoconfig for the arr you want and save, Then run with the below command

```
./autoconfig.bash
```


Credit goes to RandomNinjaAtk, a lot of this is based on his arr-extended projects