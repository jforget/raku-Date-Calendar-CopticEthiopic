# -*- encoding: utf-8; indent-tabs-mode: nil -*-
use v6.c;

use Date::Calendar::Strftime;
use Date::Calendar::CopticEthiopic;
use Date::Calendar::Coptic::Names;

unit class Date::Calendar::Coptic:ver<0.0.1>
      does Date::Calendar::CopticEthiopic
      does Date::Calendar::Strftime;

method BUILD(Int:D :$year, Int:D :$month, Int:D :$day) {
  $._chek-build-args($year, $month, $day);
  $._build-from-args($year, $month, $day);
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
  Date::Calendar::Coptic::Names::day-name(($.daycount + 4) % 7);
}

method day-abbr {
  Date::Calendar::Coptic::Names::day-abbr(($.daycount + 4) % 7);
}

=begin pod

=head1 NAME

Date::Calendar::Coptic - conversions from / to the Coptic calendar

=head1 SYNOPSIS

Converting a Gregorian date to Coptic

=begin code :lang<perl6>

use Date::Calendar::Coptic;

my Date                     $Perlcon-Riga-grg;
my Date::Calendar::Coptic   $Perlcon-Riga-cop;

$Perlcon-Riga-grg .= new(2019, 8, 7);
$Perlcon-Riga-cop .= new-from-date($Perlcon-Riga-grg);

say $Perlcon-Riga-cop.strftime("%A %e %B %Y");
#--> Peftoou 1 Mesori 1735

=end code

Converting a Coptic date to Gregorian

=begin code :lang<perl6>

use Date::Calendar::Coptic;

my Date::Calendar::Coptic   $TPC-Pittsburgh-cop;
my Date                     $TPC-Pittsburgh-grg;

$TPC-Pittsburgh-cop .= new(year => 1735, month => 10, day => 9);
$TPC-Pittsburgh-grg  = $TPC-Pittsburgh-cop.to-date;
#--> 9 Paoni 1735 = 16 June 2019

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

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright © 2019 Jean Forget

This library is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

=end pod
