# frozen_string_literal: true

module Repository
  module Info
    # Repository for Members
    class Animals
      def self.find_id(id)
        rebuild_entity(Database::MemberOrm.first(id:))
      end

      def self.find_username(username)
        rebuild_entity(Database::MemberOrm.first(username:))
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Animal.new(
          id: db_record.id,
          animal_id: db_record.animal_id,
          animal_kind: db_record.animal_kind,
          animal_variate: db_record.animal_variate,
          animal_sex: db_record.animal_sex,
          animal_sterilization: db_record.animal_sterilization,
          animal_bacterin: db_record.animal_bacterin,
          animal_bodytype: db_record.animal_bodytype,
          album_file: db_record.album_file,
          animal_place: db_record.animal_place,
          animal_opendate: db_record.animal_opendate
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_member|
          Members.rebuild_entity(db_member)
        end
      end

      # create an entry for each contributor
      def self.db_find_or_create(entity)
        # #<CodePraise::Entity::Member id=nil origin_id=1926704 username="soumyaray" email=nil>
        # to hash {:origin_id=>1926704, :username=>"soumyaray", :email=>nil}
        Database::MemberOrm.find_or_create(entity.to_attr_hash)
      end
    end
  end
end
