require 'translator'
require 'gene_data'
require 'shuffler'

class TransitionCounter
  include Shuffler
  include GeneData
  include Calculator
  
  attr_accessor :translator
  attr_accessor :trnas
  
  def count_transitions(trnas)
    transitions = 0
    trnas.each_with_index do |t, i|
      if trnas[i+1]
        transitions += 1 if trnas[i+1] != t
      end
    end
    transitions
  end
  
  def scrambled_trna_transitions_of(trna)
    count_transitions(scrambled_trnas_of(trna))
  end
  
  def scrambled_trna_transitions
    total = 0
    SYNONYMOUS_AMINO_ACIDS.each do |acid|
      total += scrambled_trna_transitions_of(acid)
    end
    total
  end
  
  def trna_transitions_of(trna)
    count_transitions(original_trnas_of(trna))
  end
  
  def trna_transitions
    total = 0
    SYNONYMOUS_AMINO_ACIDS.each do |acid|
      total += trna_transitions_of(acid)
    end
    total
  end
  
  def random_percentile(n=50)
    if @random_scores.nil?
      @random_scores = []
      n.times{|i| @random_scores << scrambled_trna_transitions}
    end
    basevalue = trna_transitions
    100*(@random_scores.select{|i| basevalue > i}.size)/(@random_scores.size)
  end
end