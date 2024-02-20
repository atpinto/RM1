## here we suppose that you have entered the following data 
## by hand using the Stata editor. The data has two columns xx and yy 
## where: xx^T=(10, 20, 25, 18, 43, 13, 50) 
## yy^T=(100, 130, 125, 98, 149, 89, 149)
use test_data.dta
## generate a column of ones (called cons)
gen cons =1 
## Create a matrix consisting of the column of 1's and xx and store this in a matrix called X
mkmat cons xx, matrix(X) 
## Create a matrix with one column containing the yy's  and call it Y 
mkmat yy, matrix(Y) 
## Create the matrix X’X (with the name XTX) 
matrix XTX = X’*X 
## Create the inverse of XTX and call it XTX 
matrix invXTX = inv(XTX)  
## compute the LSE anc call it b 
matrix b=invXTX*X’*Y
## list b
matrix list b
## Extract the diagonal of the squared matrix (here invXTX) and list it
matrix D=vecdiag(invXTX)
matrix list D
## more information on matrix expressions in Stata can be found here: 
## https://www.stata.com/manuals/u14.pdf
