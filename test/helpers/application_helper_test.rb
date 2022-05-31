require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'provide title helper' do
    base_title = "Ruby on Rails Tutorial Sample App"
    assert_equal provide_title, "#{base_title}"
    assert_equal provide_title("Sample"), "Sample | #{base_title}"
  end
end