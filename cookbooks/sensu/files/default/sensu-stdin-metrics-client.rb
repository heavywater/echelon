#!/usr/bin/env ruby
require 'rubygems'
require 'socket'
require 'json'
require 'timeout'

class SensuClient
  attr_accessor :socket, :metric, :interval

  def socket
    begin
      @socket ||= TCPSocket.new("localhost", 3030)
    rescue Errno::ECONNREFUSED => e
      backoff e
      retry
    end
  end

  def socket_reset
    unless @socket.nil? or (@socket.respond_to? :closed? and @socket.closed?)
      @socket.close
      puts "#{self}#socket_reset: socket closed #{socket.inspect}"
      @socket = nil
    end
  end

  def backoff exception
    increase_interval
    puts "#{self}#backoff: backing off due to error #{exception.inspect}, sleeping for #{interval}"
    sleep interval
    socket_reset
  end

  def metric
    @metric ||= {
      "name" => "test",
      "type" => "metric",
      "handler" => "graphite"
    }
  end

  def increase_interval
    if @interval <= 3600
      @interval = (@interval * 1.5).to_i
    end
  end

  def reduce_interval
    if @interval <= 10
      puts "#{self}#reduce_interval: success, resetting interval to default"
      @interval = 10
    end
  end

  def initialize
    trap("INT") do
      if @socket.respond_to? :closed and @socket.closed?
        puts "#{self}#trap: closing socket"
        @socket.close
      end

      puts "exiting"
      Process.exit 0
    end
    @interval ||= 10
    run
  end

  def run
    begin
      metric["output"] = read_from_argf
      puts "#{self}#run: sending: #{metric.to_hash.inspect}"
      if socket.write metric.to_json
        reduce_interval
        sleep interval
      end
    rescue SocketError, Errno::EPIPE, IOError => e
      backoff e
      retry
    end
  end

  def read_from_argf
    Timeout::timeout(1) do
      ARGF.reject do |line|
        line.split.size != 3
      end.join("\n")
    end
  rescue Errno::EAGAIN => e
    puts "#{self}#read_from_argf: no graphite data on STDIN via ARGF detected"
    Process.exit
  rescue Timeout::Error => e
    puts "#{self}#read_from_argf: timeout during ARGF read #{e.inspect}"
    Process.exit
  end
end

sc = SensuClient.new
sc.run
