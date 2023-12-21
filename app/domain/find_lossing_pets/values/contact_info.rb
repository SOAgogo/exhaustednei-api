# frozen_string_literal: true

# require 'dry-types'
# require 'dry-struct'
# # this is for calculating how much a member donate money to a shelter

# # for telephone number
# module Types
#   include Dry::Types.module

#   Phone = ConstrainedTypes::String.constrained(
#     format: /\A\d{8}\z/,
#     size: 8
#   )
#   Email = ConstrainedTypes::String.constrained(
#     format: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\z/
#   )
# end

# module PetAdoption
#   # user info
#   module Values
#     include Dry::Types.module
#     # class ContactInfo`
#     class ContactInfo < Dry::Struct
#       include Dry.Types
#       attribute :name, Strict.Optional
#       attribute :phone_number, Types::Phone
#       attribute :user_email, Types::Email
#     end
#   end
# end
