# frozen_string_literal: true

module PetAdoption
  module Response
    ClinicRecommendation = Struct.new(:clinics, :take_care_info)
  end
end
