require 'open3'
require 'aws-sdk-s3'
require 'yaml'

module PetAdoption
  module Storage
    # class Info::Project`
    BASE_URL = 'https://soapicture.s3.ap-northeast-2.amazonaws.com' # rubocop:disable Style/MutableConstant
    BUCKET_NAME = 'soapicture'.freeze
    # class S3
    class S3
      def self.s3_client
        Aws::S3::Client.new(region: 'ap-northeast-2')
      end

      def self.S3_init
        secrets = YAML.load_file('config/secrets.yml')
        # Access the keys
        access_key_id = secrets['access_key_id']
        secret_key_id = secrets['secret_key_id']

        Aws.config.update(
          region: 'ap-northeast-2',
          credentials: Aws::Credentials.new(access_key_id, secret_key_id)
        )

        s3 = s3_client
        response = download_image_from_s3(s3)

        # Iterate through each object and make it public
        response.contents.each do |object|
          object_key = object.key

          # Set the ACL of the object to public-read
          s3.put_object_acl(
            bucket: BUCKET_NAME,
            key: object_key,
            acl: 'public-read'
          )
        end
        s3
      end

      def self.download_image_from_s3(aws_s3)
        aws_s3.list_objects_v2(bucket: BUCKET_NAME, prefix: 'uploads/tmp/')
      end

      def self.upload_image_to_s3(uploaded_file)
        # Load the YAML file

        object_key = "uploads#{uploaded_file}"

        s3 = Aws::S3::Resource.new
        s3.bucket(BUCKET_NAME).object(object_key).upload_file(uploaded_file,
                                                              content_type: 'image/png;image/jpg;image/jpeg')

        "File uploaded successfully to #{BUCKET_NAME}/#{object_key}"
      end
    end
  end
end
