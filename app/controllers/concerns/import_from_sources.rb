require 'singleton'

class ImportFromSources
  include Singleton

  def initialize
    @bunny = Bunny.new(vhost: '/',
                       user: 'guest',
                       pass: 'guest')
    @bunny.start
    @channel = @bunny.create_channel
    @exchange = @channel.direct('import',
                                durable: true)
  end

  def import_from_sources
    ids = Source.ids
    ids.each do |id|
      @exchange.publish(id.to_s, routing_key: :update_company_queue)
    end
  end
end