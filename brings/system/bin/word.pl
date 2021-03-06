#!/usr/bin/perl

if ($0 eq __FILE__) {
my $seed = srand(4233674228);
printf "seed: %s\n",$seed;
my $n = 25;
my $max = ~(~0<<$n) ;
my $quint = &u32quint($max);
my $lastw=&word($max);
my $lastw5=&word5($max);
my $lastwc=&wordc($max);
my $lwc0 = $lastwc; $lastwc =~ tr/aeiou//d;

my $buf = '';
$buf .= sprintf "max: %x # n=%d\n",$max,$n;
$buf .= sprintf "quint: %s # %dc\n",$quint,length($quint);
$buf .= sprintf "lastword: %s # %dc\n",$lastw,length($lastw);
$buf .= sprintf "lastword5: %s # %dc\n",$lastw5,length($lastw5);
$buf .= sprintf "lastwordc: %s # %s %dc\n",$lastwc,$lwc0,length($lastwc);
my $i = rand(1<<63);
my $w = &word($i);
my $w5 = &word5($i);
my $wc = &wordc($i);
my $wc0 = $wc; $wc =~ tr/aeiou//d;
$buf .= sprintf "w(%u): %s # %dc\n",$i,$w,length($w);
$buf .= sprintf "w5(%u): %s # %dc\n",$i,$w5,length($w5);
$buf .= sprintf "wc(%u): %s # %s %dc\n",$i,$wc,$wc0,length($wc);
$buf .= ".\n";
my $k = 26 * int rand(1<<32);
for (21 .. 29,$k) {
	my $w = &word($_);
	$buf .= sprintf "w(%u): %s # %dc\n",$_,$w,length($w);
}
print $buf;
exit $?;
}
# -----------------------------------------------------
# 5c => 22.74b = l(26^3 * 20^2)/l(2)
# 7c => 31b worth of data ... (similar density than hex)
sub word5 { # 20^4 * 26^3 words (4.5bit per letters)
 use integer;
 my $n = $_[0];
 my $vo = [qw ( a e i o u y )]; # 6
 my $cs = [qw ( b c d f g h j k l m n p q r s t v w x z )]; # 20
 my $a = ord($vo->[0]);
 my $odd = 0;
 my $str = '';
 while ($n > 0) {
   if ($odd) {
   my $c = $n % 20;
   #print "c: $c, n: $n\n";
      $n /= 20;
      $str .= $cs->[$c];
      $odd=0;
   } elsif(1) {
   my $c = $n % 26;
      $n /= 26;
      $str .= chr($a+$c);
      $odd=1;
   #} else {
   #my $c = $n % 6;
   #   $n /= 6;
   #   $str .= $vo->[$c];
   #   odd=undef;
   }
 }
 return $str;
}
# -----------------------------------------------------
sub word { # 20^4 * 6^3 words (25bit worth of data ... 3.4bit per letter)
 use integer;
 my $n = $_[0];
 my $vo = [qw ( a e i o u y )]; # 6
 my $cs = [qw ( b c d f g h j k l m n p q r s t v w x z )]; # 20
 my $str = '';
 if (1 && $n < 26) {
 $str = chr(ord('a') +$n%26);
 } else {
 $n -= 6;
 while ($n >= 20) {
   my $c = $n % 20;
      $n /= 20;
      $str .= $cs->[$c];
   #print "cs: $n -> $c -> $str\n";
   my $c = $n % 6;
      $n /= 6;
      $str .= $vo->[$c];
   #print "vo: $n -> $c -> $str\n";

 }
 if ($n > 0) {
   $str .= $cs->[$n];
 }
 return $str;
 }
}
# -----------------------------------------------------------------------
sub wordc { # 25b -> 6 syllables !
 use integer;
 my $n = $_[0];
 my $vo = [qw ( a e i o u y )]; # 6
 my $cs = [qw ( b c d f g h j k l m n p q r s t v w x z )]; # 20
 my $str = '';
 my $p = 0;
 while ($n >= 20) {
   my $c = $n % 20;
      $n /= 20;
      $str .= $cs->[$c] . $vo->[$p%6];
      $p++;
 }
 if ($n > 0) {
   $str .= $cs->[$n];
 }
 return $str;
}
# -----------------------------------------------------------------------
sub u32quint {
  my $u = shift;
  #printf "%04x.%04x\n",$u>>16,$u&0xFFFF;
  return u16toq(($u>>16) & 0xFFFF) . '-' . u16toq($u & 0xFFFF);
}
# -----------------------------------------------------------------------
sub u16toq {
   my $n = shift;
  #printf "u2q(%04x) =\n",$n;
   my $cons = [qw/ b d f g h j k l m n p r s t v z /]; # 16 consonants only -c -q -w -x
   my $vow = [qw/ a i o u  /]; # 4 wovels only -e -y
   my $s = '';
      for my $i ( 1 .. 5 ) { # 5 letter words
         if ($i & 1) { # consonant
            $s .= $cons->[$n & 0xF];
            $n >>= 4;
            #printf " %d : %s\n",$i,$s;
         } else { # vowel
            $s .= $vow->[$n & 0x3];
            $n >>= 2;
            #printf " %d : %s\n",$i,$s;
         }
      }
   #printf "%s.\n",$s;
   return scalar reverse $s;
}
# -----------------------------------------------------------------------
