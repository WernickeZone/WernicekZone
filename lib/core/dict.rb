module Dict
  require 'ffi/aspell'
  def Dict.isRight?(word)
    speller = FFI::Aspell::Speller.new('fr')
    if speller.correct?(word)
      return true
    else
      return false
    end
    speller.close
  end
end
