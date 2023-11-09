# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    PetAdoption::App.db.run('PRAGMA foreign_keys = OFF')
    Database::ProjectOrm::AnimalOrm.map(&:destroy)
    Database::ProjectOrm::ShelterOrm.map(&:destroy)
    PetAdoption::App.db.run('PRAGMA foreign_keys = ON')
  end
end
