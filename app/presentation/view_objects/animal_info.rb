# frozen_string_literal: true

module PetAdoption
  module Views
    # View for a single contributor
    class Picture
      def initialize(animal_pic)
        @animal_picture = animal_pic
      end

      def cover
        @animal_picture
      end
    end

    # View for an animal object
    class ChineseWordsCanBeEncoded
      attr_reader :animal_obj_list

      def initialize(animal_obj_list)
        @animal_obj_list = animal_obj_list
      end

      def self.merge(obj)
        obj.to_decode_hash.merge(
          animal_kind: URI.decode_www_form_component(obj.animal_kind),
          animal_variate: URI.decode_www_form_component(obj.animal_variate),
          animal_place: URI.decode_www_form_component(obj.animal_place),
          animal_found_place: URI.decode_www_form_component(obj.animal_found_place),
          animal_age: URI.decode_www_form_component(obj.animal_age),
          animal_color: URI.decode_www_form_component(obj.animal_color)
        )
        obj
      end

      def to_decode_hash
        @animal_obj_list.each do |key, obj|
          obj = ChineseWordsCanBeEncoded.merge(obj)
          @animal_obj_list[key] = obj
        end
      end
    end

    # View for a recognition object
    class ImageRecognition
      def initialize(image)
        @image = image
      end

      attr_reader :image
    end
  end
end
