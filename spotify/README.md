Spotify is cool but the ads are annoying as hell.
This script mute the ads and unmute when the ad is done.
At the moment the script sniff all tcp traffic and search for a particular pattern.
I know this is bad ;-)

In Linux I will use NFQUEUE instead.

At the moment this script works for Windows only but I will add Linux support as needed.

Requirements:
- winpcap
- ffi-pcap

Install:
- install winpcap
- gem install ffi-pcap
- git clone https://github.com/superr4y/hacks.git


Usage:
- ruby spotify_ad_mute.rb
