module Braintree
  class CreditCardVerification
    include BaseModule
    include Braintree::Util::IdEquality

    module Status
      Failed = 'failed'
      GatewayRejected = 'gateway_rejected'
      ProcessorDeclined = 'processor_declined'
      Verified = 'verified'

      All = [Failed, GatewayRejected, ProcessorDeclined, Verified]
    end

    attr_reader :amount
    attr_reader :avs_error_response_code
    attr_reader :avs_postal_code_response_code
    attr_reader :avs_street_address_response_code
    attr_reader :billing
    attr_reader :created_at
    attr_reader :credit_card
    attr_reader :currency_iso_code
    attr_reader :cvv_response_code
    attr_reader :gateway_rejection_reason
    attr_reader :id
    attr_reader :merchant_account_id
    attr_reader :processor_response_code
    attr_reader :processor_response_text
    attr_reader :risk_data
    attr_reader :status

    def initialize(attributes) # :nodoc:
      set_instance_variables_from_hash(attributes)

      @amount = Util.to_big_decimal(amount)

      @risk_data = RiskData.new(attributes[:risk_data]) if attributes[:risk_data]
    end

    def inspect # :nodoc:
      attr_order = [
        :status,
        :processor_response_code,
        :processor_response_text,
        :amount,
        :currency_iso_code,
        :cvv_response_code,
        :avs_error_response_code,
        :avs_postal_code_response_code,
        :avs_street_address_response_code,
        :merchant_account_id,
        :gateway_rejection_reason,
        :id,
        :credit_card,
        :billing,
        :created_at
      ]
      formatted_attrs = attr_order.map do |attr|
        if attr == :amount
          Util.inspect_amount(self.amount)
        else
          "#{attr}: #{send(attr).inspect}"
        end
      end
      "#<#{self.class} #{formatted_attrs.join(", ")}>"
    end

    class << self
      protected :new
    end

    def self._new(*args) # :nodoc:
      self.new *args
    end

    def self.find(id)
      Configuration.gateway.verification.find(id)
    end

    def self.search(&block)
      Configuration.gateway.verification.search(&block)
    end

    def self.create(attributes)
      Util.verify_keys(CreditCardVerificationGateway._create_signature, attributes)
      Configuration.gateway.verification.create(attributes)
    end
  end
end
