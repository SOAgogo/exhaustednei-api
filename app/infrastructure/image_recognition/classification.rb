# frozen_string_literal: true

# classification.rb
require 'pry'
require 'open3'
require 'aws-sdk-s3'

module PetAdoption
  module ImageRecognition
    # class Info::Project`
    class S3

      def self.S3_init
        s3_bucket_name  = 'soapicture'

        secrets = YAML.load_file('config/secrets.yml')
          # Access the keys
        access_key_id = secrets['access_key_id']
        secret_key_id = secrets['secret_key_id']

        Aws.config.update(
          region: 'ap-northeast-2',
          credentials: Aws::Credentials.new(access_key_id, secret_key_id)
        )        
        
        s3 = Aws::S3::Client.new(region: 'ap-northeast-2')

        response = s3.list_objects_v2(bucket: s3_bucket_name , prefix: 'uploads/tmp/')
    
        # Iterate through each object and make it public
        response.contents.each do |object|
          object_key = object.key
      
          # Set the ACL of the object to public-read
          s3.put_object_acl(
            bucket: s3_bucket_name ,
            key: object_key,
            acl: 'public-read'
          )
        end
      end
      def self.upload_image_to_s3(uploaded_file)
          # Load the YAML file
        s3_bucket_name  = 'soapicture'


        object_key = "uploads#{uploaded_file}"
            

        s3 = Aws::S3::Resource.new
        s3.bucket(s3_bucket_name ).object(object_key).upload_file(uploaded_file, content_type: 'image/png;image/jpg')

        "File uploaded successfully to #{s3_bucket_name }/#{object_key}"
      end
    end


    class Classification
      def initialize(uploaded_file)
        @script_path = 'app/infrastructure/image_recognition/classification.py'
        @uploaded_file = uploaded_file
      end

      def run
        Classification.run_classification(@script_path, @uploaded_file)
      end

      def self.run_classification(script_path, uploaded_file)
        output, status = Open3.capture2("python3 #{script_path} #{uploaded_file}")
        [output, status]
      end
    end
  end
end
