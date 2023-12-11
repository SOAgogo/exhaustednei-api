# frozen_string_literal: true

require_relative 'accounts'
require_relative '../values/animal_order'
require_relative '../../shelter_animals/entities/animals'
module PetAdoption
  module Entity
    # class Info::adotpers`
    class Adopters
      def initialize
        @animal_favorite_list = {} # 收藏名單
        @confirm_order = PetAdoption::Value::AnimalOrder.new
      end

      # user preference is like hair=red, age=young
      def user_preference_setting(user_preference)
        @user_preference = user_preference
      end

      def promote_animal; end

      def delete_order_item(origin_id)
        @confirm_order.delete(origin_id)
      end

      def add_order_item(animal)
        @confirm_order.add_animal(animal)
      end
    end
  end
end
