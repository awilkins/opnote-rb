require File.dirname(__FILE__) + '/../test_helper'

class OpNoteTest < Test::Unit::TestCase
  fixtures :op_notes

  # Replace this with your real tests.
  def test_truth
    assert_kind_of OpNote, op_notes(:first)
  end
end
