require 'helper'
require 'aws_iam_password_policy'
require 'aws-sdk'
require 'json'

class AwsIamPasswordPolicyTest < Minitest::Test
  def setup
    @mock_conn = Minitest::Mock.new
    @mock_resource = Minitest::Mock.new

    @mock_conn.expect :iam_resource, @mock_resource
  end

  def test_policy_exists_when_policy_exists
    @mock_resource.expect :account_password_policy, true

    assert_equal true, AwsIamPasswordPolicy.new(@mock_conn).exists?
  end

  def test_policy_does_not_exists_when_no_policy
    @mock_resource.expect :account_password_policy, nil do
      raise Aws::IAM::Errors::NoSuchEntity.new nil, nil
    end

    assert_equal false, AwsIamPasswordPolicy.new(@mock_conn).exists?
  end

  def test_throws_when_password_age_0
    policy_object = Minitest::Mock.new
    policy_object.expect :expire_passwords, false

    @mock_resource.expect :account_password_policy, policy_object

    e = assert_raises Exception do
      AwsIamPasswordPolicy.new(@mock_conn).max_password_age
    end

    assert_equal e.message, 'this policy does not expire passwords'
  end
end
