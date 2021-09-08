#!/bin/env ruby
require "pp"

# 2021-09-07T14:47:21Z [opencon] Enter: lock contention cs_main, net_processing.cpp:1152 completed (18258μs)
def parse(filename)
    # first, parse everything into data
    data = [[0, 0, 0, 0, 0]]
    t_start = nil
    File.read(filename).each_line do |l|
        m = /lock contention (.*), (.*) completed \((\d*).?s\)/.match(l)
        next unless m
        lock = m[1]
        location = m[2]
        duration_us = m[3].to_i

        yield lock, location, duration_us
    end
end

lock_to_location_to_duration = Hash.new do |h, k|
    h[k] = [0, Hash.new { |h,k| h[k] = 0 }]
end
parse(ARGV[0]) do |lock, location, duration_us|
    lock_to_location_to_duration[lock][0] += duration_us
    lock_to_location_to_duration[lock][1][location] += duration_us
end

s = lock_to_location_to_duration.to_a.sort { |a,b| a[1][0] <=> b[1][0] }

s.each do |lock, total_and_location_to_duration|
    sorted = total_and_location_to_duration[1].to_a.sort { |a, b| a[1] <=> b[1] }
    sorted.each do |location, duration|
        printf("%10.3fms %s\n", duration * 1e-3, location)
    end
    printf("----------------------\n%10.3fms %s\n\n", total_and_location_to_duration[0] * 1e-3, lock)
end
