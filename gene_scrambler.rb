require 'translator'
require 'gene_data'
require 'shuffler'

class GeneScrambler
  include GeneData
  include Calculator
  include Shuffler
  
  attr_accessor :translator
  attr_accessor :trnas
  
  attr_accessor :random_scores
  

  def original_trnas_of(trna)
    translator.trnas.select{|i| i =~ Regexp.new("^" + trna, true)}.compact
  end
  
  def randomized_dica
    dica_for(shuffled_trnas)
  end
  

  

  
  def random_percentile(n=50)
    if @random_scores.nil?
      @random_scores = []
      n.times{|i| @random_scores << randomized_dica}
    end
    basevalue = translator.total_autocorrelation
    100*(@random_scores.select{|i| basevalue > i}.size)/(@random_scores.size)
  end


end