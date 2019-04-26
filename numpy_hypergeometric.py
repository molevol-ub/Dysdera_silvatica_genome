import sys
import scipy.stats as stats

#print
#print 'total number in population: ' + sys.argv[1]
#print 'total number with condition in population: ' + sys.argv[2]
#print 'number in subset: ' + sys.argv[3]
#print 'number with condition in subset: ' + sys.argv[4]

#print 'CDF <= ' + sys.argv[4] + ': ' + str(stats.hypergeom.cdf(int(sys.argv[4]) ,int(sys.argv[1]),int(sys.argv[2]), int(sys.argv[3]))) 
#print 'SF >= ' + sys.argv[4] + ': ' + str(stats.hypergeom.sf(int(sys.argv[4]) - 1,int(sys.argv[1]),int(sys.argv[2]),int(sys.argv[3])))

##
CDF = stats.hypergeom.cdf(int(sys.argv[4]) ,int(sys.argv[1]),int(sys.argv[2]), int(sys.argv[3]))
SF = stats.hypergeom.sf(int(sys.argv[4]) - 1,int(sys.argv[1]),int(sys.argv[2]),int(sys.argv[3]))
#name = sys.argv[5]


print sys.argv[5] + ',' + sys.argv[1] + ',' +  sys.argv[2] + ',' +  sys.argv[3] + ',' +  sys.argv[4] + ',' + str(CDF) + ',' +  str(SF)



''' 
https://www.biostars.org/p/66729/
The result will be
a p-value where by random chance number of genes with both condition A and B will be <= to your number with condition A and B
a p-value where by random chance number of genes with both condition A and B will be >= to your number with condition A and B

The second p-value is probably what you want.

'''
