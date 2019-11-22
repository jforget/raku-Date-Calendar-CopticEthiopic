# -*- encoding: utf-8; indent-tabs-mode: nil -*-
use v6.c;
unit role Date::Calendar::CopticEthiopic:ver<0.0.1>;

has Int $.year  where { $_ ≥ 1 };
has Int $.month where { 1 ≤ $_ ≤ 13 };
has Int $.day   where { 1 ≤ $_ ≤ 30 };

method _chek-build-args(Int $year, Int $month, Int $day) {

  unless 1 ≤ $month ≤ 13 {
    X::OutOfRange.new(:what<Month>, :got($month), :range<1..13>).throw;
  }

  if $month ≤ 12 {
    unless 1 ≤ $day ≤ 30 {
      X::OutOfRange.new(:what<Day>, :got($day), :range<1..30>).throw;
    }
  }

  else {
    if is-leap($year) {
      unless 1 ≤ $day ≤ 6 {
        X::OutOfRange.new(:what<Day>, :got($day), :range<1..6>).throw;
      }
    }
    else {
      unless 1 ≤ $day ≤ 5 {
        X::OutOfRange.new(:what<Day>, :got($day), :range<1..5>).throw;
      }
    }
  }
}

method _build-from-args(Int $year, Int $month, Int $day) {
  $!year   = $year;
  $!month  = $month;
  $!day    = $day;
}

method daycount {
    floor(365.25 × $.year)
  + 30 × ($.month - 1)
  + $.day
  + $.mjd-bias
}

method new-from-daycount(Int $count) {
  my ($nb, $m, $d);  # zero-based values
  my $y;

  # zero-based count from the Coptic / Ethiopic epoch instead of the MJD epoch
  $nb = $count - $.mjd-bias - 1;

  $y   = floor(($nb + 0.75) / 365.25);
  $nb -= floor($y × 365.25);
  $m   = floor($nb / 30);
  $nb -= $m × 30;
  $d   = $nb;

  $.new(year => $y, month => $m + 1, day => $d + 1);
}

method new-from-date($date) {
  $.new-from-daycount($date.daycount);
}

method to-date($class = 'Date') {
  # See "Learning Perl 6" page 177
  my $d = ::($class).new-from-daycount($.daycount);
  return $d;
}

method gist {
  sprintf("%04d-%02d-%02d", $.year, $.month, $.day);
}

method day-of-year {
  $.day + 30 × ($.month - 1);
}

sub is-leap(Int $year) {
  $year % 4 == 3;
}

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
#--> Peftoou 1 Mesori 1735
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
#--> 9 Paoni 1735 = 16 June 2019

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
