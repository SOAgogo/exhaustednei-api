require 'uri'
require "net/http"
require 'pry'
require 'json'
require 'yaml'
# verify your identification

module shelter
    class Cat
        def initialize()
        end
    end
    class Dog 
        def initialize()
        end
    end

    
    class Shelter
        def Name(name)
            @name = name
        end
        
        def Shelter_pkid(Shelter_pkid)
            @Shelter_pkid = Shelter_pkid
        end

        def Shelter_telephone_number(Shelter_telephone_number)
            @Shelter_telephone_number = Shelter_telephone_number
        end
        
        def array_animal_ID(animal_ID)
            #temp
        end
        
        def Shelter_name(Shelter_name)
            @Shelter_name = Shelter_name
        end
        
        def Shelter_Tel(Shelter_Tel)
            @Shelter_Tel = Shelter_Tel
        end

        def Shelter_address(Shelter_address)
            @Shelter_address = Shelter_address
        end

    def get_shelter_name(shelter)
        shelter.Shelter_name
    end


    def query_all_animalid()
        #temp
    end

    def get_phone_number(shelter)
        return shelter.Shelter_telephone_number
    end

    def get_kind(pet)
        return pet.animal_kind
    end

    def how_many_animals_in_shelter(pet)
        #temp
    end

    def how_many_cats_in_shelter(pet)
        #temp
    end

    def how_many_dogs_in_shelter(pet)
        #temp
    end
end


