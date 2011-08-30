# Load AWS::S3 configuration values
#
S3_CREDENTIALS = YAML::load(File.open("./config/s3_credentials.yml"))[Rails.env.to_s]

# Set the AWS::S3 configuration
#
AWS::S3::Base.establish_connection! S3_CREDENTIALS['connection']
