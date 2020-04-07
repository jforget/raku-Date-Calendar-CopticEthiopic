# -*- encoding: utf-8; indent-tabs-mode: nil -*-
use v6.c;

use Date::Calendar::Strftime;
use Date::Calendar::CopticEthiopic;
use Date::Calendar::Ethiopic::Names;

unit class Date::Calendar::Ethiopic:ver<0.0.3>:auth<cpan:JFORGET>
      does Date::Calendar::CopticEthiopic
      does Date::Calendar::Strftime;

method BUILD(Int:D :$year, Int:D :$month, Int:D :$day) {
  $._chek-build-args($year, $month, $day);
  $._build-from-args($year, $month, $day);
}

method mjd-bias {
  -676146;
}

method month-name {
  Date::Calendar::Ethiopic::Names::month-name($.month);
}

method month-abbr {
  Date::Calendar::Ethiopic::Names::month-abbr($.month);
}

method day-name {
  Date::Calendar::Ethiopic::Names::day-name($.day-of-week);
}

method day-abbr {
  Date::Calendar::Ethiopic::Names::day-abbr($.day-of-week);
}

=begin pod

=head1 NAME

Date::Calendar::Ethiopic - conversions from / to the Ethiopic calendar

=head1 SYNOPSIS

Converting a Gregorian date to Ethiopic

=begin code :lang<perl6>

use Date::Calendar::Ethiopic;

my Date                     $Perlcon-Riga-grg;
my Date::Calendar::Ethiopic $Perlcon-Riga-eth;

$Perlcon-Riga-grg .= new(2019, 8, 7);
$Perlcon-Riga-eth .= new-from-date($Perlcon-Riga-grg);

say $Perlcon-Riga-eth.strftime("%A %e %B %Y");
#--> Rob 1 Nähase 2011

=end code

Converting an Ethiopic date to Gregorian

=begin code :lang<perl6>

use Date::Calendar::Ethiopic;

my Date::Calendar::Ethiopic $TPC-Pittsburgh-eth;
my Date                     $TPC-Pittsburgh-grg;

$TPC-Pittsburgh-eth .= new(year => 2011, month => 10, day => 14);
$TPC-Pittsburgh-grg  = $TPC-Pittsburgh-eth.to-date;
#--> 14 Säne 2011 = 21 June 2019

=end code

=head1 DESCRIPTION

Date::Calendar::Ethiopic   is  a   class  implementing   the  Ethiopic
calendar. This calendar derives from  the ancient Egyptian calendar. A
year consists of 12  months with 30 days each, plus  5 or 6 additional
days  (epagomene) at  the end  of the  year. Leap  years occurs  every
fourth year, with  no adjustment for century years.  The calendar also
defines weeks which last for 7 days, beginning on sunday and ending on
saturday.

See the full documentation in the C<Date::Calendar::CopticEthiopic> role.

=head1 AUTHOR

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright © 2019, 2020 Jean Forget

This library is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

=end pod
