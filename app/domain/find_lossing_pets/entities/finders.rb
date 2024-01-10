# frozen_string_literal: true

module PetAdoption
  module Entity
    # class Info::adotpers`
    class Finders
      class Errors
        CantFindTheVets = Class.new(StandardError)
      end
      attr_reader :take_care_info, :vet_info, :contact_info

      def initialize(take_care_info, contact_info, vet_info, top)
        @take_care_info = PetAdoption::Values::TakeCareInfo.new({ instruction: take_care_info })
        @contact_info = PetAdoption::Values::ContactInfo.new(contact_info)
        @vet_info = PetAdoption::Value::PetReview.new(vet_info, top)
      end

      # transfer the animal to the shelter

      # if the lossing animal is sick, then find the nearest vet or find the greatest vet
      def first_contact_vet
        @vet_info unless @vet_info.nil?
        raise Errors::CantFindTheVets if @vet_info.nil?
      end

      def animals_take_care_suggestions
        @take_care_info
      end

      def contact_me
        @contact_info
      end
    end
  end
end
