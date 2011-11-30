require 'translator'

class RootDistanceTranslator < Translator
  def distance(pos1, pos2)
    Math.sqrt(((pos2 - pos1).abs)+1).to_f
  end
end