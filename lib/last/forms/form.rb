require "active_model"; I18n.enforce_available_locales = true
require "virtus"

module Last
module Forms

class Form
  include Virtus.model
  include ActiveModel::Validations
  include Last::Forms::Validators

  attr_reader :params

  def initialize(attributes)
    @params = attributes.dup
    super
  end

  def valid?
    self_valid    = super
    nested_errors = validate_nested_forms(attribute_set: self.class.attribute_set)
    nested_valid  = nested_errors.empty?
    nested_errors.each { |k,v| errors.add(:base, "#{k}: #{v.to_hash.inspect}") }

    self_valid && nested_valid
  end

  # Performs validation.
  #
  # @raise [ValidationError] if form isn't valid
  #
  # @return [self]
  #
  def call
    raise ValidationError, self.errors unless valid?
    self
  end

  def self.call(attributes)
    new(attributes).call
  end

protected

  # Ensures that at least one of the given fields is present in the form's
  # parameters. Will add a :base error if none are present.
  #
  # @param [Array<Symbol>] fields
  #
  def self.validates_any_of(fields)
    validate do
      fields.any? { |field| params.key? field.to_s } or
        errors.add(:base, "one required field is missing from: #{fields.inspect}")
    end
  end

private

  # Looks at a form's nested attributes for embedded forms and validates those
  # forms recursively, collecting any errors into the given errors collection.
  #
  # @param attribute_set [Virtus::AttributeSet]
  #
  # @return [Hash<Symbol,Hash<Symbol,String>>]
  #
  def validate_nested_forms(attribute_set:)
    errors = {}

    # something is validatable if it inherits from our Form class
    validatable_attributes = attribute_set.select do |attribute|
      attribute.type.primitive.ancestors.include?(Form)
    end

    validatable_attributes.each do |attribute|
      attribute_form = self[attribute.name]

      if attribute_form.nil? || !attribute_form.respond_to?(:valid?) || !attribute_form.respond_to?(:errors)
        $logger.debug "attribute_form not validatable for #{attribute.name} in #{self.inspect}" if defined?($logger)
        next
      end

      unless attribute_form.valid?
        errors[attribute.name] = attribute_form.errors
      end
    end
    return errors
  end
end

class Form::ValidationError < StandardError
  attr_accessor :errors

  def initialize(errors)
    errors = [errors] unless errors.is_a?(Enumerable)
    @errors = errors
  end

  def http_status
    500
  end

  def message
    errors
  end
end

end
end
