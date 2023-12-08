print "original ZERO: $0"
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

print "normalized ZERO: $0"
print "plugin name: ${0:t:r}"
