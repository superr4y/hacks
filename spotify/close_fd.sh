#!/usr/bin/env sh


# Not very useful Spotify has to much ad domains and even i could block all domains
# Spotify will go to offline mode.



#http://adclick.g.doubleclick.net/aclk?sa=L&ai=Bt90d9E_mU5-yK8Tz-QbJrYDAC6S_w8gFAAAAEAEgvK75HjgAWKyTib2oAWCVoqCCsAeyARNhZC1mYWtlLnNwb3RpZnkuY29tugEJZ2ZwX2ltYWdlyAEJ2gEoaHR0cDovL2FkLWZha2Uuc3BvdGlmeS5jb20vP3Q9MTQwNzYwMjY3NqkC4UNEC_t_tj7AAgLgAgDqAhAvNjQ2NTA1Mi9kZXNrdG9w-ALy0R6QA8gGmAPQBagDAdAEkE7gBAGgBhY&num=0&sig=AOD64_21qFCbRHc_yqW81Gvvu6F-2Ps2Vw&client=ca-pub-7555550034254517&adurl=


#All Banner requests are over webserver maybe I can block port 80,443
#Test to block all dport=80,443
#sudo iptables -A OUTPUT -p tcp  --dport 80 -j DROP 
#sudo iptables -A OUTPUT -p tcp  --dport 443 -j DROP 


# Run Spotify in LXC Container:
install lxc, bridge-utils

brctl addbr br0 
ifconfig br0 10.0.0.1 netmask 255.255.255.0




# Time to RE Spotify Client...

# Intressing functions:

###############################
#### close socket with gdb ####
###############################
#16:00:35.605 E [ap_connection_impl.cpp:822      ] AP Socket Error: Software caused connection abort (103)
#16:00:35.605 E [ap_handler_impl.cpp:975         ] Connection error:  112
#16:00:35.605 I [ap_connection_impl.cpp:880      ] Connecting to AP lon3-accesspoint-a21.ap.spotify.com:4070
#16:00:35.720 I [ap_connection_impl.cpp:534      ] Connected to AP: 194.132.198.35:4070
#[0809/180041:ERROR:tcp_client_socket_libevent.cc(383)] close: Bad file descriptor
#16:00:42.383 E [ap_connection_impl.cpp:822      ] AP Socket Error: Bad file descriptor (9)
#16:00:42.383 E [ap_handler_impl.cpp:975         ] Connection error:  101
#16:00:42.383 I [ap_connection_impl.cpp:880      ] Connecting to AP lon3-accesspoint-a12.ap.spotify.com:4070
#16:00:42.463 I [ap_connection_impl.cpp:534      ] Connected to AP: 194.132.198.114:4070
#16:00:45.855 E [ap_connection_impl.cpp:822      ] AP Socket Error: Bad file descriptor (9)
#16:00:45.855 E [ap_handler_impl.cpp:975         ] Connection error:  101
#16:00:45.855 I [ap_connection_impl.cpp:880      ] Connecting to AP elmira.ap.spotify.com:4070
#16:00:45.950 I [ap_connection_impl.cpp:534      ] Connected to AP: 78.31.9.36:4070
#16:00:53.460 E [ap_connection_impl.cpp:822      ] AP Socket Error: Bad file descriptor (9)
#16:00:53.460 E [ap_handler_impl.cpp:975         ] Connection error:  101
#16:00:53.460 I [ap_connection_impl.cpp:880      ] Connecting to AP lon3-accesspoint-a20.ap.spotify.com:4070
#16:00:53.538 I [ap_connection_impl.cpp:534      ] Connected to AP: 194.132.196.162:4070
#16:01:00.584 E [ap_connection_impl.cpp:822      ] AP Socket Error: Bad file descriptor (9)
#16:01:00.584 E [ap_handler_impl.cpp:975         ] Connection error:  101
#16:01:00.584 I [ap_connection_impl.cpp:880      ] Connecting to AP lon3-accesspoint-a8.ap.spotify.com:4070
#16:01:00.664 I [ap_connection_impl.cpp:534      ] Connected to AP: 194.132.198.50:4070
#16:02:24.635 E [ap_connection_impl.cpp:822      ] AP Socket Error: Bad file descriptor (9)
#16:02:24.635 E [ap_handler_impl.cpp:975         ] Connection error:  101
#16:02:24.635 I [ap_connection_impl.cpp:880      ] Connecting to AP lon3-accesspoint-a48.ap.spotify.com:4070
#16:02:24.792 I [ap_connection_impl.cpp:534      ] Connected to AP: 194.132.197.197:4070
#16:04:10.934 I [social_reporter.cpp:193         ] SocialReporter: A track was played
#16:04:10.935 D [spirc_manager.cpp:578           ] GAIA: SpircManager::stpLoad, track=spotify:track:1yQXnjWzpq9uSJTbzIfoAP, index=3, position=0, paused=0
#16:07:51.735 I [social_reporter.cpp:193         ] SocialReporter: A track was played
#16:07:51.735 D [spirc_manager.cpp:578           ] GAIA: SpircManager::stpLoad, track=spotify:track:2GSwjQa6vhwEp3AbDW6mpj, index=4, position=0, paused=0
#16:10:38.635 I [ad_chooser.cpp:1171             ] Found ad (time = 900, adclass = '', time left = 30, length = 18)

if [ "$#" -ne 1 ]; then 
    echo "usage ./$0 <pid>"
    exit 1
fi

lsof -p "$1" | grep "IPv4" | grep "ESTABLISHED"
echo "choose fd:"
read fd

connections=$(lsof -p "$1" | grep "IPv4")

domain=$(echo $connections | sed "s/.*$fd.*->//" | sed 's/:.*//') 
printf "127.0.0.1 $domain\n" >> /etc/hosts 
printf "p close($fd)\ndetach\nq" | sudo gdb --pid $1

####################
#### /etc/hosts ####
####################
#127.0.0.1 a2-16-62-75.deploy.akamaitechnologies.com
#127.0.0.1 a2-16-62-75.deploy.akamaitechnologies.com
#127.0.0.1 a2-16-62-75.deploy.akamaitechnologies.com
#127.0.0.1 a2-16-62-75.deploy.akamaitechnologies.com
#127.0.0.1 a2-16-62-75.deploy.akamaitechnologies.com
#127.0.0.1 a2-16-62-75.deploy.akamaitechnologies.com
#127.0.0.1 a2-16-62-75.deploy.akamaitechnologies.com
#127.0.0.1 a2-16-62-75.deploy.akamaitechnologies.com
#127.0.0.1 a2-16-62-75.deploy.akamaitechnologies.com
#127.0.0.1 a2-16-62-82.deploy.akamaitechnologies.com
#127.0.0.1 a2-16-62-82.deploy.akamaitechnologies.com
#127.0.0.1 a2-16-62-82.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-18-34.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-18-34.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-18-34.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-18-34.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-18-34.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-18-34.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-18-34.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-18-34.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-18-34.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-18-34.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-18-34.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-92-241.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-93-113.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-93-113.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-93-113.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-93-113.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-93-113.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-93-113.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-93-113.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-93-113.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-93-113.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-93-17.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-93-17.deploy.akamaitechnologies.com
#127.0.0.1 a88-221-93-17.deploy.akamaitechnologies.com
#127.0.0.1 ea-in-f132.1e100.net
#127.0.0.1 ea-in-f132.1e100.net
#127.0.0.1 ea-in-f132.1e100.net
#127.0.0.1 ea-in-f132.1e100.net
#127.0.0.1 ea-in-f132.1e100.net
#127.0.0.1 ea-in-f132.1e100.net
#127.0.0.1 ea-in-f149.1e100.net
#127.0.0.1 ea-in-f149.1e100.net
#127.0.0.1 ea-in-f149.1e100.net
#127.0.0.1 ea-in-f149.1e100.net
#127.0.0.1 ea-in-f149.1e100.net
#127.0.0.1 ea-in-f154.1e100.net
#127.0.0.1 ea-in-f154.1e100.net
#127.0.0.1 ea-in-f154.1e100.net
#127.0.0.1 ea-in-f155.1e100.net
#127.0.0.1 ea-in-f155.1e100.net
#127.0.0.1 ea-in-f155.1e100.net
#127.0.0.1 ea-in-f155.1e100.net
#127.0.0.1 ea-in-f155.1e100.net
#127.0.0.1 ea-in-f155.1e100.net
#127.0.0.1 ec2-107-23-108-157.compute-1.amazonaws.com
#127.0.0.1 ec2-107-23-108-157.compute-1.amazonaws.com
#127.0.0.1 ec2-107-23-108-157.compute-1.amazonaws.com
#127.0.0.1 ec2-107-23-108-157.compute-1.amazonaws.com
#127.0.0.1 ec2-107-23-108-157.compute-1.amazonaws.com
#127.0.0.1 ec2-107-23-108-157.compute-1.amazonaws.com
#127.0.0.1 ec2-107-23-108-157.compute-1.amazonaws.com
#127.0.0.1 ec2-46-51-190-88.eu-west-1.compute.amazonaws.com
#127.0.0.1 ec2-46-51-190-88.eu-west-1.compute.amazonaws.com
#127.0.0.1 ec2-46-51-190-88.eu-west-1.compute.amazonaws.com
#127.0.0.1 ec2-46-51-190-88.eu-west-1.compute.amazonaws.com
#127.0.0.1 ec2-46-51-190-88.eu-west-1.compute.amazonaws.com
#127.0.0.1 ec2-46-51-190-88.eu-west-1.compute.amazonaws.com
#127.0.0.1 ee-in-f156.1e100.net
#127.0.0.1 ee-in-f156.1e100.net
#127.0.0.1 ee-in-f156.1e100.net
#127.0.0.1 ee-in-f156.1e100.net
#127.0.0.1 ee-in-f156.1e100.net
#127.0.0.1 ee-in-f156.1e100.net
#127.0.0.1 ee-in-f157.1e100.net
#127.0.0.1 ee-in-f157.1e100.net
#127.0.0.1 ee-in-f157.1e100.net
#127.0.0.1 ee-in-f157.1e100.net
#127.0.0.1 ee-in-f157.1e100.net
#127.0.0.1 ee-in-f157.1e100.net
#127.0.0.1 ee-in-f157.1e100.net
#127.0.0.1 ee-in-f157.1e100.net
#127.0.0.1 ee-in-f157.1e100.net
#127.0.0.1 ee-in-f157.1e100.net
#127.0.0.1 elmira.lon2.spotify.com
#127.0.0.1 elmira.lon2.spotify.com
#127.0.0.1 elmira.lon2.spotify.com
#127.0.0.1 elmira.lon2.spotify.com
#127.0.0.1 elmira.lon2.spotify.com
#127.0.0.1 elmira.lon2.spotify.com
#127.0.0.1 elmira.lon2.spotify.com
#127.0.0.1 ernestine.lon2.spotify.com
#127.0.0.1 fernanda.lon2.spotify.com
#127.0.0.1 fernanda.lon2.spotify.com
#127.0.0.1 fernanda.lon2.spotify.com
#127.0.0.1 fernanda.lon2.spotify.com
#127.0.0.1 fernanda.lon2.spotify.com
#127.0.0.1 fernanda.lon2.spotify.com
#127.0.0.1 lon3-accesspoint-a10.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a12.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a14.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a15.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a2.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a20.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a23.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a23.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a23.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a23.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a23.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a23.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a23.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a24.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a24.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a24.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a24.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a24.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a24.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a27.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a27.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a28.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a3.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a3.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a31.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a31.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a37.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a38.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a45.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a45.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a45.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a45.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a45.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a48.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a48.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a48.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a48.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a48.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a48.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a48.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a6.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a8.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a8.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a8.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a8.lon3.spotify.com
#127.0.0.1 lon3-accesspoint-a8.lon3.spotify.com
#127.0.0.1 lon3-weblb-wg1.lon3.spotify.com
#127.0.0.1 lon3-weblb-wg1.lon3.spotify.com
#127.0.0.1 sto3-weblb-wg2.sto3.spotify.com
#127.0.0.1 sto3-weblb-wg2.sto3.spotify.com
#127.0.0.1 sto3-weblb-wg2.sto3.spotify.com


