require 'translator'

class LogDistanceTranslator < Translator
  def distance(pos1, pos2)
    Math.log(((pos2 - pos1).abs)+1).to_f
  end
end