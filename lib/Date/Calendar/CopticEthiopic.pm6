# -*- encoding: utf-8; indent-tabs-mode: nil -*-
use v6.c;
unit role Date::Calendar::CopticEthiopic:ver<0.0.1>;


=begin pod

=head1 NAME

Date::Calendar::CopticEthiopic - conversions from / to the Coptic calendar and from / to the Ethiopic calendar

=head1 SYNOPSIS

Converting a Gregorian date to both Coptic and Ethiopic

=begin code :lang<perl6>

use Date::Calendar::Coptic;
use Date::Calendar::Ethiopic;

my Date                     $Perlcon-Riga-grg;
my Date::Calendar::Coptic   $Perlcon-Riga-cop;
my Date::Calendar::Ethiopic $Perlcon-Riga-eth;

$Perlcon-Riga-grg .= new(2019, 8, 7);
$Perlcon-Riga-cop .= new-from-date($Perlcon-Riga-grg);
$Perlcon-Riga-eth .= new-from-date($Perlcon-Riga-grg);

say $Perlcon-Riga-cop.strftime("%A %e %B %Y");
#--> Peftoou 1 Misra 1735
say $Perlcon-Riga-eth.strftime("%A %e %B %Y");
#--> Rob 1 Nahas 2011

=end code

Converting a Coptic date and an Ethiopic date to Gregorian

=begin code :lang<perl6>

use Date::Calendar::Coptic;
use Date::Calendar::Ethiopic;

my Date::Calendar::Coptic   $TPC-Pittsburgh-cop;
my Date::Calendar::Ethiopic $TPC-Pittsburgh-eth;
my Date                     $TPC-Pittsburgh-grg1;
my Date                     $TPC-Pittsburgh-grg2;

$TPC-Pittsburgh-cop .= new(year => 1735, month => 10, day => 9);
$TPC-Pittsburgh-grg1 = $TPC-Pittsburgh-cop.to-date;
#--> 9 Bauna 1735 = 16 June 2019

$TPC-Pittsburgh-eth .= new(year => 2011, month => 10, day => 14);
$TPC-Pittsburgh-grg2 = $TPC-Pittsburgh-eth.to-date;
#--> 14 Sane 2011 = 21 June 2019

=end code

=head1 DESCRIPTION

Date::Calendar::CopticEthiopic is a  module distribution providing two
classes,  Date::Calendar::Coptic   and  Date::Calendar::Ethiopic.  The
corresponding  calendars   both  derive  from  the   ancient  Egyptian
calendar. In  each, a year  consists of 12  months with 30  days each,
plus 5 or 6  additional days (epagomene) at the end  of the year. Leap
years occurs every fourth year,  with no adjustment for century years.
The calendars  also define weeks which  last for 7 days,  beginning on
sunday and ending on saturday.

See the full documentation in each class.

=head1 AUTHOR

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright © 2019 Jean Forget

This library is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

=end pod
