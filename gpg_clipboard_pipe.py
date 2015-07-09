#!/usr/bin/env python2

# Takes what ever is in the clipboard, encrypts it with gpg and write it back to the clipboard.
# It can also decrypt a gpg message from from the clipboard and write it  back to it.
#
# Dependencies: xsel
# Usage: python2 gpg_clipboard_pipe.py [encrypt|decrypt]

import subprocess, sys, re
from difflib import SequenceMatcher as SM


# getchar() hack for python https://raw.githubusercontent.com/joeyespo/py-getch/master/getch/getch.py
try:
    from msvcrt import getch
except ImportError:
    def getch():
        """Gets a single character from STDIO."""
        import sys
        import tty
        import termios
        fd = sys.stdin.fileno()
        old = termios.tcgetattr(fd)
        try:
            tty.setraw(fd)
            return sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old)

# def best_match(word, l):
#     ret = {"ratio": 0.0, "match": l[0], "other": []}
#     for i in l[1:]:
#         current_ratio = SM(None, word, i).ratio()
#         if current_ratio != 0.0:
#             ret["other"].append(i)
#         if ret["ratio"] <= current_ratio:
#             ret["ratio"] = current_ratio
#             ret["match"] = i
#     return ret

def match_sort(word, l):
    """
        Returns a sorted list from best to worst.
    """
    ret = []
    for i in l:
        ratio = SM(None, word, i).ratio()
        ret.append({"ratio": ratio, "word": i})
    ret = sorted(ret, key=lambda e: e["ratio"], reverse=True)
    return ret

def fuzzy_search(l):
    """
        Trys to emulate dmenu behaviour.
        Its not that good yet.
    """
    word = ""
    index = 0
    sl = []
    marker = "## "
    while True:
        c = getch()
        print "\n"*100

        if c == "\x0d":
            return sl[index]["word"]
        elif c == "\t":
            index = (index + 1) % len(sl)
        else:
            print hex(ord(c))

        word += c
        sl =  match_sort(word, l)

        i = 0
        for e in sl:
            mark = ""
            if i == index:
                mark = marker
            if e["ratio"] > 0.0:
                print "%s %s %s"%(mark, e["word"], mark)
            i += 1

def main():

    if(len(sys.argv) != 2):
        print "Read the Code man"
        return 1

    # Possible actions are: encrypt or decrypt
    action = sys.argv[1]

    # Gets a email list of all known pgp keys
    proc = subprocess.Popen(["gpg", "--list-keys"], stdout=subprocess.PIPE)
    gpg_keys = map(lambda email: email.lower(), re.findall(r"(\S+@\S+)", proc.stdout.read()))

    # And let user decide which key
    selected_key = fuzzy_search(gpg_keys)

    # Get Clipboard Data
    clipboard = subprocess.Popen(["xsel"], stdout=subprocess.PIPE).stdout.read()

    if action == "encrypt":
        # Encrypt it with gpg
        proc = subprocess.Popen(["gpg",  "-ear", selected_key], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        gpg_message = proc.communicate(input=clipboard)[0]
    elif action == "decrypt":
        # Decrypt it with gpg
        proc = subprocess.Popen(["gpg",  "-dr", selected_key], stdin=subprocess.PIPE, stdout=subprocess.PIPE)
        gpg_message = proc.communicate(input=clipboard)[0]
    else:
        print "Why dont you read the code already :-P"
        return 1

    # Write the result back to clipboard
    print gpg_message
    proc = subprocess.Popen(["xsel", "--clipboard"], stdin=subprocess.PIPE)
    proc.stdin.write(gpg_message)

main()
