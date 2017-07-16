require File.dirname(__FILE__) + '/../test_helper'

class OpTemplateTest < Test::Unit::TestCase
  fixtures :op_templates

  # Replace this with your real tests.
  def test_truth
    assert_kind_of OpTemplate, op_templates(:first)
  end
end
