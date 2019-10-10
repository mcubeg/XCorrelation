euclidean_distance(x,y) = sqrt( (x[1]-y[1])^2 + (x[2]-y[2])^2 + (x[3]-y[3])^2 )

function f_censoni(rmin, rmax, l)
  step = 0.0001
  Al2v = 16.58*(l^1.15)
  f = 0.
  s = rmin
  while s < rmax
    r2 = s^2
    f = f +( 2.4343 / Al2v^(1.5) )*exp( -(0.8555 * r2/Al2v)^1.6)*r2*step
    s = s + step
  end
  return -log2(f)
end

function censoni_information(pdbfile)

  pdb = JPleXL.readPDB(pdbfile)
  cas = JPleXL.xCA(pdb)

  # example use case, but should be changed
  # to receive confidence interval as input
  precision = 0.5

  nCA = size(cas)[1]
  information = zeros(nCA,nCA)

  for i in 1:nCA-1
    for j in i+1:nCA
      r = euclidean_distance(cas[i,:],cas[j,:])
      l = j-i
      information[i,j] = f_censoni( r-precision, r+precision, l)
      information[j,i] = information[i,j]
    end
  end

  return information

end

