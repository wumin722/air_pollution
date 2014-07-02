#!/usr/bin/ruby
# -*- coding: utf-8 -*-

sub_cite = IO.readlines('/home/yin/R/air_pollution/sub_cite')


def as_decimal str
  dat = str.split(',')
  dat[0].to_f + dat[1].to_f/60 + dat[2].to_f/3600
end

#'name', 'X', 'Y', 'elevation'] = line.split
def get_data line
  info = line.split
  info[0].sub!(',', '')
  info[1] = as_decimal info[1]
  info[2] = as_decimal info[2]
  info[3] = info[3].to_i
  info
end

File.open('/home/yin/R/air_pollution/proc_sub_cite1', 'w') do |f|
  f.puts "name\tX\tY\televation\n"
  sub_cite.each do |l|
    info = get_data l
    f.printf("%s\t%4f\t%4f\t%d\n", info[0], info[1], info[2], info[3])
    #    puts "#{info[0]}/t#{info[1]}/t#{info[2]}/t#{info[3]}/n"
  end
end
