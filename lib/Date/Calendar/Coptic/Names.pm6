# -*- encoding: utf-8; indent-tabs-mode: nil -*-
use v6.c;

unit module Date::Calendar::Coptic::Names:ver<0.0.3>:auth<zef:jforget>:api<0>;

my @month-names = Q :ww / Thout    Paopi    Hathor
                          Koiak    Tobi     Meshir
                          Paremhat Parmouti Pashons
                          Paoni    Epip     Mesori
                         'Pi Kogi Enavot'
                         /;

my @month-abbr = < Tho Pao Hat
                   Kia Tob Mes
                   Par Pam Pas
                   Pan Epe Meo
                   Kou
                   >;

my @day-names = < Tkyriakē  Pesnau Pshoment Peftoou Ptiou Psoou Psabbaton >;
my @day-abbr  = < Tky       Pes    Psh      Pef     Pti   Pso   Psa       >;

our sub month-name(Int:D $month --> Str) {
  return @month-names[$month - 1];
}

our sub month-abbr(Int:D $month --> Str) {
  return @month-abbr[$month - 1];
}

our sub day-name(Int:D $day7 --> Str) {
  return @day-names[$day7 - 1];
}

our sub day-abbr(Int:D $day7 --> Str) {
  return @day-abbr[$day7 - 1];
}

=begin pod

=head1 NAME

Date::Calendar::Coptic::Names - Names for the Coptic calendar

=head1 DESCRIPTION

Date::Calendar::Coptic::Names    is    a     companion    module    to
Date::Calendar::Coptic. It provides the day  names and the month names
for this calendar.

=head1 SOURCES

The month names come from L<https://en.wikipedia.org/wiki/Coptic_calendar>.

The month abbreviations, the day names and the day abbreviations come from
L<https://api.kde.org/4.x-api/kdelibs-apidocs/kdecore/html/kcalendarsystemcoptic_8cpp_source.html>.


=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright © 2019, 2020, 2024 Jean Forget

This library is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

=end pod
