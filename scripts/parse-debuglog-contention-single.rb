#!/bin/env ruby
require "pp"

# run with
# bitcoind -printtoconsole=0 -debug=lock -logthreadnames

# 2021-09-07T14:47:21Z [opencon] Enter: lock contention cs_main, net_processing.cpp:1152 completed (18258μs)
def parse(filename)
    # first, parse everything into data
    data = [[0, 0, 0, 0, 0]]
    t_start = nil
    File.read(filename).each_line do |l|
        m = /\[(.*)\].* lock contention (.*) completed \((\d*).?s\)/.match(l)
        next unless m
        thread = m[1]
        where = m[2]
        duration_us = m[3].to_i

        yield thread, where, duration_us
    end
end

h = Hash.new { |h,k| h[k] = [0, 0] }

parse(ARGV[0]) do |thread, where, duration_us|
    h[[thread, where]][0] += duration_us
    h[[thread, where]][1] += 1
end

sorted = h.to_a.sort do |a,b|
    b[1] <=> a[1]
end

printf("total[ms] | average[ms] | count | thread | where\n")
printf("---:|---:|---:|---|---\n")
sorted.each do |thread_where, duration_count|
    thread, where = thread_where
    duration_us, count = duration_count
    printf("%.3f | %.3f | %d | %s | `%s`\n", duration_us * 1e-3, (duration_us * 1e-3)/count, count, thread, where)
end
