#!/usr/bin/env ruby
require 'pty'

# This script scans the output from 'strace spotify' and search for ads
# If it finds one it will mute the master channel and umute it if the ad is over.
# The script was developed for the Spotify Linux Client.
#
#
# Usage: sudo ./spotify_ad_blocker_linux.rb


class SpotifyAdBlocker
    def initialize cmd
        @volume = 0
        @mute = false
        @ad_chooser = false
        @debug = false

        exec_and_scan cmd do |line|
            puts "### #{line}" if @debug
            if line.match /ad_chooser.*adclass = ''/
                # ads with no adclass are the badboys 
                # next track will be probably an ad
                # Example: [ad_chooser.cpp:1150] Found ad (time = 663, adclass = '', time left = 30, length = 22)
                @ad_chooser = true
                puts 'ad_chooser found'
            end
            if line.match /index=/
                # lines with 'index=' indecates a new track
                if @mute
                    # the last track was muted, this track is porbably not an ad.
                    # TODO: what if spotify decides to play more then one ad.
                    unmute_sound()
                end
                if @ad_chooser
                    # ad_chooser was executed this is probably an ad.
                    # Lets mute this sucker :P 
                    mute_sound()
                    @ad_chooser = false
                end
            end
        end
    end

    def exec_and_scan(cmd, &block)
        #http://stackoverflow.com/questions/1154846/continuously-read-from-stdout-of-external-process-in-ruby#answer-1162850
        begin
          PTY.spawn( cmd ) do |stdin, stdout, pid|
            begin
              stdin.each { |line| block.call(line)}
            rescue Errno::EIO
            end
          end
        rescue PTY::ChildExited
          puts 'The child process exited!'
        end
    end

    def mute_sound()
        output = `amixer get Master`
        match = output.match(/Mono: Playback (\d+) /)
        if match
            @volume = match[1].to_i
            `amixer set Master 0`
            @mute = true
        end
        puts 'mute' 
    end

    def unmute_sound()
        `amixer set Master #{@volume}`
        @mute = false
        puts 'unmute'
    end

end


# group => blockify:x:1003:user
# gshadow => blockify:!::user
#
# EDIT to your own group
gid = 'blockify'

# delete old rules
`iptables -D OUTPUT -m owner --gid-owner #{gid} -p udp --dport 53 -j ACCEPT`
`iptables -D OUTPUT -m owner --gid-owner #{gid} -p tcp  --dport 4070 -j ACCEPT`
`iptables -D OUTPUT -m owner --gid-owner #{gid} -j DROP`

# add rules to block all unnecessary communication
`iptables -A OUTPUT -m owner --gid-owner #{gid} -p udp --dport 53 -j ACCEPT`
`iptables -A OUTPUT -m owner --gid-owner #{gid} -p tcp  --dport 4070 -j ACCEPT`
`iptables -A OUTPUT -m owner --gid-owner #{gid} -j DROP`

SpotifyAdBlocker.new "sg #{gid} -c spotify"
