#

qm=$(ipms add -r -Q .)
if ipms files stat --hash /.brings/bootstrap/perl5 2>/dev/null; then
 ipms files rm -r /.brings/bootstrap/perl5
else
  ipms files mkdir -p /.brings/bootstrap
fi
ipms files cp /ipfs/$qm /.brings/bootstrap/perl5
ipms files stat /.brings/bootstrap/perl5
exit $?



