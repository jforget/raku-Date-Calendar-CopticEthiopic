# 
# Checking the week-based representations of Coptif and Ethiopic dates
#
use v6.c;
use Test;
use Date::Calendar::Coptic;
use Date::Calendar::Ethiopic;

my @tests-cop = ( 
                  ( 1733, 13,  4,  '1733-W52-7'), # Sat 2017-09-09, Psabbaton 4 Pi Kogi Enavot
                  ( 1733, 13,  5,  '1734-W01-1'), # Sun 2017-09-10, Thyriake 5 Pi Kogi Enavot
                  ( 1734,  1,  1,  '1734-W01-2'), # Mon 2017-09-11, Pesnau 1 Thout
                  ( 1734, 13,  5,  '1735-W01-2'), # Mon 2018-09-10, Pesnau 5 Pi Kogi Enavot
                  ( 1735,  1,  1,  '1735-W01-3'), # Tue 2018-09-11, Pshoment 1 Thout
                  ( 1735, 13,  6,  '1735-W53-4'), # Wed 2019-09-11, Peftoou 6 Pi Kogi Enavot
                  ( 1736,  1,  1,  '1735-W53-5'), # Thu 2019-09-12, Ptiou 1 Thout
                  ( 1736,  1,  3,  '1735-W53-7'), # Sat 2019-09-14, Psabbaton 3 Thout
                  ( 1736,  1,  4,  '1736-W01-1'), # Sun 2019-09-15, Thyriake 4 Thout
                  ( 1736, 13,  4,  '1736-W52-4'), # Wed 2020-09-10, Peftoou 4 Pi Kogi Enavot
                  ( 1736, 13,  5,  '1736-W52-5'), # Thu 2020-09-10, Ptiou 5 Pi Kogi Enavot
                  ( 1737,  1,  1,  '1736-W52-6'), # Fri 2020-09-11, Psoou 1 Thout
                  ( 1737,  1,  2,  '1736-W52-7'), # Sat 2020-09-11, Psabbaton 2 Thout
             );

my @tests-eth = ( 
                  ( 2009, 13,  4,  '2009-W52-7'), # Sat 2017-09-09, Ehud 4 Pagume
                  ( 2009, 13,  5,  '2010-W01-1'), # Sun 2017-09-10, Segno 5 Pagume
                  ( 2010,  1,  1,  '2010-W01-2'), # Mon 2017-09-11, Maksegno 1 Mäskäräm
                  ( 2010, 13,  5,  '2011-W01-2'), # Mon 2018-09-10, Maksegno 5 Pagume
                  ( 2011,  1,  1,  '2011-W01-3'), # Tue 2018-09-11, Rob 1 Mäskäräm
                  ( 2011, 13,  6,  '2011-W53-4'), # Wed 2019-09-11, Hamus 6 Pagume
                  ( 2012,  1,  1,  '2011-W53-5'), # Thu 2019-09-12, Arb 1 Mäskäräm
                  ( 2012,  1,  3,  '2011-W53-7'), # Sat 2019-09-14, Ehud 3 Mäskäräm
                  ( 2012,  1,  4,  '2012-W01-1'), # Sun 2019-09-15, Segno 4 Mäskäräm
                  ( 2012, 13,  4,  '2012-W52-4'), # Wed 2020-09-10, Hamus 4 Pagume
                  ( 2012, 13,  5,  '2012-W52-5'), # Thu 2020-09-10, Arb 5 Pagume
                  ( 2013,  1,  1,  '2012-W52-6'), # Fri 2020-09-11, Qedame 1 Mäskäräm
                  ( 2013,  1,  2,  '2012-W52-7'), # Sat 2020-09-11, Ehud 2 Mäskäräm
             );

plan @tests-cop.elems + @tests-eth.elems;

for @tests-cop -> $test {
  my ($yc, $mc, $dc, $expected-string) = $test;
  my Date::Calendar::Coptic $d-cop .= new(year => $yc, month => $mc, day => $dc);

  my $actual-string = sprintf("%04d-W%02d-%d", $d-cop.week-year, $d-cop.week-number, $d-cop.day-of-week);
  is($actual-string, $expected-string);

}


for @tests-eth -> $test {
  my ($ye, $me, $de, $expected-string) = $test;
  my Date::Calendar::Ethiopic $d-eth .= new(year => $ye, month => $me, day => $de);

  my $actual-string = sprintf("%04d-W%02d-%d", $d-eth.week-year, $d-eth.week-number, $d-eth.day-of-week);
  is($actual-string, $expected-string);

}

