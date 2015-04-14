require 'active_model'

module Sequent
  module Core
    module Helpers
      # Will parse all values to the correct types.
      # The raw values are typically posted from the web and are therefor mostly strings.
      # To parse a raw value your class must have a parse_from_string method that returns the parsed values.
      # See sequent/core/ext for currently supported classes.
      module TypeConversionSupport
        def parse_attrs_to_correct_types
          the_copy = dup
          the_copy.attributes.each do |name, type|
            raw_value = the_copy.send("#{name}")
            next if raw_value.nil?
            if raw_value.respond_to?(:parse_attrs_to_correct_types)
              the_copy.send("#{name}=", raw_value.parse_attrs_to_correct_types)
            else
              parsed_value = Sequent::Core::Helpers::StringToValueParsers.for(type).parse_from_string(raw_value)
              the_copy.send("#{name}=", parsed_value)
            end
          end
          the_copy
        end
      end
    end
  end
end
