#

cat > t.txt <<EOF

# \$User: username\$
# \$Date: 1/1/1\$
# \$Tic: 123\$
# \$Qm: ~\$
EOF
cat > t.yml <<EOF
---
user: michelc
qm: QmPo4KhNKAmcdvfmuQMvsGo8iJjcEoAkuiRAtKo2FpQacY
tic: 1575726861
date: 12/07/19
...
EOF
pgm=$(ipms add -Q keywords.pl)
echo pgm: $pgm
ipms cat $pgm | perl /dev/stdin t.yml t.txt
qm=$(ipms add -Q -n t.txt)
if [ "$qm" != 'QmPpktbTKs414Nedp7kujK7fBoFGVPKZvp88hn7iCqCPxu' ]; then
  echo "status: $$ # Error (qm: $qm) !" 1>&2
  exit $$
else
  rm t.txt t.yml
  echo "status: 0"
  exit 0
fi
