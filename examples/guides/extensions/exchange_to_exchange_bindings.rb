#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "hot_bunnies"

puts "=> Demonstrating exchange-to-exchange bindings"
puts

conn = HotBunnies.connect

ch   = conn.create_channel
x1   = ch.fanout("hot_bunnies.examples.e2e.exchange1", :auto_delete => true, :durable => false)
x2   = ch.fanout("hot_bunnies.examples.e2e.exchange2", :auto_delete => true, :durable => false)
# x1 will be the source
x2.bind(x1)

q    = ch.queue("", :exclusive => true)
q.bind(x2)

x1.publish("")

sleep 0.2
puts "Queue #{q.name} now has #{q.message_count} message in it"

sleep 0.7
puts "Disconnecting..."
conn.close
