# algo-setup

The script calls an ansible playbook which installs and configures Algo VPN on Ubuntu
  - The latest version of algo
  - Configures wireguard to run on a random port and configures UFW accordingly
  - Generates WireGuard QR codes via qrencode
  - Renames host based on random Transformers name; e.g. OptimusPrime, Bumblebee, Starscream, etc
  - Downloads latest IP deny list for dnscrypt-proxy
  - Creates/schedules cron job to download/update latest IP deny list
  - Configures apparmor
  
  
