require 'gene_scrambler'

class Array
  def shuffle
    sort
  end
end

describe GeneScrambler do
  before do
    @scrambler = GeneScrambler.new
    @translator = Translator.new
    @translator.sequence = "ATGGGTGGGGGTCGGAGGCGGTAA"
    @scrambler.translator = @translator
  end
  
  it 'should replace randomization' do
    #done to make sure the rest of the spec works - in practice, shuffle randomizes things
    [2,5,3,4,6].shuffle.should == [2,3,4,5,6]
  end
  
  it 'shuffles codons of the same type maintaining position' do
    @translator.trna_indices_for("G").should == [1,2,3]
    @translator.trnas.should == ["M", "G1", "G3", "G1", "R2", "R4", "R2", "#"]
    @scrambler.shuffled_trnas.should == ["M", "G1", "G1", "G3", "R2", "R2", "R4", "#"]
  end
  
  it 'grabs the positions of all trnas of a certain type' do
    @scrambler.original_trnas_of("G").should == ["G1", "G3", "G1"]
    @scrambler.original_trnas_of("R").should == ["R2", "R4", "R2"]
    @scrambler.original_trnas_of("V").should == []
  end
  
  it 'shuffles a specific trna as necessary' do
    @scrambler.scrambled_trnas_of("G").should == ["G1", "G1", "G3"]
    @scrambler.scrambled_trnas_of("R").should == ["R2", "R2", "R4"]
    @scrambler.scrambled_trnas_of("V").should == []
  end
  
  it 'calculates the trnas of a shuffled translator as necessary' do
    @scrambler.randomized_dica.to_f.should == Rational(-1,4).to_f #contribution of each is -1/4
    #@t2 = @scrambler.shuffled_translator
    #@t2.trnas.should == ["M", "G1", "G1", "G3", "R2", "R2", "R4", "#"]
  end
  
  
  
end