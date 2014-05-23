#!/usr/bin/env ruby
require 'pty'

class SpotifyAdBlocker
    def initialize cmd
        @volume = 0
        @mute = false
        @ad_chooser = false
        @debug = true


        exec_and_scan cmd do |line|
            puts line if @debug
            if line.match /ad_chooser/
                @ad_chooser = true
                puts 'ad_chooser found' if @debug
            end
            if @mute and line.match /index=/
                unmute_sound()
            end
            if @ad_chooser and line.match /index=0/
                mute_sound()
                @ad_chooser = false
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
        puts 'mute' if @debug
    end

    def unmute_sound()
        `amixer set Master #{@volume}`
        @mute = false
        puts 'unmute' if @debug
    end

end

SpotifyAdBlocker.new 'sudo sctrace spotify'
