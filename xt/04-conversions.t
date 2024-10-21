#
# Checking the conversion between Gregorian on onehand and Coptic and Ethiopic on the other hand
#
use v6.c;
use Test;
use Date::Calendar::Coptic;
use Date::Calendar::Ethiopic;

# Test data taken from Perl5's Date::Converter (Andrew S)
# removing all negative years.
# Also adding some edge cases, that is, new year day and new year eve.
my @tests = ( (  470,  1,  8,  186,  5, 12,  462,  5, 12 ),
              (  576,  5, 20,  292,  9, 23,  568,  9, 23 ),
              (  694, 11, 10,  411,  3, 11,  687,  3, 11 ),
              ( 1013,  4, 25,  729,  8, 24, 1005,  8, 24 ),
              ( 1096,  5, 24,  812,  9, 23, 1088,  9, 23 ),
              ( 1190,  3, 23,  906,  7, 20, 1182,  7, 20 ),
              ( 1240,  3, 10,  956,  7,  7, 1232,  7,  7 ),
              ( 1288,  4,  2, 1004,  7, 30, 1280,  7, 30 ),
              ( 1298,  4, 27, 1014,  8, 25, 1290,  8, 25 ),
              ( 1391,  6, 12, 1107, 10, 10, 1383, 10, 10 ),
              ( 1436,  2,  3, 1152,  5, 29, 1428,  5, 29 ),
              ( 1492,  4,  9, 1208,  8,  5, 1484,  8,  5 ),
              ( 1553,  9, 19, 1270,  1, 12, 1546,  1, 12 ),
              ( 1560,  3,  5, 1276,  6, 29, 1552,  6, 29 ),
              ( 1648,  6, 10, 1364, 10,  6, 1640, 10,  6 ),
              ( 1680,  6, 30, 1396, 10, 26, 1672, 10, 26 ),
              ( 1716,  7, 24, 1432, 11, 19, 1708, 11, 19 ),
              ( 1768,  6, 19, 1484, 10, 14, 1760, 10, 14 ),
              ( 1819,  8,  2, 1535, 11, 27, 1811, 11, 27 ),
              ( 1839,  3, 27, 1555,  7, 19, 1831,  7, 19 ),
              ( 1903,  4, 19, 1619,  8, 11, 1895,  8, 11 ),
              ( 1929,  8, 25, 1645, 12, 19, 1921, 12, 19 ),
              ( 1941,  9, 29, 1658,  1, 19, 1934,  1, 19 ),
              ( 1943,  4, 19, 1659,  8, 11, 1935,  8, 11 ),
              ( 1943, 10,  7, 1660,  1, 26, 1936,  1, 26 ),
              ( 1992,  3, 17, 1708,  7,  8, 1984,  7,  8 ),
              ( 1996,  2, 25, 1712,  6, 17, 1988,  6, 17 ),
              ( 2015,  9,  5, 1731, 12, 30, 2007, 12, 30 ),
              ( 2015,  9,  6, 1731, 13,  1, 2007, 13,  1 ),
              ( 2015,  9, 11, 1731, 13,  6, 2007, 13,  6 ),
              ( 2015,  9, 12, 1732,  1,  1, 2008,  1,  1 ),
              ( 2016,  9,  5, 1732, 12, 30, 2008, 12, 30 ),
              ( 2016,  9,  6, 1732, 13,  1, 2008, 13,  1 ),
              ( 2016,  9, 10, 1732, 13,  5, 2008, 13,  5 ),
              ( 2016,  9, 11, 1733,  1,  1, 2009,  1,  1 ),
              ( 2017,  9,  5, 1733, 12, 30, 2009, 12, 30 ),
              ( 2017,  9,  6, 1733, 13,  1, 2009, 13,  1 ),
              ( 2017,  9, 10, 1733, 13,  5, 2009, 13,  5 ),
              ( 2017,  9, 11, 1734,  1,  1, 2010,  1,  1 ),
              ( 2018,  9,  5, 1734, 12, 30, 2010, 12, 30 ),
              ( 2018,  9,  6, 1734, 13,  1, 2010, 13,  1 ),
              ( 2018,  9, 10, 1734, 13,  5, 2010, 13,  5 ),
              ( 2018,  9, 11, 1735,  1,  1, 2011,  1,  1 ),
              ( 2019,  9,  5, 1735, 12, 30, 2011, 12, 30 ),
              ( 2019,  9,  6, 1735, 13,  1, 2011, 13,  1 ),
              ( 2019,  9, 11, 1735, 13,  6, 2011, 13,  6 ),
              ( 2019,  9, 12, 1736,  1,  1, 2012,  1,  1 ),
              ( 2038, 11, 10, 1755,  3,  1, 2031,  3,  1 ),
              ( 2094,  7, 18, 1810, 11, 11, 2086, 11, 11 ),
             );
plan 8 × @tests.elems;

for @tests -> $test {
  my ($yg, $mg, $dg, $yc, $mc, $dc, $ye, $me, $de) = $test;
  my Date::Calendar::Coptic $d-cop .= new(year => $yc, month => $mc, day => $dc);

  my $expected-gist = sprintf("%04d-%02d-%02d", $yg, $mg, $dg);
  is($d-cop.to-date.gist, $expected-gist);

  $expected-gist = sprintf("%04d-%02d-%02d", $ye, $me, $de);
  is($d-cop.to-date("Date::Calendar::Ethiopic").gist, $expected-gist);

  my Date::Calendar::Ethiopic $d-eth .= new-from-date($d-cop);
  is($d-eth.gist, $expected-gist);
}

for @tests -> $test {
  my ($yg, $mg, $dg, $yc, $mc, $dc, $ye, $me, $de) = $test;
  my Date::Calendar::Ethiopic $d-eth .= new(year => $ye, month => $me, day => $de);

  my $expected-gist = sprintf("%04d-%02d-%02d", $yg, $mg, $dg);
  is($d-eth.to-date.gist, $expected-gist);

  $expected-gist = sprintf("%04d-%02d-%02d", $yc, $mc, $dc);
  is($d-eth.to-date("Date::Calendar::Coptic").gist, $expected-gist);

  my Date::Calendar::Coptic $d-cop .= new-from-date($d-eth);
  is($d-cop.gist, $expected-gist);
}

for @tests -> $test {
  my ($yg, $mg, $dg, $yc, $mc, $dc, $ye, $me, $de) = $test;
  my Date $d-grg .= new($yg, $mg, $dg);

  my $expected-gist = sprintf("%04d-%02d-%02d", $yc, $mc, $dc);
  my Date::Calendar::Coptic $d-cop .= new-from-date($d-grg);
  is($d-cop.gist, $expected-gist);

  $expected-gist = sprintf("%04d-%02d-%02d", $ye, $me, $de);
  my Date::Calendar::Ethiopic $d-eth .= new-from-date($d-grg);
  is($d-eth.gist, $expected-gist);
}

done-testing;
