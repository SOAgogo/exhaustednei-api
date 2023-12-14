# frozen_string_literal: true

module PetAdoption
  module Request
    # Application value for the path of a requested project
    class ProjectPath
      def initialize(shelter_name, animal_kind, request)
        ak_ch = animal_kind == 'dog' ? '狗' : '貓'
        shelter_name = URI.decode_www_form_component(shelter_name)
        animal_kind = URI.decode_www_form_component(ak_ch)
        
        @shelter_name = shelter_name
        @animal_kind = animal_kind
        @request = request
        @path = request.remaining_path
      end

      attr_reader :shelter_name, :animal_kind

      def folder_name
        @folder_name ||= @path.empty? ? '' : @path[1..]
      end

      def project_fullname
        @request.captures.join '/'
      end
    end
  end
end
