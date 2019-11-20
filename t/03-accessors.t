#
# Checking the getters (and also the C<locale> setter)
#
use v6.c;
use Test;
use Date::Calendar::Coptic;
use Date::Calendar::Ethiopic;

plan  2  # classes
   ×  3; # accessors

my Date::Calendar::Coptic $dc .= new(year => 1736, month => 3, day => 10);

is($dc.month,   3);
is($dc.day,    10);
is($dc.year, 1736);
#is($dc.month-name, '???');
#is($dc.day-name,   '???');

my Date::Calendar::Ethiopic $de .= new(year => 2012, month => 3, day => 10);

is($de.month,   3);
is($de.day,    10);
is($de.year, 2012);
#is($de.month-name, '???');
#is($de.day-name,   '???');


done-testing;
