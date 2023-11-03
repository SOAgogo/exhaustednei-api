# frozen_string_literal: true

# Helper to clean database during test runs
module DatabaseHelper
  def self.wipe_database
    # Ignore foreign key constraints when wiping tables
    Info::App.db.run('PRAGMA foreign_keys = OFF')
    Info::Database::MemberOrm.map(&:destroy)
    Info::Database::ProjectOrm.map(&:destroy)
    Info::App.db.run('PRAGMA foreign_keys = ON')
  end
end
