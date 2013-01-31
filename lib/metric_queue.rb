require 'sum_gauge'
require 'average_gauge'

class MetricQueue
  def initialize(memcached, interval)
    @memcached = memcached
    @interval  = interval

    @gauges = {}
  end

  def save
    @gauges.each do |key, gauge|
      gauge.save
    end
  end

  def empty?
    @gauges.empty?
  end

  def to_hash
    gauges = @gauges.collect do |name, gauge|
      gauge.to_hash
    end

    {
      :gauges => gauges
    }
  end

  def average_gauge(name, time, source, value)
    time = rounded_time(time)
    key = [ name, time, source ].join('/')
    @gauges[key] ||= AverageGauge.new(name, time, source, @memcached)
    @gauges[key].mark(value)
  end

  def sum_gauge(name, time, source, value)
    time = rounded_time(time)
    key = [ name, time, source ].join('/')
    @gauges[key] ||= SumGauge.new(name, time, source, @memcached)
    @gauges[key].mark(value)
  end

  def rounded_time(time)
    time = time.to_i
    time -= time % @interval
    time
  end
end
