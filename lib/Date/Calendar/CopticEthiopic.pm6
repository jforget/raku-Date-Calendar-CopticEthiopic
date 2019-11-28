# -*- encoding: utf-8; indent-tabs-mode: nil -*-
use v6.c;
unit role Date::Calendar::CopticEthiopic:ver<0.0.1>;

has Int $.year  where { $_ ≥ 1 };
has Int $.month where { 1 ≤ $_ ≤ 13 };
has Int $.day   where { 1 ≤ $_ ≤ 30 };
has Int $.daycount;
has Int $.day-of-year;
has Int $.day-of-week;
has Int $.week-number;
has Int $.week-year;

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

  # computing derived attributes
  my Int $doy       = 30 × ($month - 1) + $day;
  my Int $daycount  = (365.25 × $year).floor + $doy + $.mjd-bias;
  my Int $dow       = ($daycount + 3) % 7 + 1;
  my Int $doy-pef   = $doy - $dow + 4; # day-of-year value for the nearest Peftoou / Hamus / Wednesday
  my Int $week-year = $year;
  if $doy-pef ≤ 0 {
    -- $week-year;
    $doy    += year-length($week-year);
    $doy-pef = $doy - $dow + 4;
  }
  else {
    my $year-length = year-length($week-year);
    if $doy-pef > $year-length {
      $doy    -= $year-length;
      $doy-pef = $doy - $dow + 4;
      ++ $week-year;
    }
  }
  my Int $week-number = ($doy-pef / 7).ceiling;

  # storing derived attributes
  $!day-of-year = $doy;
  $!day-of-week = $dow;
  $!daycount    = $daycount;
  $!week-number = $week-number;
  $!week-year   = $week-year;
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

sub is-leap(Int $year) {
  $year % 4 == 3;
}

sub year-length(Int $year --> Int) {
  if is-leap($year) { return 366; }
  else              { return 365; }
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
#--> Hamus 1 Nähase 2011

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
#--> 14 Säne 2011 = 21 June 2019

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

=head1 METHODS

=head2 Constructors

=head3 new

Create a  Coptic or Ethiopic  date by giving  the year, month  and day
numbers.

=head3 new-from-date

Build a  Coptic or  Ethiopic date  by cloning  an object  from another
class.  This  other  class  can  be the  core  class  C<Date>  or  any
C<Date::Calendar::>R<xxx> class with a C<daycount> method.

=head3 new-from-daycount

Build a Coptic or Ethiopic date from the Modified Julian Day number.

=head2 Accessors

=head3 year, month, day

The numbers defining the date.

=head3 month-name

The month of the date, as a string.

=head3 month-abbr

The month of the date, as a 3-char string.

=head3 day-name

The name of the day within  the week, as a string.

=head3 day-abbr

The name of the day within  the week, as a 3-char string.

=head3 day-of-week

The number  of the  day within  the week  (1 for  sunday /  Tkyriakē /
Segno, 7 for saturday / Psabbaton / Ehud).

=head3 week-number

The number of  the week within the year,  1 to 52 (or even  53 on some
years). Similar to the "ISO date"  as defined for Gregorian date. Week
number  1 is  the Sun→Sat  span that  contains the  first Wednesday  /
Peftoou / Hamus of the year. This  first week may start as soon as the
3rd  epagomene day  (or 4th  on leap  year) or  as late  as 4  Thout /
Mäskäräm. Likewise, the last  week of the year may end  as soon as the
2nd epagomene  day or  it may  last until 3rd  Thout of  the following
year.

=head3 week-year

Mostly similar  to the  C<year> attribute. Yet,  as described  for the
so-called  "ISO-date"  for the  Gregorian  calendar  and as  explained
above, the last days  of the year and the first  days of the following
year can  be sort-of transferred  to the other year.  The C<week-year>
attribute reflects this transfer. While the real year always begins on
1st Thout / Mäskäräm and ends on  the 5th (6th if leap) epagomene day,
the C<week-year>  always begins on  Sunday /  Tkyriakē / Segno  and it
always ends 364 or 371 days later on Saturday / Psabbaton / Ehud.

=head3 daycount

The MJD value (Modified Julian Date) for the date.

=head2 Other Methods

=head3 gist

Gives a short string representing the date, in C<YYYY-MM-DD> format.

=head3 to-date

Clones  the   date  into   a  core  class   C<Date>  object   or  some
C<Date::Calendar::>I<xxx> compatible calendar  class. The target class
name is given  as a positional parameter. This  parameter is optional,
the default value is C<"Date"> for the Gregorian calendar.

To convert a date from a  calendar to another, you have two conversion
styles,  a "push"  conversion and  a "pull"  conversion. For  example,
while converting from the Coptic date "10 Thout 1736" to Ethiopic, you
can code:

=begin code :lang<perl6>

use Date::Calendar::Coptic;
use Date::Calendar::Ethiopic;

my  Date::Calendar::Coptic   $d-orig;
my  Date::Calendar::Ethiopic $d-dest-push;
my  Date::Calendar::Ethiopic $d-dest-pull;

$d-orig .= new(year  => 1736
             , month =>    1
             , day   =>   10);
$d-dest-push  = $d-orig.to-date("Date::Calendar::Ethiopic");
$d-dest-pull .= new-from-date($d-orig);

=end code

And C<$d-dest-push> and C<$d-dest-pull> result in the same date.

When converting I<from> Gregorian, use the pull style. When converting
I<to> Gregorian, use the push style. When converting from any calendar
other than Gregorian  to any other calendar other  than Gregorian, use
the style you prefer.

=head3 strftime

This method is  very similar to the homonymous functions  you can find
in several  languages (C, shell, etc).  It also takes some  ideas from
C<printf>-similar functions. For example

=begin code :lang<perl6>

$df.strftime("%04d blah blah blah %-25B")

=end code

will give  the day number  padded on  the left with  2 or 3  zeroes to
produce a 4-digit substring, plus the substring C<" blah blah blah ">,
plus the month name, padded on the right with enough spaces to produce
a 25-char substring.  Thus, the whole string will be at least 42 chars
long. By  the way, you  can drop the  "at least" mention,  because the
longest month name  is 15-char long, so the padding  will always occur
and will always include at least 10 spaces.

A C<strftime> specifier consists of:

=item A percent sign,

=item An  optional minus sign, to  indicate on which side  the padding
occurs. If the minus sign is present, the value is aligned to the left
and the padding spaces are added to the right. If it is not there, the
value is aligned to the right and the padding chars (spaces or zeroes)
are added to the left.

=item  An  optional  zero  digit,  to  choose  the  padding  char  for
right-aligned values.  If the  zero char is  present, padding  is done
with zeroes. Else, it is done wih spaces.

=item An  optional length, which  specifies the minimum length  of the
result substring.

=item  An optional  C<"E">  or  C<"O"> modifier.  On  some older  UNIX
system,  these  were used  to  give  the I<extended>  or  I<localized>
version  of  the date  attribute.  Here,  they rather  give  alternate
variants of the date attribute.

=item A mandatory type code.

The allowed type codes are:

=defn C<%a>

The abbreviated day of week name.

=defn C<%A>

The full day of week name.

=defn C<%b>

The abbreviated month name.

=defn C<%B>

The full month name.

=defn C<%c>

The date-time, using the default format, as defined by the current locale.

=defn C<%d>

The day of the month as a decimal number (range 01 to 30).

=defn C<%e>

Like C<%d>, the  day of the month  as a decimal number,  but a leading
zero is replaced by a space.

=defn C<%f>

The month as a decimal number (1  to 13). Unlike C<%m>, a leading zero
is replaced by a space.

=defn C<%F>

Equivalent to %Y-%m-%d (the ISO 8601 date format)

=defn C<%G>

The  "week year"  as a  decimal number.  Mostly similar  to C<%L>  and
C<%Y>, but it may differ on the very  first days of the year or on the
very last  days. Analogous to  the year  number in the  so-called "ISO
date" format for Gregorian dates.

=defn C<%j>

The day of the year as a decimal number (range 001 to 366).

=defn C<%L>

The year  as a decimal  number. Strictly  similar to C<%Y>  and mostly
similar to C<%G>.

=defn C<%m>

The month as a two-digit decimal  number (range 01 to 13), including a
leading zero if necessary.

=defn C<%n>

A newline character.

=defn C<%t>

A tab character.

=defn C<%Y>

The year  as a decimal  number. Strictly  similar to C<%L>  and mostly
similar to C<%G>.

=defn C<%u>

The day of week as a 1..7 number.

=defn C<%V>

The week number as defined above, similar to the week number in the
so-called "ISO date" format for Gregorian dates.

=defn C<%%>

A literal `%' character.

=head1 ISSUES, BUGS, ETC

I am  no expert in  the Sahidic (Coptic)  language and in  the Amharic
(Ethiopic) language. I  have copied / pasted names  from free sources,
but I am  in no position to recognize which  sources are authoritative
or  not. Also,  I  have  kept the  Latin  script  (although with  some
diacritics) and not the Coptic script.

In the Coptic and Ethiopic calendars, days span from sunset to sunset.
Therefore, when  converting with a midnight-to-midnight  calendar, the
converion is valid only before sunset.

Ethiopic or  Ethiopian? Some English-speaking sources  (see below) use
Ethiopic, the others use Ethiopian. Since the first source I have read
is Reingold's and Dershowitz' book, I have used the same term as them,
Ethiopic.

=head1 SEE ALSO

=head2 Internet

L<https://en.wikipedia.org/wiki/Coptic_calendar>

L<https://en.wikipedia.org/wiki/Ethiopian_calendar>

L<https://www.funaba.org/cc>

L<https://www.tondering.dk/claus/calendar.html> - Claus Tøndering's
calendar FAQ

=head2 Raku Software

L<Date::Calendar::Strftime>
or L<https://github.com/jforget/p6-Date-Calendar-Strftime>

L<Date::Calendar::Hebrew>
or L<https://github.com/jforget/p6-Date-Calendar-Hebrew>

L<Date::Calendar::FrenchRevolutionary>
or L<https://github.com/jforget/Date-Calendar-FrenchRevolutionary>

=head2 Perl 5 Software

L<DateTime>

L<Date::Converter>

=head2 Other Software

date(1), strftime(3)

F<calendar/cal-coptic.el>  in Emacs.

CALENDRICA 4.0 -- Common Lisp, which can be download in the "Resources" section of
L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>

=head2 Books

Calendrical Calculations (Fourth Edition) by Nachum Dershowitz and
Edward M. Reingold, Cambridge University Press, see
L<http://www.calendarists.com>
or L<https://www.cambridge.org/us/academic/subjects/computer-science/computing-general-interest/calendrical-calculations-ultimate-edition-4th-edition?format=PB&isbn=9781107683167>.
(Actually, I have used the third edition which is not longer available, see pages 72 to 77)

I<La saga des calendriers>, p 70-71, by Jean Lefort, published by I<Belin> (I<Pour la Science>), ISBN 2-90929-003-5
See L<https://www.belin-editeur.com/la-saga-des-calendriers>

=head1 AUTHOR

Jean Forget <JFORGET@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright © 2019 Jean Forget

This library is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

=end pod
