#!/usr/bin/env python2
# -*- coding: utf-8 -*-
# Dependncies: wget
import re, requests, json, sys, subprocess, time

def wget(file_name, url):
    subprocess.Popen(['/usr/bin/wget', '-O', "%s.mp3"%(file_name), url])

album_url = sys.argv[1]

r = requests.get(album_url)
page = r.content

trackinfo =  re.search(r'trackinfo\s:\s+(.*)', page).group(1)[:-1]
trackinfo = json.loads(trackinfo)

count = 1
print "[+] Found following tracks:"
print "-"*30
for track in trackinfo:
    print "[%d] %s"%(count, track['title'])
    count += 1
time.sleep(5)
for track in trackinfo:
    wget(track['title'], track['file']['mp3-128'])
