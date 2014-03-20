require 'ffi/pcap'

pattern = /mp3:(mp3.*\/)/
dev = FFI::PCap.device_names[0]
mute = 0
pcap = FFI::PCap.open_live(:dev => dev)#, :timeout => 1, :promisc => true, :handler => FFI::PCap::Handler)
pcap.setfilter("tcp")

pcap.loop() do |this,pkt|
  res = pkt.body.scan(pattern)
  if not res.empty?
    #puts "#{res[0][0]}, #{mute}"
    if res[0][0] == "mp3-ad/" and (mute == 0 or mute == 1)
      if mute == 0
        puts 'mute'
        `powershell -Command "(new-object -com wscript.shell).SendKeys([char]173)"`
      end
      mute+=1
    elsif mute == 2
      mute = 0
      puts 'unmute'
      `powershell -Command "(new-object -com wscript.shell).SendKeys([char]175)"`
      `powershell -Command "(new-object -com wscript.shell).SendKeys([char]174)"`
    end
  end
end
