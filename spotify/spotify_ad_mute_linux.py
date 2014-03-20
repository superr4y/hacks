from netfilterqueue import NetfilterQueue
import os, re
import subprocess as sp


os.system('iptables -A OUTPUT -p tcp --dport 1935 -j NFQUEUE --queue-num 0')
mute = 0
volume= 0

def print_and_accept(pkt):
    global mute
    match = re.search(r'mp3:(mp3.*/)',  pkt.get_payload())
    if match:
        #print('match', match.group(1))
        mp3_name = match.group(1)
        if mp3_name == 'mp3-ad/': #and (mute == 0 or mute == 1):
            if mute == 0:
                print('mute')
                mute_sound()
            mute += 1
        elif mute != 0:
            mute = 0
            print('unmute')
            unmute_sound()

    pkt.accept()

def mute_sound():
    global volume
    p = sp.Popen(['amixer', 'get', 'Master'], stdout=sp.PIPE)
    output = p.stdout.read()
    match = re.search(r'Mono: Playback (\d+) ', output)
    if match:
        volume = int(match.group(1))
        sp.Popen(['amixer', 'set', 'Master', '0'], stdout=sp.PIPE)
    

def unmute_sound():
    global volume # not needed
    sp.Popen(['amixer', 'set', 'Master', str(volume)], stdout=sp.PIPE)

nfqueue = NetfilterQueue()
nfqueue.bind(0, print_and_accept)
try:
    nfqueue.run()
except KeyboardInterrupt:
    # TODO: only delete the NFQUEUE rule from above
    os.system('iptables -F')
    print()
