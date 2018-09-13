module Spree::Chimpy
  module Workers
    class SidekiqWorker
      delegate :log, to: Spree::Chimpy

      if defined?(::Sidekiq)
        include ::Sidekiq::Worker
      end

      def perform(payload_id, klass)
        if klass == Spree::Order.to_s
          payload = Spree::Order.find(payload_id)
          event = :order
        else
          fail ArgumentError
        end

        Spree::Chimpy.perform({object: payload, id: payload_id, event: event} )
      end

    end
  end
end

