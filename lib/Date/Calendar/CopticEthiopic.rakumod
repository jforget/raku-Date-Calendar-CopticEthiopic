# -*- encoding: utf-8; indent-tabs-mode: nil -*-
use v6.d;
use Date::Calendar::Strftime;
unit role Date::Calendar::CopticEthiopic:ver<0.1.0>:auth<zef:jforget>:api<1>;

has Int $.year  where { $_ ≥ 1 };
has Int $.month where { 1 ≤ $_ ≤ 13 };
has Int $.day   where { 1 ≤ $_ ≤ 30 };
has Int $.daycount;
has Int $.daypart where { before-sunrise() ≤ $_ ≤ after-sunset() };
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

method _build-from-args(Int $year, Int $month, Int $day, Int $daypart) {
  $!year    = $year;
  $!month   = $month;
  $!day     = $day;
  $!daypart = $daypart;

  # computing derived attributes
  my Int $doy       = 30 × ($month - 1) + $day;
  my Int $daycount  = (365.25 × $year).floor + $doy + $.mjd-bias;
  my Int $dow       = ($daycount + 3) % 7 + 1;
  if $daypart == after-sunset() {
    # after computing $dow and $doy, not before!
    --$daycount;
  }

  # storing derived attributes
  $!day-of-year = $doy;
  $!day-of-week = $dow;
  $!daycount    = $daycount;

  # computing week-related derived attributes
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

  # storing week-related derived attributes
  $!week-number = $week-number;
  $!week-year   = $week-year;
}

method new-from-daycount(Int $count is copy, Int :$daypart = daylight()) {
  if $daypart == after-sunset() {
    ++$count;
  }
  my ($nb, $m, $d);  # zero-based values
  my $y;

  # zero-based count from the Coptic / Ethiopic epoch instead of the MJD epoch
  $nb = $count - $.mjd-bias - 1;

  $y   = floor(($nb + 0.75) / 365.25);
  $nb -= floor($y × 365.25);
  $m   = floor($nb / 30);
  $nb -= $m × 30;
  $d   = $nb;

  $.new(year => $y, month => $m + 1, day => $d + 1, daypart => $daypart);
}

method new-from-date($date) {
  $.new-from-daycount($date.daycount, daypart => $date.?daypart // daylight());
}

method to-date($class = 'Date') {
  # See "Learning Perl 6" page 177
  my $d = ::($class).new-from-daycount($.daycount, daypart => $.daypart);
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

=begin code :lang<raku>

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

=begin code :lang<raku>

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

Converting a date from Gregorian to Coptic and Ethiopic, while paying
attention to the sunset:

=begin code :lang<raku>

use Date::Calendar::Strftime;
use Date::Calendar::Gregorian;
use Date::Calendar::Coptic;
use Date::Calendar::Ethiopic;

my Date::Calendar::Gregorian $d-grg;
my Date::Calendar::Coptic    $d-cop;
my Date::Calendar::Ethiopic  $d-eth;

$d-grg .= new('2024-11-13', daypart => before-sunrise());
$d-cop .= new-from-date($d-grg);
$d-eth .= new-from-date($d-grg);
say $d-cop.strftime("%A %e %B %Y"), $d-eth.strftime(" %A %e %B %Y");
# -->  Peftoou  4 Hathor 1741 Hamus  4 Ḫədar 2017

$d-grg .= new('2024-11-13', daypart => daylight());
$d-cop .= new-from-date($d-grg);
$d-eth .= new-from-date($d-grg);
say $d-cop.strftime("%A %e %B %Y"), $d-eth.strftime(" %A %e %B %Y");
# -->  Peftoou  4 Hathor 1741 Hamus  4 Ḫədar 2017 (again)

$d-grg .= new('2024-11-13', daypart => after-sunset());
$d-cop .= new-from-date($d-grg);
$d-eth .= new-from-date($d-grg);
say $d-cop.strftime("%A %e %B %Y"), $d-eth.strftime(" %A %e %B %Y");
# -->  Ptiou  5 Hathor 1741 Arb  5 Ḫədar 2017

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
numbers, plus optionally the  day part (C<before-sunrise>, C<daylight>
or C<after-sunset>).

=head3 new-from-date

Build a  Coptic or  Ethiopic date  by cloning  an object  from another
class.  This  other  class  can  be the  core  class  C<Date>  or  any
C<Date::Calendar::>R<xxx>  class   with  a  C<daycount>   method  and,
hopefully, a C<daypart> method.

=head3 new-from-daycount

Build a  Coptic or Ethiopic date  from the Modified Julian  Day number
and the C<daypart> value.

=head2 Accessors

=head3 year, month, day

The numbers defining the date.

=head3 daypart

A  number indicating  which part  of the  day. This  number should  be
filled   and   compared   with   the   following   subroutines,   with
self-documenting names:

=item before-sunrise()
=item daylight()
=item after-sunset()

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

=head3 day-of-year

How many  days since  the beginning of  the year. 1  to 365  on normal
years, 1 to 366 on leap years.

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

=begin code :lang<raku>

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

When converting  I<from> the core  class C<Date>, use the  pull style.
When converting I<to> the core class C<Date>, use the push style. When
converting from  any class other  than the  core class C<Date>  to any
other  class other  than the  core class  C<Date>, use  the style  you
prefer.

Please note  that the  class C<Date::Calendar::Gregorian> can  be used
instead of  the core class  C<Date> to implement Gregorian  dates. And
with this class, you can use both  the push and the pull methods, just
like the other C<Date::Calendar::>R<xxx> classes.

=head3 strftime

This method is  very similar to the homonymous functions  you can find
in several  languages (C, shell, etc).  It also takes some  ideas from
C<printf>-similar functions. For example

=begin code :lang<raku>

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

=defn %a

The abbreviated day of week name.

=defn %A

The full day of week name.

=defn %b

The abbreviated month name.

=defn %B

The full month name.

=defn %c

The date-time, using the default format, as defined by the current locale.

=defn %d

The day of the month as a decimal number (range 01 to 30).

=defn %e

Like C<%d>, the  day of the month  as a decimal number,  but a leading
zero is replaced by a space.

=defn %f

The month as a decimal number (1  to 13). Unlike C<%m>, a leading zero
is replaced by a space.

=defn %F

Equivalent to %Y-%m-%d (the ISO 8601 date format)

=defn %G

The  "week year"  as a  decimal number.  Mostly similar  to C<%L>  and
C<%Y>, but it may differ on the very  first days of the year or on the
very last  days. Analogous to  the year  number in the  so-called "ISO
date" format for Gregorian dates.

=defn %j

The day of the year as a decimal number (range 001 to 366).

=defn %L

The year  as a decimal  number. Strictly  similar to C<%Y>  and mostly
similar to C<%G>.

Since  2024 and  the release  of C<Date::Calendar::Strfrtime>  version
C<0.0.4>, this strftime specifier is deprecated.

=defn %m

The month as a two-digit decimal  number (range 01 to 13), including a
leading zero if necessary.

=defn %n

A newline character.

=defn %Ep

Gives a 1-char string representing the day part:

=item C<☾> or C<U+263E> before sunrise,
=item C<☼> or C<U+263C> during daylight,
=item C<☽> or C<U+263D> after sunset.

Rationale: in  C or in  other programming languages,  when C<strftime>
deals with a date-time object, the day is split into two parts, before
noon and  after noon. The  C<%p> specifier  reflects this by  giving a
C<"AM"> or C<"PM"> string.

The  3-part   splitting  in   the  C<Date::Calendar::>R<xxx>   may  be
considered as  an alternate  splitting of  a day.  To reflect  this in
C<strftime>, we use an alternate version of C<%p>, therefore C<%Ep>.

=defn %t

A tab character.

=defn %u

The day of week as a 1..7 number.

=defn %V

The week number as defined above, similar to the week number in the
so-called "ISO date" format for Gregorian dates.

=defn %Y

The year  as a decimal  number. Strictly  similar to C<%L>  and mostly
similar to C<%G>.

=defn %%

A literal `%' character.

=head1 ISSUES, BUGS, ETC

I am  no expert in  the Sahidic (Coptic)  language and in  the Amharic
(Ethiopic) language. I  have copied / pasted names  from free sources,
but I am  in no position to recognize which  sources are authoritative
or  not. Also,  I  have  kept the  Latin  script  (although with  some
diacritics) and not the Coptic script.

Ethiopic or  Ethiopian? Some English-speaking sources  (see below) use
Ethiopic, the others use Ethiopian. Since the first source I have read
is Reingold's and Dershowitz' book, I have used the same term as them,
Ethiopic.

=head2 Security issues

As explained in  the C<Date::Calendar::Strftime> documentation, please
ensure that format-string  passed to C<strftime> comes  from a trusted
source. Failing  that, the untrusted  source can include  a outrageous
length in  a C<strftime> specifier and  this will drain your  PC's RAM
very fast.

=head2 Relations with :ver<0.0.x> classes

Version 0.1.0 (and API 1) was  introduced to ease the conversions with
other calendars  in which the  day is defined as  sunset-to-sunset. If
all C<Date::Calendar::>R<xxx> classes use version 0.1.x and API 1, the
conversions  will be  correct. But  if some  C<Date::Calendar::>R<xxx>
classes use version 0.0.x and API 0, there might be problems.

A date from a 0.0.x class has no C<daypart> attribute. But when "seen"
from  a  0.1.x class,  the  0.0.x  date  seems  to have  a  C<daypart>
attribute equal to C<daylight>. When converted from a 0.1.x class to a
0.0.x  class,  the  date  may  just  shift  from  C<after-sunset>  (or
C<before-sunrise>) to C<daylight>, or it  may shift to the C<daylight>
part of  the prior (or  next) date. This  means that a  roundtrip with
cascade conversions  may give the  starting date,  or it may  give the
date prior or after the starting date.

=head2 Time

This module  and the C<Date::Calendar::>R<xxx> associated  modules are
still date  modules, they are not  date-time modules. The user  has to
give  the C<daypart>  attribute  as a  value among  C<before-sunrise>,
C<daylight> or C<after-sunset>. There is no provision to give a HHMMSS
time and convert it to a C<daypart> parameter.

=head1 SEE ALSO

=head2 Internet

L<https://en.wikipedia.org/wiki/Coptic_calendar>

L<https://en.wikipedia.org/wiki/Ethiopian_calendar>

L<https://www.funaba.org/cc>

L<https://www.tondering.dk/claus/calendar.html> - Claus Tøndering's
calendar FAQ

=head2 Raku Software

L<Date::Calendar::Strftime|https://raku.land/zef:jforget/Date::Calendar::Strftime>
or L<https://github.com/jforget/raku-Date-Calendar-Strftime>

L<Date::Calendar::Gregorian|https://raku.land/zef:jforget/Date::Calendar::Gregorian>
or L<https://github.com/jforget/raku-Date-Calendar-Gregorian>

L<Date::Calendar::Hebrew|https://raku.land/zef:jforget/Date::Calendar::Hebrew>
or L<https://github.com/jforget/raku-Date-Calendar-Hebrew>

L<Date::Calendar::FrenchRevolutionary|https://raku.land/zef:jforget/Date::Calendar::FrenchRevolutionary>
or L<https://github.com/jforget/raku-Date-Calendar-FrenchRevolutionary>

L<Date::Calendar::Julian|https://raku.land/zef:jforget/Date::Calendar::Julian>
or L<https://github.com/jforget/raku-Date-Calendar-Julian>

L<Date::Calendar::Hijri|https://raku.land/zef:jforget/Date::Calendar::Hijri>
or L<https://github.com/jforget/raku-Date-Calendar-Hijri>

L<Date::Calendar::MayaAztec|https://raku.land/zef:jforget/Date::Calendar::MayaAztec>
or L<https://github.com/jforget/raku-Date-Calendar-MayaAztec>

L<Date::Calendar::Persian|https://raku.land/zef:jforget/Date::Calendar::Persian>
or L<https://github.com/jforget/raku-Date-Calendar-Persian>

L<Date::Calendar::Bahai|https://raku.land/zef:jforget/Date::Calendar::Bahai>
or L<https://github.com/jforget/raku-Date-Calendar-Bahai>

=head2 Perl 5 Software

L<DateTime|https://metacpan.org/pod/DateTime>

L<Date::Converter|https://metacpan.org/pod/Date::Converter>

=head2 Other Software

date(1), strftime(3)

C<calendar/cal-coptic.el>  in Emacs.

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

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2019, 2020, 2024 Jean Forget

This library is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

=end pod
