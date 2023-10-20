require 'uri'
require "net/http"
require 'pry'
require 'json'
require 'yaml'
# verify your identification

module animal
    class Cat
        def animal_ID(animal_ID)
            @animal_ID = animal_ID
        end
        
        def animal_Place(animal_Place)
            @animal_Place = animal_Place
        end

        def animal_kind(animal_kind)
            @animal_kind = animal_kind
        end
        
        def animal_variate(animal_variate)
            @animal_variate = animal_variate
        end
        
        def animal_sex(animal_sex)
            @animal_sex = animal_sex
        end
        
        def animal_sterilization(animal_sterilization)
            @animal_sterilization = animal_sterilization
        end

        def animal_bacterin(animal_bacterin)
            @animal_bacterin = animal_bacterin
        end
        
        def animal_size(animal_size)
            @animal_size = animal_size
        end

        def album_file(album_file)
            @album_file = album_file
        end

        def animal_opendate(animal_opendate)
            @animal_opendate = animal_opendate
        end        
    end



    class Dog 
            
        def animal_ID(animal_ID)
            @animal_ID = animal_ID
        end
        
        def animal_Place(animal_Place)
            @animal_Place = animal_Place
        end

        def animal_kind(animal_kind)
            @animal_kind = animal_kind
        end
        
        def animal_variate(animal_variate)
            @animal_variate = animal_variate
        end
        
        def animal_sex(animal_sex)
            @animal_sex = animal_sex
        end
        
        def animal_sterilization(animal_sterilization)
            @animal_sterilization = animal_sterilization
        end

        def animal_bacterin(animal_bacterin)
            @animal_bacterin = animal_bacterin
        end
        
        def animal_size(animal_size)
            @animal_size = animal_size
        end

        def album_file(album_file)
            @album_file = album_file
        end

        def animal_opendate(animal_opendate)
            @animal_opendate = animal_opendate
        end        
    end



    def get_ID(pet)
        return pet.animal_ID
    end

    def get_animal_place(pet)
        return pet.animal_place
    end

    def get_kind(pet)
        return pet.animal_kind
    end

    def get_Variate(pet)
        return pet.animal_variate
    end
    def get_gender(pet)
        return pet.animal_sex
    end

    def get_size(pet)
        return pet.animal_size
    end

    def is_sterilized(pet)
        return pet.animal_sterilization
    end
    
    def is_bacterin(pet)
        return pet.animal_bacterin
    end

    def get_Variate(pet)
        return pet.animal_variate
    end
end