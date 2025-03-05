#!/usr/bin/env raku
# -*- encoding: utf-8; indent-tabs-mode: nil -*-
#
# Générer les données de test pour xx-conv-old.rakutest et xx-conv-new.rakutest
#

use v6.d;
use Date::Calendar::Strftime:ver<0.1.0>;
use Date::Calendar::Aztec;
use Date::Calendar::Aztec::Cortes;
use Date::Calendar::Bahai;
use Date::Calendar::Bahai::Astronomical;
use Date::Calendar::Coptic;
use Date::Calendar::Ethiopic;
use Date::Calendar::Hebrew;
use Date::Calendar::Hijri;
use Date::Calendar::Gregorian;
use Date::Calendar::FrenchRevolutionary;
use Date::Calendar::FrenchRevolutionary::Arithmetic;
use Date::Calendar::FrenchRevolutionary::Astronomical;
use Date::Calendar::Julian;
use Date::Calendar::Julian::AUC;
use Date::Calendar::Maya;
use Date::Calendar::Maya::Astronomical;
use Date::Calendar::Maya::Spinden;
use Date::Calendar::Persian;
use Date::Calendar::Persian::Astronomical;

my %class =   a0 => 'Date::Calendar::Aztec'
            , a1 => 'Date::Calendar::Aztec::Cortes'
            , ba => 'Date::Calendar::Bahai'
            , be => 'Date::Calendar::Bahai::Astronomical'
            , gr => 'Date::Calendar::Gregorian'
            , co => 'Date::Calendar::Coptic'
            , et => 'Date::Calendar::Ethiopic'
            , fr => 'Date::Calendar::FrenchRevolutionary'
            , fa => 'Date::Calendar::FrenchRevolutionary::Arithmetic'
            , fe => 'Date::Calendar::FrenchRevolutionary::Astronomical'
            , he => 'Date::Calendar::Hebrew'
            , hi => 'Date::Calendar::Hijri'
            , jl => 'Date::Calendar::Julian'
            , jc => 'Date::Calendar::Julian::AUC'
            , m0 => 'Date::Calendar::Maya'
            , m1 => 'Date::Calendar::Maya::Astronomical'
            , m2 => 'Date::Calendar::Maya::Spinden'
            , pe => 'Date::Calendar::Persian'
            , pa => 'Date::Calendar::Persian::Astronomical'
            ;
my %midnight = ba => False
             , be => False
             , co => False
             , et => False
             , fr => True
             , fa => True
             , fe => True
             , gr => True
             , he => False
             , hi => False
             , jl => True
             , jc => True
             , pe => True
             , pa => True
             ;

my @new-maya;
my @new-others;


say '09-conv-coptic-old.rakutest, @data-others (and then @data-greg)';
gener-others('co', 'ba', 1738,  9,  7);
gener-others('co', 'be', 1741, 11, 21);
gener-others('co', 'co', 1740,  4, 14);
gener-others('co', 'et', 1739,  2, 12);
gener-others('co', 'fr', 1741,  7, 23);
gener-others('co', 'fa', 1739,  6, 17);
gener-others('co', 'fe', 1740,  9,  8);
gener-others('co', 'gr', 1741,  3,  5);
gener-others('co', 'he', 1740, 10, 11);
gener-others('co', 'hi', 1738,  8,  5);
gener-others('co', 'jl', 1740,  4, 16);
gener-others('co', 'jc', 1741,  5,  8);
gener-others('co', 'pe', 1739, 12,  9);
gener-others('co', 'pa', 1738, 10, 24);
say '-' x 50;
say '09-conv-coptic-old.rakutest, @data-maya';
gener-maya('co', 'm0', 1741,  2, 23);
gener-maya('co', 'm1', 1739,  7, 14);
gener-maya('co', 'm2', 1740,  3,  4);
gener-maya('co', 'a0', 1741, 12, 26);
gener-maya('co', 'a1', 1740,  5,  4);
say '-' x 50;
say '10-conv-coptic-new.rakutest, @data';
say @new-others.join("");
say '-' x 50;
say '10-conv-coptic-new.rakutest, @data-maya';
say @new-maya.join("");

@new-maya   = ();
@new-others = ();
say '-' x 50;
say '11-conv-ethiopic-old.rakutest, @data-others (and then @data-greg)';
gener-others('et', 'ba', 2014,  8,  3);
gener-others('et', 'be', 2017, 12, 21);
gener-others('et', 'co', 2016,  6, 13);
gener-others('et', 'et', 2015,  1, 15);
gener-others('et', 'fr', 2017,  3, 28);
gener-others('et', 'fa', 2015,  7,  7);
gener-others('et', 'fe', 2016,  4,  5);
gener-others('et', 'gr', 2017,  3,  5);
gener-others('et', 'he', 2016, 12, 11);
gener-others('et', 'hi', 2014,  7, 25);
gener-others('et', 'jl', 2016,  6,  4);
gener-others('et', 'jc', 2017,  7, 18);
gener-others('et', 'pe', 2015, 10, 19);
gener-others('et', 'pa', 2014, 11, 14);
say '-' x 50;
say '11-conv-ethiopic-old.rakutest, @data-maya';
gener-maya('et', 'm0', 2017,  2, 13);
gener-maya('et', 'm1', 2015,  5, 24);
gener-maya('et', 'm2', 2016,  1, 24);
gener-maya('et', 'a0', 2017,  2, 14);
gener-maya('et', 'a1', 2016, 10,  4);
say '-' x 50;
say '12-conv-ethiopic-new.rakutest, @data';
say @new-others.join("");
say '-' x 50;
say '12-conv-ethiopic-new.rakutest, @data-maya';
say @new-maya.join("");

sub gener-others($key-from, $key-to, $year, $month, $day) {
  if $key-from eq 'co' {
    my Date::Calendar::Coptic $dce0;
    my Date::Calendar::Coptic $dce1;
    gener-others1($dce0, $dce1, $key-to, $year, $month, $day);
  }
  else {
    my Date::Calendar::Ethiopic $dce0;
    my Date::Calendar::Ethiopic $dce1;
    gener-others1($dce0, $dce1, $key-to, $year, $month, $day);
  }
}

sub gener-others1($dce0 is copy, $dce1 is copy, $key, $year, $month, $day) {
  $dce1 .= new(year => $year, month => $month, day => $day);
  $dce0 .= new-from-daycount($dce1.daycount - 1);
  my     $d0  = $dce0.to-date(%class{$key});
  my     $d1  = $dce1.to-date(%class{$key});
  my Str $s0  = $d0  .strftime('"%A %d %b %Y"');
  my Str $s1  = $d1  .strftime('"%A %d %b %Y"');
  my Str $sf0 = $dce0.strftime('"%a %d %b %Y ☼"');
  my Str $sf1 = $dce1.strftime('"%a %d %b %Y ☼"');
  my Str $gr0 = $dce0.to-date.gist;
  my Str $gr1 = $dce1.to-date.gist;
  my Int $lg-s1 = 30;
  my Int $lg-sf = 19;
  if $s0 .chars < $lg-s1 { $s0  ~= ' ' x ($lg-s1 - $s0 .chars); }
  if $s1 .chars < $lg-s1 { $s1  ~= ' ' x ($lg-s1 - $s1 .chars); }
  if $sf0.chars < $lg-sf { $sf0 ~= ' ' x ($lg-sf - $sf0.chars); }
  if $sf1.chars < $lg-sf { $sf1 ~= ' ' x ($lg-sf - $sf1.chars); }
  my Str $day-x   = sprintf("%2d", $day);
  my Str $month-x = sprintf("%2d", $month);
  print qq:to<EOF>;
       , ($year, $month-x, $day-x, after-sunset,   '$key', $s0, $sf0, "$gr0 shift to previous day")
       , ($year, $month-x, $day-x, before-sunrise, '$key', $s1, $sf1, "$gr1 shift to daylight")
       , ($year, $month-x, $day-x, daylight,       '$key', $s1, $sf1, "$gr1 no problem")
  EOF

  $s0  = $d0  .strftime("%A %d %b %Y");
  $s1  = $d1  .strftime("%A %d %b %Y");
  $sf1 = $dce1.strftime("%a %d %b %Y");
  my Int $lg = 26;
  my Str $w0 = ''; if $s0.chars < $lg { $w0 = ' ' x ($lg - $s0.chars); }
  my Str $w1 = ''; if $s1.chars < $lg { $w1 = ' ' x ($lg - $s1.chars); }
  if %midnight{$key} {
    push @new-others, qq:to<EOF>;
         , ($year, $month-x, $day-x, after-sunset,   '$key', "$s0 ☽"$w0, "$sf1 ☽", "Gregorian: $gr0")
         , ($year, $month-x, $day-x, before-sunrise, '$key', "$s1 ☾"$w1, "$sf1 ☾", "Gregorian: $gr1")
         , ($year, $month-x, $day-x, daylight,       '$key', "$s1 ☼"$w1, "$sf1 ☼", "Gregorian: $gr1")
    EOF
  }
  else {
    push @new-others, qq:to<EOF>;
         , ($year, $month-x, $day-x, after-sunset,   '$key', "$s1 ☽"$w1, "$sf1 ☽", "Gregorian: $gr0")
         , ($year, $month-x, $day-x, before-sunrise, '$key', "$s1 ☾"$w1, "$sf1 ☾", "Gregorian: $gr1")
         , ($year, $month-x, $day-x, daylight,       '$key', "$s1 ☼"$w1, "$sf1 ☼", "Gregorian: $gr1")
    EOF
  }
}


sub gener-maya($key-from, $key-to, $year, $month, $day) {
  if $key-from eq 'co' {
    my Date::Calendar::Coptic $dce0;
    my Date::Calendar::Coptic $dce1;
    my Date::Calendar::Coptic $dce2;
    gener-maya1($dce0, $dce1, $dce2, $key-to, $year, $month, $day);
  }
  else {
    my Date::Calendar::Ethiopic $dce0;
    my Date::Calendar::Ethiopic $dce1;
    my Date::Calendar::Ethiopic $dce2;
    gener-maya1($dce0, $dce1, $dce2, $key-to, $year, $month, $day);
  }
}
sub gener-maya1($dce0 is copy, $dce1 is copy, $dce2 is copy, $key, $year, $month, $day) {
  $dce1 .= new(year => $year, month => $month, day => $day);
  $dce0 .= new-from-daycount($dce1.daycount - 1);
  $dce2 .= new-from-daycount($dce1.daycount + 1);
  my Str $sf0 = $dce0.strftime('"%a %d %b %Y ☼"');
  my Str $sf1 = $dce1.strftime('"%a %d %b %Y ☼"');
  my     $d0  = $dce0.to-date(%class{$key});
  my     $d1  = $dce1.to-date(%class{$key});
  my     $d2  = $dce2.to-date(%class{$key});
  my Str $s0  = $d0  .strftime('"%e %B %V %A"');
  my Str $s1  = $d1  .strftime('"%e %B %V %A"');
  my Str $l0  = $d0  .strftime( '%e %B ') ~ $d1.strftime( '%V %A');
  my Str $l2  = $d1  .strftime( '%e %B ') ~ $d2.strftime( '%V %A');
  my Str $gr0 = $dce0.to-date.gist;
  my Str $gr1 = $dce1.to-date.gist;
  my Int $lg-s1 = 25;
  my Int $lg-sf = 19;
  if $s0 .chars < $lg-s1 { $s0  ~= ' ' x ($lg-s1 - $s0 .chars); }
  if $s1 .chars < $lg-s1 { $s1  ~= ' ' x ($lg-s1 - $s1 .chars); }
  if $sf0.chars < $lg-sf { $sf0 ~= ' ' x ($lg-sf - $sf0.chars); }
  if $sf1.chars < $lg-sf { $sf1 ~= ' ' x ($lg-sf - $sf1.chars); }
  my Str $day-x   = sprintf("%2d", $day);
  my Str $month-x = sprintf("%2d", $month);
  print qq:to<EOF>;
       , ($year, $month-x, $day-x, after-sunset,   '$key', $s0, $sf0, "$gr0 shift to previous date, wrong clerical date, should be $l0")
       , ($year, $month-x, $day-x, before-sunrise, '$key', $s1, $sf1, "$gr1 wrong intermediate date, should be $l0")
       , ($year, $month-x, $day-x, daylight,       '$key', $s1, $sf1, "$gr1 no problem")
  EOF

  my Str $sfz = $dce1.strftime('"%a %d %b %Y ☽"');
  $sf0        = $dce1.strftime('"%a %d %b %Y ☾"');
  $sf1        = $dce1.strftime('"%a %d %b %Y ☼"');
  $s0         = $d0  .strftime('"%e %B ') ~ $d1.strftime('%V %A"');
  $s1         = $d1  .strftime('"%e %B %V %A"');
  if $s0 .chars < $lg-s1 { $s0  ~= ' ' x ($lg-s1 - $s0 .chars); }
  if $s1 .chars < $lg-s1 { $s1  ~= ' ' x ($lg-s1 - $s1 .chars); }
  if $sfz.chars < $lg-sf { $sfz ~= ' ' x ($lg-sf - $sfz.chars); }
  if $sf0.chars < $lg-sf { $sf0 ~= ' ' x ($lg-sf - $sf0.chars); }
  if $sf1.chars < $lg-sf { $sf1 ~= ' ' x ($lg-sf - $sf1.chars); }
  push @new-maya, qq:to<EOF>;
       , ($year, $month-x, $day-x, after-sunset,   '$key', $s0, $sfz, "Gregorian: $gr0")
       , ($year, $month-x, $day-x, before-sunrise, '$key', $s0, $sf0, "Gregorian: $gr1")
       , ($year, $month-x, $day-x, daylight,       '$key', $s1, $sf1, "Gregorian: $gr1")
  EOF
}

sub gener-new-maya1($dce0 is copy, $dce1 is copy, $dce2 is copy, $key, $year, $month, $day) {
  $dce1 .= new(year => $year, month => $month, day => $day);
  $dce0 .= new-from-daycount($dce1.daycount - 1);
  $dce2 .= new-from-daycount($dce1.daycount + 1);
  my Str $sf0 = $dce1.strftime('"%a %d %b %Y ☾"');
  my Str $sf1 = $dce1.strftime('"%a %d %b %Y ☼"');
  my Str $sf2 = $dce1.strftime('"%a %d %b %Y ☽"');
  my     $d0  = $dce0.to-date(%class{$key});
  my     $d1  = $dce1.to-date(%class{$key});
  my     $d2  = $dce2.to-date(%class{$key});
  my Str $s1  = $d1.strftime('"%e %B %V %A"');
  my Str $s0  = $d0.strftime('"%e %B ') ~ $d1.strftime('%V %A"');
  my Str $s2  = $d1.strftime('"%e %B ') ~ $d2.strftime('%V %A"');
  my Str $gr0 = $dce0.to-date.gist;
  my Str $gr1 = $dce1.to-date.gist;
  my Str $gr2 = $dce2.to-date.gist;
  my Int $lg-s1 = 25;
  my Int $lg-sf = 19;
  if $s0 .chars < $lg-s1 { $s0  ~= ' ' x ($lg-s1 - $s0 .chars); }
  if $s1 .chars < $lg-s1 { $s1  ~= ' ' x ($lg-s1 - $s1 .chars); }
  if $s2 .chars < $lg-s1 { $s2  ~= ' ' x ($lg-s1 - $s2 .chars); }
  if $sf0.chars < $lg-sf { $sf0 ~= ' ' x ($lg-sf - $sf0.chars); }
  if $sf1.chars < $lg-sf { $sf1 ~= ' ' x ($lg-sf - $sf1.chars); }
  if $sf2.chars < $lg-sf { $sf2 ~= ' ' x ($lg-sf - $sf2.chars); }
  my Str $day-x   = sprintf("%2d", $day);
  my Str $month-x = sprintf("%2d", $month);
  print qq:to<EOF>
       , ($year, $month-x, $day-x, after-sunset,   '$key', $s0, $sf0, "Gregorian: $gr0")
       , ($year, $month-x, $day-x, before-sunrise, '$key', $s0, $sf0, "Gregorian: $gr1")
       , ($year, $month-x, $day-x, daylight,       '$key', $s1, $sf1, "Gregorian: $gr1")
  EOF
}

=begin pod

=head1 NAME

gener-test-0.1.0.raku -- Generation of test data

=head1 SYNOPSIS

  raku gener-test-0.1.0.raku > /tmp/test-data

copy-paste from /tmp/test-data to the tests scripts.

=head1 DESCRIPTION

This  program  uses  the  various  C<Date::Calendar::>R<xxx>  classes,
version 0.0.x and  API 0, to generate test data  for version 0.1.0 and
API 1 of the modules for Coptic and Ethiopic calendars. After the test
data  are generated,  check  them with  another  source (the  calendar
functions in Emacs, some websites, some Android apps). Please remember
that the other  sources do not care about sunset  (and sunrise for the
civil Maya  and Aztec calendars)  and that  you will have  to mentally
shift the results before the comparison.

And after  the data are  checked, copy-paste  the lines into  the test
scripts
C<09-conv-coptic-old.rakutest>,
C<10-conv-coptic-new.rakutest>,
C<11-conv-ethiopic-old.rakutest>
and C<12-conv-ethiopic-new.rakutest>,
as described in the label just above the data lines.

=head2 Maya (and Aztec) dates

Just cut-and-paste  the lines into  the C<@data-maya> variable  of the
proper test file. Erase the comma in the first pasted line.

=head2 Other dates, test file for old conversions

Cut and past  the lines into the C<@data> variable  of the proper test
file.  Then,  from  this  variable,  select  the  lines  dealing  with
Gregorian dates,  cut-and-paste them into the  C<@data-greg> variable.
At the  end of  each line  dealing with  a Gregorian  date, add  a 9th
element,  which  is  the  Gregorian date  in  C<'YYYY-MM-DD'>  format.
Lastly, cut (and  do not paste) the lines for  the Coptic calendar and
the Ethiopic  calendar (which  cannot be simultaneously  version 0.0.3
and version 0.1.0).

Remove the first comma in the C<@data-greg> and C<@data> variables.

=head2 Other dates, test file for new conversions

Cut and past  the lines into the C<@data> variable  of the proper test
file.

All computed  dates are daylight  dates. So  it does not  matter which
version  and API  are  such  and such  classes.  Daylight dates  gives
exactly the  same results with version  0.1.0 / API 1  as with version
0.0.x / API 0.

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2024, 2025 Jean Forget, all rights reserved

This program is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

=end pod
