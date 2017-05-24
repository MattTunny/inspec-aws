# author: Alex Bedley
# author: Steffanie Freeman
# author: Simon Varlow
# author: Chris Redekop

class AwsIamUser < Inspec.resource(1)
  name 'aws_iam_user'
  desc 'Verifies settings for AWS IAM user'
  example "
    describe aws_iam_user('test_user_name') do
      its('has_mfa_enabled?') { should be false }
      its('has_console_password?') { should be true }
    end
  "
  def initialize(name, aws_user_provider = AwsIam::UserProvider.new)
    @name = name
    @user = aws_user_provider.user(name)
  end

  def has_mfa_enabled?
    @user[:has_mfa_enabled?]
  end

  def has_console_password?
    @user[:has_console_password?]
  end

  def access_keys
    @user[:access_keys].map { |elm|
      AwsIamAccessKey.new({ access_key: elm })
    }
  end
end
