#!/usr/bin/env ruby
require 'json'
require 'net/http'
require 'uri'


module Vrr

    Query_url = URI.parse("http://efa.vrr.de/vrrstd/XSLT_TRIP_REQUEST2")
    Header = {'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64; rv:30.0) Gecko/20100101 Firefox/30.0'}

    class LiveQuery
        def initialize()
            @last_query = ''
            @response_json = ''
        end

        # if @last_query is ok => query(@last_query)
        def update()
             
        end

        # query new live data
        def query(origin_place, origin_name, dest_place, dest_name, start_time=nil)
            start_time ||= Time.new.strftime('%H:%M')
            @response_json = send_vrr_request(origin_place, origin_name,
                                              dest_place, dest_name, start_time)
            return parse(@response_json)
        end

        # parse the json string and fill some vars
        def parse(json)
            ret = []
            json['trips'].each do |trip| 
                trip['trip']['legs'].each do |leg|
                    current_trip = {}
                    current_trip[:name] = leg['points'][0]['name'] 
                    current_trip[:time] = leg['points'][0]['dateTime']['time']
                    current_trip[:line] = leg['mode']['name']
                    current_trip[:dest] = "#{leg['points'][1]['name']} -> #{leg['mode']['destination']}"
                    ret << current_trip
                end
                #puts JSON.pretty_generate(trip['trip']['legs'][0]['mode'])
            end
            return ret
        end


        # Send a POST request to http://efa.vrr.de/vrrstd/XSLT_TRIP_REQUEST2 
        # returns json response
        def send_vrr_request(origin_place, origin_name, dest_place, dest_name, start_time)
            hour, minute = start_time.split(':')
            
            # always use the current day as date for now
            day, month, year = Time.new.strftime('%d:%m:%Y').split(':')
            post_data = " 
sessionID=0&language=de&requestID=0&command=&itdLPxx_ShowFare=+&itdLPxx_view=&useRealtime=1&itdLPxx_enableMobilityRestrictionOptionsWithButton=&execInst=&itdLPxx_mdvMap2_origin=&itdLPxx_mdvMap2_destination=&itdLPxx_mdvMap2_via=&itdLPxx_mapState_origin=&itdLPxx_mapState_destination=&itdLPxx_mapState_via=&itdLPxx_mdvMap_origin=%3A%3A&itdLPxx_mdvMap_destination=%3A%3A&itdLPxx_mdvMap_via=%3A%3A&itdLPxx_command=&itdLPxx_priceCalculator=&itdLPxx_showTariffLevel=1&ptOptionsActive=1&itOptionsActive=1&itdLPxx_transpCompany=vrr&placeInfo_origin=invalid&typeInfo_origin=invalid&nameInfo_origin=invalid&placeState_origin=empty&nameState_origin=empty&useHouseNumberList_origin=1&place_origin=#{origin_place}&type_origin=stop&name_origin=#{origin_name}&itdLPxx_id_origin=%3Aorigin&placeInfo_destination=invalid&typeInfo_destination=invalid&nameInfo_destination=invalid&placeState_destination=empty&nameState_destination=empty&useHouseNumberList_destination=1&place_destination=#{dest_place}&type_destination=stop&name_destination=#{dest_name}&itdLPxx_id_destination=%3Adestination&placeInfo_via=invalid&typeInfo_via=invalid&nameInfo_via=invalid&placeState_via=empty&nameState_via=empty&useHouseNumberList_via=1&place_via=&type_via=stop&name_via=&itdLPxx_id_via=%3Avia&lineRestriction=403&routeType=LEASTTIME&changeSpeed=normal&itdTripDateTimeDepArr=dep&itdTimeHour=#{hour}&itdTimeMinute=#{minute}&itdDateDay=#{day}&itdDateMonth=#{month}&itdDateYear=#{year}&submitButton=anfordern&imparedOptionsActive=1&trITDepMOT=100&trITDepMOTvalue100=10&trITArrMOT=100&trITArrMOTvalue100=10&trITDepMOTvalue101=15&trITArrMOTvalue101=15&trITDepMOTvalue104=10&trITArrMOTvalue104=10&trITDepMOTvalue105=30&trITArrMOTvalue105=30&includedMeans=checkbox&inclMOT_0=on&inclMOT_3=on&inclMOT_6=on&inclMOT_9=on&inclMOT_1=on&inclMOT_4=on&inclMOT_7=on&inclMOT_10=on&inclMOT_2=on&inclMOT_5=on&inclMOT_8=on&inclMOT_11=on&maxChanges=9&outputFormat=JSON"

            http = Net::HTTP.new(Query_url.host, Query_url.port)
            resp = http.send_request('POST', Query_url.path, post_data, Header)

            return JSON.parse(resp.body)
        end


        def pretty_print(list)
            list.each do |t|
                puts "#{t[:line]}, #{t[:name]}, #{t[:time]}, #{t[:dest]}" 
            end
        end

    end
end

vrr = Vrr::LiveQuery.new
vrr.pretty_print(vrr.query('Bochum', 'hbf', 'Bochum', 'uni'))
gets
