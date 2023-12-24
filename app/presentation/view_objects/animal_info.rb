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
      def self.merge(feature)
        sex = 'Female'
        sex = 'Male' if feature['sex'] == 'M'
        feature['color'] = URI.decode_www_form_component(feature['color'])
        feature['species'] = URI.decode_www_form_component(feature['species'])
        feature['sex'] = sex
        # feature.merge(
        #   sex:,
        #   species: URI.decode_www_form_component(feature['species']),
        #   color: URI.decode_www_form_component(feature['color'])
        # )
        feature
      end

      def self.to_decode_hash(animal_obj_list)
        animal_obj_list.each do |key, obj|
          obj = ChineseWordsCanBeEncoded.merge(obj.feature)
          animal_obj_list[key] = obj
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
