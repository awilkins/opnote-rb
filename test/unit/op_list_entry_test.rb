require File.dirname(__FILE__) + '/../test_helper'

class OpListEntryTest < Test::Unit::TestCase
  fixtures :op_list_entries

  # Replace this with your real tests.
  def test_truth
    assert_kind_of OpListEntry, op_list_entries(:first)
  end
end
