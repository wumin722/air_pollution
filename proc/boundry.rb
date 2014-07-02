# -*- coding: utf-8 -*-
########
#读取文件
name = ARGV[0]
path = '/home/yin/R/air_pollution/boundry_data/'
lon = /\d{3}\.\d+,/
lat = /\d{2}\.\d+;/
data = IO.readlines(path+name)
lon_vec = data[0].scan(lon).each { |v| v.sub!(',', '')}
lat_vec = data[0].scan(lat).each { |v| v.sub!(';', '')}

lon_vec.length == lat_vec.length

File.open(path+name+'.tab', 'w') do |p|
  1.upto(lon_vec.length) do |i|
    p.printf("%s\t%s\n", lon_vec[i], lat_vec[i])
  end
end

