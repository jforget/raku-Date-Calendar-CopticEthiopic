# -*- encoding: utf-8; indent-tabs-mode: nil -*-
use v6.d;

unit module Date::Calendar::Ethiopic::Names:ver<0.1.1>:auth<zef:jforget>:api<1>;

my @month-names = < Mäskäräm Ṭəqəmt  Ḫədar
                    Taḫśaś   Ṭərr    Yäkatit
                    Mägabit  Miyazya Gənbo
                    Säne     Ḥamle   Nähase
                    Ṗagume >;
my @month-abbr = < Mes Teq Hed Tah Ter Yak Mag Miy Gen Sen Ham Neh Pag >;
my @day-names  = < Ihud Sanyo Maksanyo Rob Hamus Arb Kidamme >;
my @day-abbr   = < Ihu  San   Mak      Rob Ham   Arb Kid     >;

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

Date::Calendar::Ethiopic::Names - names for the Ethiopic calendar

=head1 DESCRIPTION

Date::Calendar::Ethiopic::Names    is    a   companion    module    to
Date::Calendar::Ethiopic. It  provides functions  giving the  names of
the days in the week and the names of the months.

=head1 SOURCES

The month names come from L<https://en.wikipedia.org/wiki/Coptic_calendar>
(not a typo,  the page gives the  month names for both  the Coptic and
the Ethiopic calendars).

The month abbreviations come from
L<https://api.kde.org/4.x-api/kdelibs-apidocs/kdecore/html/kcalendarsystemethiopian_8cpp_source.html>
(no longer available)

The day names come from
L<https://www.ephemeride.com/calendrier/autrescalendriers/21/autres-types-de-calendriers.html>
and the day abbreviations are built from these day names.

=head1 AUTHOR

Jean Forget <J2N-FORGET at orange dot fr>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2019, 2020, 2024, 2025 Jean Forget

This library is  free software; you can redistribute  it and/or modify
it under the Artistic License 2.0.

=end pod
