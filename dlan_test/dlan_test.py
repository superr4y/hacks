#/usr/bin/env python2
# My dlan and my internet connection sucks
# This script checks if dlan or my internet provider is the reason i cant watch porn
# PS: I hate both of them, they should burn in hell arrrr

import subprocess
import re
import sys

def test_connection(ip):
    proc = subprocess.Popen(["ping", "-c1", router],stdout=subprocess.PIPE)
    out = proc.stdout.read().rstrip()
    match = re.search(r'(\d) received', out)
    if not match:
        print "Something is wrong with the ping output"
        sys.exit(1)
    # check if we recieved a response
    return int(match.group(1)) == 1

router = "192.168.0.1"
google_dns = "8.8.8.8"

if not test_connection(router):
    print "Its your DLAN that little bitch"
elif not test_connection(google_dns):
    print "Change your ISP they are fucking dickheads"
else:
    print "Everything is just fine :-)"
