module ValidatorInterfaceTest

  def test_responds_to_valid?
    assert_respond_to(@subject, :valid?)
  end

  def test_responds_to__validate
    assert_respond_to(@subject, :_validate)
  end

  def test_responds_to_get_errors
    assert_respond_to(@subject, :get_errors)
  end

end
