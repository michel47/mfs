# installing perlmodules ...

if which core 1>/dev/null; then
core=$(core)
echo core: $core
else
 exit -$$
fi
rootdir=${HLR_HOME:-$HOME/.$core}

if test -e /etc/environment; then
   . /etc/environment
else
   export PATH=/usr/local/bin:/usr/bin:/bin; 
fi
export PATH="${rootdir}/bin:$PATH"
PERL5LIB=${PERL5LIB:-$HLR_HOME/perl5/lib/perl5}

# perl's local lib
eval $(perl -I$PERL5LIB -Mlocal::lib=${PERL5LIB%/lib/perl5})

perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(YAML::XS)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(YAML::Syck)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(MIME::Base32)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(Math::BigInt)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(Encode::Base58::BigInt)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(JSON)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(Crypt::Digest)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(LWP::UserAgent)'
perl -MCPAN -Mlocal::lib=${PERL5LIB%/lib/perl5} -e 'CPAN::install(LWP::Protocol::https)'

