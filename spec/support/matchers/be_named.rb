RSpec::Matchers.define :be_named do |expected|
  match do |actual|
    # not work
    # actual.name eq expected

    # should be
    actual.name == expected
  end
  description do
    "return a full name as a string"
  end
end