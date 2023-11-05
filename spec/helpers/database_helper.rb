# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    Info::App.db.run('PRAGMA foreign_keys = OFF')
    Database::ProjectOrm::AnimalOrm.map(&:destroy)
    Database::ProjectOrm::ShelterOrm.map(&:destroy)
    Info::App.db.run('PRAGMA foreign_keys = ON')
  end
end
