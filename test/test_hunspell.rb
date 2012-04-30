# encoding: utf-8
require "test/unit"
require File.expand_path(File.dirname(__FILE__)) + '/../lib/hunspell-ffi'
class TestHunspell < Test::Unit::TestCase  
  def setup
    @dict_dir = File.dirname(__FILE__)
    @dict = Hunspell.new(@dict_dir, "en_US")
  end

  def test_initialize
    assert_equal File.join(@dict_dir, "en_US.aff"), @dict.affix
    assert_equal File.join(@dict_dir, "en_US.dic"), @dict.dictionary
  end
  
  def test_initialize_legacy
    h = Hunspell.new("#{@dict_dir}/en_US.aff", "#{@dict_dir}/en_US.dic")

    assert_equal File.join(@dict_dir, "en_US.aff"), h.affix
    assert_equal File.join(@dict_dir, "en_US.dic"), h.dictionary
  end
  
  def test_initialize_missing
    e = assert_raises ArgumentError do
      Hunspell.new(@dict_dir, "en_CA")
    end

    dict = File.join(@dict_dir, "en_CA.aff")
    assert_equal "Hunspell could not find affix file #{dict}", e.message
  end

  def test_analyze
    assert_equal [" st:hello"], @dict.analyze("hello")
  end
  
  def test_basic_spelling
    assert @dict.spell("worked")
    assert @dict.check("worked") # check alias
    assert !@dict.spell("working")

    assert_equal ["worked", "work"], @dict.suggest("woked")
    assert_equal [], @dict.suggest("qwss43easd")
  end
  
  def test_dict_modifications
    assert @dict.spell("Neuer Kuchen") == false
    @dict.add("Neuer Kuchen")
    assert @dict.spell("Neuer Kuchen") == true
    @dict.remove("Neuer Kuchen")
    assert @dict.spell("Neuer Kuchen") == false
    # TODO test add_with_affix
  end    

  def test_find_langauge_none
    orig_LC_ALL      = ENV["LC_ALL"]
    orig_LC_MESSAGES = ENV["LC_ALL"]
    orig_LANG        = ENV["LANG"]

    ENV.delete "LC_ALL"
    ENV.delete "LC_MESSAGES"
    ENV.delete "LANG"

    assert_nil @dict.find_language
  ensure
    ENV["LC_ALL"]      = orig_LC_ALL
    ENV["LC_MESSAGES"] = orig_LC_MESSAGES
    ENV["LANG"]        = orig_LANG
  end

  def test_find_langauge_LANG
    orig_LC_ALL      = ENV["LC_ALL"]
    orig_LC_MESSAGES = ENV["LC_ALL"]
    orig_LANG        = ENV["LANG"]

    ENV.delete "LC_ALL"
    ENV.delete "LC_MESSAGES"
    ENV["LANG"] = "en_CA.UTF-8"

    assert_equal "en_CA", @dict.find_language
  ensure
    ENV["LC_ALL"]      = orig_LC_ALL
    ENV["LC_MESSAGES"] = orig_LC_MESSAGES
    ENV["LANG"]        = orig_LANG
  end

  def test_find_langauge_LC_ALL
    orig_LC_ALL = ENV["LC_ALL"]
    ENV["LC_ALL"] = "en_CA.UTF-8"

    assert_equal "en_CA", @dict.find_language
  ensure
    ENV["LC_ALL"] = orig_LC_ALL
  end

  def test_find_langauge_LC_MESSAGES
    orig_LC_ALL      = ENV["LC_ALL"]
    orig_LC_MESSAGES = ENV["LC_ALL"]
    ENV.delete "LC_ALL"
    ENV["LC_MESSAGES"] = "en_CA.UTF-8"

    assert_equal "en_CA", @dict.find_language
  ensure
    ENV["LC_ALL"]      = orig_LC_ALL
    ENV["LC_MESSAGES"] = orig_LC_MESSAGES
  end

  def test_stem
    assert_equal %w[hello], @dict.stem("hello")
  end

  def test_suggest
    suggestions = @dict.suggest "HOWTOs"

    assert_equal %w[Hots’s], suggestions
  end
end
