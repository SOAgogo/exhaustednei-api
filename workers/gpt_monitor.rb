# frozen_string_literal: true

module PetAdoption
  # Infrastructure to clone while yielding progress
  module GPTMonitor
    CLONE_PROGRESS = {
      'STARTED' => 15,
      'ImageProcessing' => 50,
      'FINISHED' => 100
    }.freeze

    def self.starting_percent
      CLONE_PROGRESS['STARTED'].to_s
    end

    def self.image_processing_percent
      CLONE_PROGRESS['ImageProcessing'].to_s
    end

    def self.finished_percent
      CLONE_PROGRESS['FINISHED'].to_s
    end
  end
end
