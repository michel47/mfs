#

# usage:
#  cat mutables.yml | reduce.sh
pgm=${0##*/}
# dependencies:
release='QmQUBo1pderkz28hQKFwkZaNNp7JPKjJmfFoDdDT1MqUMb'
kwextract="/ipfs/$release/kwextract.pl" 
kwextract="/.brings/system/bin/kwextract.pl" 

file="$1"
hdrf=/tmp/${pgm}_hdr.yml
jfile=/tmp/${pgm}_jnl.log
mutable=$(ipfs cat $kwextract | perl /dev/stdin -k mutable $file)
echo mutable: $mutable
mutf=/tmp/${pgm}_mut.yml
pv=$(ipfs files stat --hash $mutable)
echo pv: $pv
ipfs get /ipfs/$pv -o $mutf
ipfs cat $kwextract | perl /dev/stdin -yml $mutf

exit;
# find out the parent mutables ...
parent=$(ipfs files read $kwextract | perl /dev/stdin -k peers $mutf)
if [ "x$parent" = 'x']; then
echo parent: $parent
else
peers=$(ipfs files read $kwextract | perl /dev/stdin -k peers $mutf)
echo peers: $peers
fi

echo -n '' > $jfile
ipfs files read $mutable | while read line ; do
  if echo $line | grep -q '^- '; then
  qm=$(echo $line | sed -e 's/^- //')
  eval $(ipfs cat $qm | eyml)
  if [ "x$block" != 'x' ]; then
    echo block: $block
    echo qm: $qm
    echo "tic: $tic ($qm)"
    echo "$tic - $qm # block $block" >> $jfile
  fi
  else 
    echo $line >> $hdrf
  fi
done

grep -v 'Previous:' $hdrf
echo "# \$Previous: $pv\$"
sort $jfile | uniq | sed -e 's/^[0-9]* //'
rm -f $jfile $hdrf


exit $?; # $Source: /my/shell/scripts/reduce.sh$
