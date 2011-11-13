require 'translator'

describe Translator do
  before do
    @translator = Translator.new
  end
  it 'does something' do
    @translator.sequence = "ATGAAAAAAAAAAAAAAATAA"
    @translator.to_protein.should == "MKKKKK"
  end
  
  it 'stores the tRNA information' do
      @translator.sequence = "ATGAAAAAAAAAAAAAAATAA"
      @translator.trnas.should == ['M', 'K1', 'K1', 'K1', 'K1', 'K1', '#']
  end
  
  it 'grabs all tRNAs of a specific type' do
    @translator.sequence = "ATGAAAAAAAAAAAAAAATAA"
    @translator.trna_indices_for("K").should == [1,2,3,4,5]
  end
  
  it 'autocorrelates the uniform case correctly' do
    @translator.sequence = "ATGAAAAAAAAAAAAAAATAA"
    @translator.autocorrelation_score_for("K").should == 1
  end
  
  it 'autocorrelates the maximum case correctly' do
    @translator.sequence = "ATGAAAAAAAAATAA"
    @translator.max_autocorrelation_score_for("K").to_f.should == Rational(4,3).to_f #1/2 + 1/2 + 1/3
  end
  
  it 'autocorrelates mixed cases correctly' do
    @translator.sequence = "ATGCCCCCCCCGTAA"
    @translator.autocorrelation_score_for("P").to_f.should == Rational(-1,4).to_f #1/2 - 1/2 - 1/3 / 1/2 + 1/2 + 1/3 = (-1/3)/(4/3)
  end
  
  it 'can find how often a given amino acid occurs' do
    @translator.sequence = "ATGAAAAAAAAACGGAGGTAA"
    @translator.codons_for("M").should == 1
    @translator.codons_for("K").should == 3
    @translator.codons_for("R").should == 2
  end
  
  it 'calculates a total correlation score' do
    @translator.sequence = "ATGGGTGGTGGTCGGAGGTAA"
    @translator.total_autocorrelation.to_f.should == Rational(1,5).to_f #3/5 from complete auto, -2/5 from other
    
  end
end