#
# Checking the formatting from strftime
#
# Work in progress
#
use v6.c;
use Test;
use Date::Calendar::Coptic;

my @tests = ((1735, 12,  1, 'zzz',       3, 'zzz')
           , (1735, 12,  1, '%Y-%m-%d', 10, '1735-12-01')
           , (1735, 12,  1, '%j',        3, '331')
           , (1735, 12,  1, '%Oj',       3, '331')
           , (1735, 12,  1, '%Ej',       3, '331')
           , (1735, 12,  1, '%EY',       4, '1735')
           , (1735, 12,  1, '%Ey',       3, '%Ey')
           , (1735, 13,  6, '%Y',        4, '1735')
           , (1735, 13,  6, '%G',        4, '1735')
           , (1735, 13,  6, '%V',        2, '53')
           , (1735, 13,  6, '%u',        1, '4')
           , (1736,  1,  1, '%Y',        4, '1736')
           , (1736,  1,  1, '%G',        4, '1735')
           , (1736,  1,  1, '%V',        2, '53')
           , (1736,  1,  1, '%u',        1, '5')
             );
plan 2 × @tests.elems;

for @tests -> $test {
  my ($y, $m, $d, $format, $length, $expected) = $test;
  my Date::Calendar::Coptic $d-cop .= new(year => $y, month => $m, day => $d);
  my $result = $d-cop.strftime($format);

  # Remembering RT ticket 100311 for the Perl 5 module DateTime::Calendar::FrenchRevolutionary
  # Even if the relations between UTF-8 and Perl6 are much simpler than between UTF-8 and Perl5
  # better safe than sorry
  is($result.chars, $length);
  is($result,       $expected);
}

done-testing;
