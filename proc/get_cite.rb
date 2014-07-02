#encoding: utf-8

require 'open-uri'
require 'nokogiri'
require 'net/http'
require 'json'
########
#sites = ['广雅中学', '市五中'，'市监测站', '天河职幼', '麓湖', '广东商学院',
#      '市八十六中', '番禺中学', '花都师范', '九龙镇镇龙', '帽峰山',
#      '从化环保局', '增城环保局', '新塘镇政府', '永和子站', '科学城',
#      '西区子站', '黄埔文冲', '白云嘉禾', '思源中学', '龙洞小学', '荔福路沙园',
#      '大石中学', '番禺沙湾', '黄阁子站', '南沙科学馆', '十八涌', '杨箕路边站',
#      '黄沙路边站']


########set url for accessing
uri = URI('http://210.72.1.216:8080/gzaqi_new/MapData.cshtml')
req = Net::HTTP.post_form(uri, 'OpType'=> "GetAllStations")

path = '/home/yin/R/air_pollution/data/air_index'+ "-#{Time.now.month}" + '-' + "#{Time.now.day}"
##file = File.new(path,'w')
File.open(path, 'w') do |f|
  f.printf("%s, %s, %s, %s, %s, %s, %s, %s, %s, %s\n", 'Name', 'X', 'Y', 'SO2', 'NO2', 'PM10', 'CO', 'O3', 'PM2_5', 'AQI')
  JSON.parse(req.body).each do |site|
    inf = site
    air_req = Net::HTTP.post_form(uri, 'OpType'=> "GetDayData", 'EPNAME' => inf['stationName'])
    air = JSON.parse(air_req.body)['rows']
    f.printf("%s, %.4f, %.4f, %.1f, %.1f, %.1f, %.1f, %.1f, %.1f, %.1f\n", inf['stationName'], inf['X'], inf['Y'], air["SO2_24H"], air['NO2_24H'], air["PM10_24H"], air["CO_24H"], air["O3_1H_24H"], air["PM2_5_24H"], air["AQI"])
#    puts(inf['stationName'] + "\t" + inf['X'] "\t" + inf['Y'] + "\t" + air["SO2_24H"] + "\t" + air['NO2_24H']) + "\t" + air["PM10_24H"] +
  end
end

#uri_array = []
#site.length.times do |i|
#  uri_array << url + site[i]
#end

########


