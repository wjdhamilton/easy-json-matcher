module ValidatorInterfaceTest

  def test_responds_to_valid
    assert_respond_to(@subject, :valid?)
  end
end
