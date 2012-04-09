# encoding: utf-8
require 'ffi'
class Hunspell  
  module C
    extend FFI::Library
    ffi_lib ['libhunspell', 'libhunspell-1.2', 'libhunspell-1.2.so.0']
    attach_function :Hunspell_create, [:string, :string], :pointer
    attach_function :Hunspell_spell, [:pointer, :string], :bool
    attach_function :Hunspell_suggest, [:pointer, :pointer, :string], :int
    attach_function :Hunspell_add, [:pointer, :string], :int
    attach_function :Hunspell_add_with_affix, [:pointer, :string, :string], :int
    attach_function :Hunspell_analyze, [:pointer, :pointer, :string], :int
    attach_function :Hunspell_free_list, [:pointer, :pointer, :int], :void
    attach_function :Hunspell_remove, [:pointer, :string], :int    
    attach_function :Hunspell_stem, [:pointer, :pointer, :string], :int
  end
  
  def initialize(affpath, dicpath)
    warn("Hunspell could not find aff-file #{affpath}") unless File.exist?(affpath)
    warn("Hunspell could not find dic-file #{affpath}") unless File.exist?(dicpath)
    @handler = C.Hunspell_create(affpath, dicpath)
  end
  
  # Returns true for a known word or false.
  def spell(word)
    C.Hunspell_spell(@handler, word)
  end
  alias_method :check, :spell
  alias_method :check?, :check  
  
  # Returns an array with suggested words or returns and empty array.
  def suggest(word)
    list_pointer = FFI::MemoryPointer.new(:pointer, 1)

    len = C.Hunspell_suggest(@handler, list_pointer, word)

    read_list(list_pointer, len)
  end
  
  # Add word to the run-time dictionary
  def add(word)
    C.Hunspell_add(@handler, word)
  end
  
  # Add word to the run-time dictionary with affix flags of
  # the example (a dictionary word): Hunspell will recognize
  # affixed forms of the new word, too.
  def add_with_affix(word, example)
    C.Hunspell_add_with_affix(@handler, word, example)
  end

  # Performs morphological analysis of +word+.  See hunspell(4) for details on
  # the output format.
  def analyze(word)
    list_pointer = FFI::MemoryPointer.new(:pointer, 1)

    len = C.Hunspell_analyze(@handler, list_pointer, word)

    read_list(list_pointer, len)
  end

  def read_list(list_pointer, len)
    return [] if len.zero?

    list = list_pointer.read_pointer

    strings = list.get_array_of_string(0, len)

    C.Hunspell_free_list(@handler, list_pointer, len)

    strings
  end

  # Remove word from the run-time dictionary
  def remove(word)
    C.Hunspell_remove(@handler, word)
  end

  # Returns the stems of +word+
  def stem(word)
    list_pointer = FFI::MemoryPointer.new(:pointer, 1)

    len = C.Hunspell_stem(@handler, list_pointer, word)

    read_list(list_pointer, len)
  end

end
