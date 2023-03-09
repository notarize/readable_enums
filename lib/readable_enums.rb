module ReadableEnums
  extend ActiveSupport::Concern

  included do
    class_attribute(:defined_readable_enums, instance_writer: false, default: {})
  end

  module ClassMethods
    def readable_enum(name, values, **args)
      validates_args = args.slice(:allow_nil, :if).compact

      validates name.to_sym, inclusion: { in: values, message: "%{value} is not a valid #{name}" }, **validates_args

      values.each do |enum|
        define_method(:"#{enum}?") { send(name.to_s) == enum }
        define_method(:"#{enum}!") { update(name.to_s => enum) }
        define_singleton_method(:"#{enum}") { where(name.to_s => enum) } unless args[:with_scopes] == false
      end

      defined_readable_enums[name] = values
    end
  end
end
