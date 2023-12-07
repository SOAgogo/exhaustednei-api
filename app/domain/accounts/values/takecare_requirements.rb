# frozen_string_literal: true

module PetAdoption
  module Value
    # class TakecareRequirements`
    class TakecareRequirements
      def initialize(takecare_requirements)
        @takecare_requirements = takecare_requirements
      end

      attr_reader :takecare_requirements

      def sent_by_email
        @takecare_requirements[:sent_by_email]
      end

      def sent_by_sms
        @takecare_requirements[:sent_by_sms]
      end
    end
  end
end
