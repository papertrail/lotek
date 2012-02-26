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

      {
        :metric      => Rufus.dsub(@metric, variables),
        :time        => Time.parse(event[:received_at]),
        :source      => source,
        :aggregation => @aggregation,
        :value       => Rufus.dsub(@field, variables)
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