# author: Simon Varlow
require 'aws-sdk'
require 'helper'
require 'aws_iam_user'

class AwsIamUserTest < Minitest::Test
  Username = 'test'.freeze

  def setup
    @mock_user_provider = Minitest::Mock.new
  end

  def test_mfa_enabled_returns_true_if_mfa_enabled
    @mock_user_provider.expect(
      :user,
      { has_mfa_enabled?: true },
      [Username],
    )
    assert AwsIamUser.new(Username, @mock_user_provider).has_mfa_enabled?
  end

  def test_mfa_enabled_returns_false_if_mfa_is_not_enabled
    @mock_user_provider.expect(
      :user,
      { has_mfa_enabled?: false },
      [Username],
    )
    assert !AwsIamUser.new(Username, @mock_user_provider).has_mfa_enabled?
  end

  def test_console_password_returns_true_if_console_password_has_been_set
    @mock_user_provider.expect(
      :user,
      { has_console_password?: true },
      [Username],
    )
    assert AwsIamUser.new(Username, @mock_user_provider).has_console_password?
  end

  def test_console_password_returns_false_if_console_password_has_not_been_set
    @mock_user_provider.expect(
      :user,
      { has_console_password?: false },
      [Username],
    )
    assert !AwsIamUser.new(Username, @mock_user_provider).has_console_password?
  end
end
