require 'rufus-dollar'

class LineParser
  def initialize(params)
    @regex       = Regexp.new(params[:regex])
    @metric      = params[:metric]
    @source      = params[:source]
    @aggregation = params[:aggregation]
    @field       = params[:aggregation_field]
  end

  def parse(event)
    if variables = parse_message(event[:message])
      source = @source.present? ? Rufus.dsub(@source, variables) : event[:hostname]
      time   = event[:received_at].present? ? Time.parse(event[:received_at]) : Time.now
      value  = Rufus.dsub(@field, variables)

      if value =~ /^\d+(\.\d+)?$/
        value = value.to_f
      end

      {
        :metric      => Rufus.dsub(@metric, variables),
        :time        => time,
        :source      => source,
        :aggregation => @aggregation,
        :value       => value
      }
    end
  end

  def parse_message(message)
    if m = @regex.match(message)
      variables = {}

      m[1..-1].each_with_index do |value, idx|
        variables[(idx + 1).to_s] = value
      end

      variables
    end
  end
end