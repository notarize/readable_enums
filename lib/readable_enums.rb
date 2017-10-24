module ReadableEnums
  extend ActiveSupport::Concern

  module ClassMethods

    def readable_enum(name, values)
      validates name.to_sym, inclusion: {in: values, message: "%{value} is not a valid #{name}"}

      values.each do |enum|
        define_method(:"#{enum}?") { send(name.to_s) == enum }
        define_method(:"#{enum}!") { update(name.to_s => enum)}
        define_singleton_method(:"#{enum}") { where(name.to_s => enum)}
      end
    end
  end
end
