eps = [a1,a2,a3...]
deltas = []

eps.each_with_index do |ep, i|
  if i > 0
    deltas << (eps[i] - eps[i-1])
  end
end