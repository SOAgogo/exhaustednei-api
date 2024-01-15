# frozen_string_literal: true

module PetAdoption
  # Infrastructure to clone while yielding progress
  module MAPSMonitor
    CLONE_PROGRESS = {
      'STARTED' => 15,
      'FINDVETSFORYOU' => 50,
      'FINISHED' => 100
    }.freeze

    def self.starting_percent
      CLONE_PROGRESS['STARTED'].to_s
    end

    def self.vets_recommendation_percent
      CLONE_PROGRESS['FINDVETSFORYOU'].to_s
    end

    def self.finish_percent
      CLONE_PROGRESS['FINISHED'].to_s
    end
  end
end
