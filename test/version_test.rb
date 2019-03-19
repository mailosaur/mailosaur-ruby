module Mailosaur
  class VersionTest < Test::Unit::TestCase
    should "return a VERSION that is in the v5 range" do
      assert_match('5', Mailosaur::VERSION)
    end
  end
end
