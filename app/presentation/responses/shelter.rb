# frozen_string_literal: true

module PetAdoption
  module Response
    Metrics = Struct.new(:crowdedness)
    Severity = Struct.new(:old_animals_number, :severity)
  end
end
