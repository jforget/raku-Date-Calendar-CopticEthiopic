# -*- encoding: utf-8; indent-tabs-mode: nil -*-
use v6.d;

use Date::Calendar::Strftime;
use Date::Calendar::CopticEthiopic;
use Date::Calendar::Coptic::Names;

unit class Date::Calendar::Coptic:ver<0.1.1>:auth<zef:jforget>:api<1>
      does Date::Calendar::CopticEthiopic
      does Date::Calendar::Strftime;

method BUILD(Int:D :$year, Int:D :$month, Int:D :$day, Int :$daypart = daylight()) {
  $._chek-build-args($year, $month, $day);
  $._build-from-args($year, $month, $day, $daypart);
}

method mjd-bias {
  -575337;
}

method month-name {
  Date::Calendar::Coptic::Names::month-name($.month);
}

method month-abbr {
  Date::Calendar::Coptic::Names::month-abbr($.month);
}

method day-name {
  Date::Calendar::Coptic::Names::day-name($.day-of-week);
}

method day-abbr {
  Date::Calendar::Coptic::Names::day-abbr($.day-of-week);
}

=begin pod

=head1 NAME

Date::Calendar::Coptic - conversions from / to the Coptic calendar

=head1 SYNOPSIS

Converting a Gregorian date to Coptic

=begin code :lang<raku>

use Date::Calendar::Coptic;

my Date                     $Perlcon-Riga-grg;
my Date::Calendar::Coptic   $Perlcon-Riga-cop;

$Perlcon-Riga-grg .= new(2019, 8, 7);
$Perlcon-Riga-cop .= new-from-date($Perlcon-Riga-grg);

say $Perlcon-Riga-cop.strftime("%A %e %B %Y");
#--> Peftoou 1 Mesori 1735

=end code

Converting a Coptic date to Gregorian

=begin code :lang<raku>

use Date::Calendar::Coptic;

my Date::Calendar::Coptic   $TPC-Pittsburgh-cop;
my Date                     $TPC-Pittsburgh-grg;

$TPC-Pittsburgh-cop .= new(year => 1735, month => 10, day => 9);
$TPC-Pittsburgh-grg  = $TPC-Pittsburgh-cop.to-date;
say $TPC-Pittsburgh-cop.strftime("%e %B %Y = "), $TPC-Pittsburgh-grg.gist
#--> 9 Paoni 1735 = 2019-06-16

=end code

Converting a date while caring about sunset:

=begin code :lang<raku>

use Date::Calendar::Strftime;
use Date::Calendar::Coptic;

my Date::Calendar::Coptic $dt-coptic;
my Date                   $dt-greg;

$dt-coptic .= new(year => 1741, month => 3, day => 5, daypart => after-sunset());
$dt-greg    = $dt-coptic.to-date;
say $dt-greg.gist;   # --> 2024-11-13

# on the other hand
$dt-coptic .= new(year => 1741, month => 3, day => 5, daypart => before-sunrise());
$dt-greg    = $dt-coptic.to-date;
say $dt-greg.gist;   # --> 2024-11-14

$dt-coptic .= new(year => 1741, month => 3, day => 5, daypart => daylight());
$dt-greg    = $dt-coptic.to-date;
say $dt-greg.gist;   # --> 2024-11-14

=end code

=head1 DESCRIPTION

Date::Calendar::Coptic is  a class  implementing the  Coptic calendar.
This  calendar derives  from  the ancient  Egyptian  calendar. A  year
consists of 12 months  with 30 days each, plus 5  or 6 additional days
(epagomene) at  the end of  the year.  Leap years occurs  every fourth
year, with no  adjustment for century years. The  calendar also define
weeks  which last  for  7  days, beginning  on  sunday  and ending  on
saturday.

See the full documentation in the C<Date::Calendar::CopticEthiopic> role.

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2019, 2020, 2024, 2025 Jean Forget

This library is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

=end pod
