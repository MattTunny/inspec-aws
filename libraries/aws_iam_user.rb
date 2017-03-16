# author: Alex Bedley
# author: Steffanie Freeman
# author: Simon Varlow
class AwsIamUser < Inspec.resource(1)
  name 'aws_iam_user'
  desc 'Verifies settings for AWS IAM user'
  example "
    describe aws_iam_user('test_user_name') do
      its('has_mfa_enabled?') { should be false }
      its('has_console_password?') { should be true }
    end
  "
  def initialize(name, conn = AWSConnection.new)
    @name = name
    @iam_resource = conn.iam_resource
    @user = @iam_resource.user(@name)
  end

  def has_mfa_enabled?
    !@user.mfa_devices.first.nil?
  end

  def has_console_password?
    return !@user.login_profile.create_date.nil?
  rescue Aws::IAM::Errors::NoSuchEntity
    return false
  end

  def console_password
    return ConsolePassword.new
  end

  def seconds_since_last_console_password_use
    return 10
  end
end

class ConsolePassword
  def initialize()
    @seconds_since_last_use = 10
  end

  def seconds_since_last_use
    @seconds_since_last_use
  end
end