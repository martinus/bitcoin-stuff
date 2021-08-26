#!/bin/env ruby

# because I'm so dumb with statistics, this prints out how much faster/slower something is relative to the other
t_old = ARGV[0].to_f
t_new = ARGV[1].to_f

puts "usage: <old> <new>"

percent = (t_new - t_old) / t_old * 100.0
times = t_new/t_old
if (t_new < t_old)
    puts "New is #{-percent}% faster than Old"
    puts "New is #{t_old / t_new} times faster than Old"
else
    puts "New is #{percent}% slower than Old"
end

