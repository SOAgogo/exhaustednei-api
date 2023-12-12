require 'roar/decorator'
require 'roar/json'
module PetAdoption
    module Representer
    # Represents Member information for API output
        class shelter < Roar::Decorator
            include Roar::JSON
            property :origin_id
            property :username
            property :email
        end
    end
end