#!/bin/env ruby
require "date"

# Simple parser for bitcoind's debug.log file
#
# input looks like this:
# 2021-08-19T07:32:11Z UpdateTip: new best=0000000000000000000a3f7a1c99d3acedd84658886782c04750f59bac9e60b0 height=632169 version=0x27ffe000 log2_work=91.986597 tx=534065287 date='2020-05-29T10:50:23Z' progress=0.805575 cache=7683.6MiB(68264657txo)

t_start = nil
t_sec_last = -1

puts "time[sec]\theight\ttx\tcache[MiB]\tcache[tx]"
File.read(ARGV[0]).each_line do |l|
    # 2020-09-25 04:51:20.077
    m = /^(.*) UpdateTip:.*height=(\d+) .* tx=(\d+) .* cache=(.*)MiB\((\d+)txo/.match(l)
    next unless m

    t = DateTime.parse(m[1])
    if t_start.nil?
        t_start = t 
    end
    height = m[2]
    tx = m[3]
    cache_MiB = m[4]
    cache_tx = m[5]

    t_sec_now = ((t - t_start)*24*60*60).to_i
    if (t_sec_now != t_sec_last)
        puts "#{t_sec_now}\t#{height}\t#{tx}\t#{cache_MiB}\t#{cache_tx}"
        t_sec_last = t_sec_now
    end
end
