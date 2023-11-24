# frozen_string_literal: true

module PetAdoption
  module RouteHelpers
    # Application value for the path of a requested project
    class ControllerRequestPath
      def initialize(cookie)
        @cookie = cookie
      end

      attr_reader :owner_name, :project_name

      def folder_name
        @folder_name ||= @path.empty? ? '' : @path[1..]
      end

      def project_fullname
        @request.captures.join '/'
      end
    end
  end
end
