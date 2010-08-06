# encoding: utf-8
require 'ffi'
class Hunspell  
  module C
    extend FFI::Library
    ffi_lib ['hunspell', 'libhunspell', 'hunspell-1.2', 'libhunspell-1.2']
    attach_function :Hunspell_create, [:string, :string], :pointer
    attach_function :Hunspell_spell, [:pointer, :string], :bool
    attach_function :Hunspell_suggest, [:pointer, :pointer, :string], :int
  end
  
  # TODO RDoc
  
  def initialize(affpath, dicpath)
    @handler = C.Hunspell_create(affpath, dicpath)
  end
  
  def spell(word)
    C.Hunspell_spell(@handler, word)
  end
  alias_method :check, :spell
  
  def suggest(word)
    ptr = FFI::MemoryPointer.new(:pointer, 1)    
    len = Hunspell::C.Hunspell_suggest(@handler, ptr, word)
    str_ptr = ptr.read_pointer
    str_ptr.null? ? [] : str_ptr.get_array_of_string(0, len).compact
  end  
end
