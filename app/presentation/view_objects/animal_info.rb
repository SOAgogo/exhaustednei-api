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
        @animal_obj_list = to_decode_hash(animal_obj_list)
      end

      def self.merge(feature)
        sex = 'Female'
        sex = 'Male' if feature['sex'] == 'M'
        feature['color'] = URI.decode_www_form_component(feature['color'])
        feature['species'] = URI.decode_www_form_component(feature['species'])
        feature['sex'] = sex

        feature
      end

      def to_decode_hash(animal_obj_list)
        animal_obj_list.map do |obj|
          obj = ChineseWordsCanBeEncoded.merge(obj.feature)
          obj
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

    # View for animal promotions
    class AnimalPromotion
      attr_reader :prefer_animals

      def initialize(prefer_animals)
        @prefer_animals = animals_in_each_shelter(prefer_animals)
      end

      def animals_in_each_shelter(prefer_animals)
        shelter_hash = Hash.new { |hash, key| hash[key] = [] }
        prefer_animals.each do |shelter_animal, score|
          shelter_hash[shelter_animal[0]] = shelter_hash[shelter_animal[0]] << [shelter_animal[1], score]
        end
        view_feature(shelter_hash)
      end

      def view_feature(shelter_hash)
        shelter_hash.each do |key, value|
          features = value.map do |entity, score|
            entity.feature.merge('score' => score)
          end
          shelter_hash[key] = features
        end
      end
    end
  end
end
