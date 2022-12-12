x=`nodejs polygen.js cypher.grm`

mv "`readlink -f $1`" "`readlink -f $x`"

ln -s "`readlink -f $x`" "`readlink -f $1`"

