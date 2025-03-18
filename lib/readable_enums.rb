module ReadableEnums
  extend ActiveSupport::Concern

  included do
    class_attribute(:defined_readable_enums, instance_writer: false, default: {})
  end

  module ClassMethods
    def readable_enum(name, values, **args)
      validates_args = args.slice(:allow_nil, :if).compact

      validates name.to_sym, inclusion: { in: values, message: "%{value} is not a valid #{name}" }, **validates_args

      defined_values = []

      values.each do |enum|
        unless args[:with_methods] == false
          prefix = args[:prefix] == true ? "#{name}" : args[:prefix]
          suffix = args[:suffix] == true ? "#{name}" : args[:suffix]
          method_name = [prefix, enum, suffix].compact.join('_')

          define_method(:"#{method_name}?") { send(name.to_s) == enum }
          define_method(:"#{method_name}!") { update(name.to_s => enum) }

          defined_values << method_name
        end

        define_singleton_method(:"#{enum}") { where(name.to_s => enum) } unless args[:with_scopes] == false
      end

      defined_readable_enums[name] = defined_values
    end
  end
end
