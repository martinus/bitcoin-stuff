#!/bin/env ruby
require "date"
require "pp"

# Simple parser for bitcoind's debug.log file
#
# input looks like this:
# 2021-08-19T07:32:11Z UpdateTip: new best=0000000000000000000a3f7a1c99d3acedd84658886782c04750f59bac9e60b0 height=632169 version=0x27ffe000 log2_work=91.986597 tx=534065287 date='2020-05-29T10:50:23Z' progress=0.805575 cache=7683.6MiB(68264657txo)

def parse(filename, resolution)
    # first, parse everything into data
    data = [[0, 0, 0, 0, 0]]
    t_start = nil
    File.read(filename).each_line do |l|
        begin
            t = DateTime.parse(l[0...20])
            if t_start.nil?
                t_start = t 
            end

            t_sec_now = ((t - t_start)*24*60*60).to_i

            t_sec_now = (t_sec_now / resolution) * resolution

            while data.last[0] + resolution < t_sec_now
                data.push data.last.clone
                data.last[0] += resolution
            end

            m = /UpdateTip:.*height=(\d+) .* tx=(\d+) .* cache=(.*)MiB\((\d+)txo/.match(l)
            if m
                height = m[1]
                tx = m[2]
                cache_MiB = m[3]
                cache_tx = m[4]

                # overwrite when second has not changed
                if (data.last[0] == t_sec_now)
                    data.pop
                end
                data.push [t_sec_now, height, tx, cache_MiB, cache_tx]
            else
                if (data.last[0] != t_sec_now)
                    data.push(data.last.clone)
                end
                data.last[0] = t_sec_now
            end
        rescue => e
            STDERR.puts "'#{l.strip}': #{e}"
        end
    end


    t_next = 0
    data.each do |d|
        if d[0] != t_next
            raise "t_next does not match!"
        end
        t_next += resolution
        yield d
    end
end


=begin
puts "time[sec]\theight\ttx\tcache[MiB]\tcache[tx]"
parse(ARGV[0]) do |t_sec_now, height, tx, cache_MiB, cache_tx|
    puts "#{t_sec_now}\t#{height}\t#{tx}\t#{cache_MiB}\t#{cache_tx}"
end
=end


# 10 second resolution
resolution = 10

puts "t[min]\ttx\tcache[tx]\tcache[MiB]"
parse(ARGV[0], resolution) do |t, height, tx, cache_MiB, cache_tx|
    #puts "#{t_sec_now/60.0}\t#{tx.to_f/1000000}\t#{cache_tx.to_f/1e6}"
    puts "#{t/60.0}\t#{tx.to_f/1000000}\t#{cache_tx.to_f/1e6}\t#{cache_MiB}"
end
