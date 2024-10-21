#
# Checking the checks at build time
#
use v6.c;
use Test;
use Date::Calendar::Coptic;
use Date::Calendar::Ethiopic;

my @lives = ((1735,  1,  1, "correct")
           , (1735,  1, 30, "correct")
           , (1735, 12,  1, "correct")
           , (1735, 12, 30, "correct")
           , (1735, 13,  6, "correct epagomene day on a leap year")
           , (1736, 13,  5, "correct epagomene day on a normal year")
             );
my @dies  = ((1735,  1,  0, "day out of range")
           , (1735,  1, 31, "day out of range")
           , (1735, 12,  0, "day out of range")
           , (1735, 12, 31, "day out of range")
           , (1735,  0,  1, "month out of range")
           , (1735, 14,  1, "month out of range")
           , (1735, 13,  0, "epagomene day out of range")
           , (1735, 13,  7, "epagomene day out of range on a leap year")
           , (1736, 13,  6, "epagomene day out of range on a normal year")
             );
plan 2 × (@lives.elems + @dies.elems);

my Date::Calendar::Coptic $d-cop;

for @lives -> $test {
  my ($y, $m, $d, $text) = $test;
  lives-ok( {$d-cop .= new(year => $y, month => $m, day => $d) }, $text);
}

for @dies -> $test {
  my ($y, $m, $d, $text) = $test;
  dies-ok( {$d-cop .= new(year => $y, month => $m, day => $d) }, $text);
}

my Date::Calendar::Ethiopic $d-eth;

for @lives -> $test {
  my ($y, $m, $d, $text) = $test;
  lives-ok( {$d-eth .= new(year => $y, month => $m, day => $d) }, $text);
}

for @dies -> $test {
  my ($y, $m, $d, $text) = $test;
  dies-ok( {$d-eth .= new(year => $y, month => $m, day => $d) }, $text);
}

done-testing;
