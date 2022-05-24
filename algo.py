import os

def readStuff(finals):
  basedir = '/opt/algo/configs/localhost/wireguard/.pki'
  num = 1
  users = (os.environ['USERS']).split(',')
  print(users)
  for user in users:
    num += 1
    priv = open(basedir+'/private/'+ user).readline().strip()
    pub = open(basedir + '/public/' + user).readline().strip()
    psk = open(basedir + '/preshared/' + user).readline().strip()

    finals += "[Peer]\n#"+user+"\n"
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
