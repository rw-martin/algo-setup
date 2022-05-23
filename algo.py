import os

private = []
pubic = []
preshared = []
final = []
num = 0

def readStuff(finals):
  basedir = '/opt/algo/configs/localhost/wireguard/.pki'
  num = 1
  for file in os.listdir(basedir+"/private"):
    a = file.split('.')
    if (len(a) == 1):
        num += 1
        priv = open(basedir+'/private/'+file).readline().strip()
        pub = open(basedir + '/public/' + file).readline().strip()
        psk = open(basedir + '/preshared/' + file).readline().strip()

        finals += "[Peer]\n#"+file+"\n"
        finals += "PublicKey = "+pub+"\n"
        finals += "PresharedKey = "+psk+"\n"
        finals += "AllowedIPs = 10.49.0."+str(num)+"/32\n\n"

  return(finals)

finals="[Interface]\n"
finals += "Address = 10.49.0.1/16\n"
finals += "ListenPort = 12345\n"
finals += "PrivateKey = \n"
finals += "SaveConfig = false\n\n"

#print (readStuff(finals))
f = open("/etc/wireguard/wg0.conf","w")
f.write(readStuff(finals))
f.close()
