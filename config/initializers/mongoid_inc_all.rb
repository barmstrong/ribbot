module Mongoid #:nodoc:
  module Contexts #:nodoc:
    class Mongo
      def inc_all(attributes = {})
        klass.collection.update(
          selector,
          { "$inc" => attributes },
          Safety.merge_safety_options(:multi => true)
        ).tap do
          Threaded.clear_safety_options!
        end
      end
    end
  end
end