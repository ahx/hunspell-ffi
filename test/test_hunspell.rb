# encoding: utf-8
require "test/unit"
require File.expand_path(File.dirname(__FILE__)) + '/../lib/hunspell-ffi'
class TestHunspell < Test::Unit::TestCase  
  def setup
    @dict_dir = File.dirname(__FILE__)
    @dict = Hunspell.new("#{@dict_dir}/cakes.aff", "#{@dict_dir}/cakes.dic")
  end
  
  def test_basic_spelling
    assert @dict.spell("Baumkuchen") == true
    assert @dict.check("Baumkuchen") == true # check alias
    assert @dict.spell("Bomcuken") == false
    assert_equal ["Baumkuchen"], @dict.suggest("Baumgurken")
    assert_equal [], @dict.suggest("qwss43easd")
  end
end