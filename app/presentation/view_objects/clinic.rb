# frozen_string_literal: true

# Purpose: View object for a vets
module PetAdoption
  module Views
    # View for a vets
    class Clinic
      attr_reader :clinic

      def initialize(result)
        @clinic = result.vet_info.vet_info
      end
    end

    # View for an instruction
    class TakeCareInfo
      attr_reader :instruction

      def initialize(result)
        @instruction = result.take_care_info.instruction
      end
    end
  end
end