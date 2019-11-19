NOM
===

Date::Calendar::CopticEthiopic - conversions depuis / vers le calendrier copte et depuis / vers le calendrier étrhiopien

SYNOPSIS
========

Conversion  d'une date  grégorienne  vers le  calendrier  copte et  le
calendrier éthiopien

```perl6
use Date::Calendar::Coptic;
use Date::Calendar::Ethiopic;

my Date			    $Perlcon-Riga-grg;
my Date::Calendar::Coptic   $Perlcon-Riga-cop;
my Date::Calendar::Ethiopic $Perlcon-Riga-eth;

$Perlcon-Riga-grg .= new(2019, 8, 7);
$Perlcon-Riga-cop .= new-from-date($Perlcon-Riga-grg);
$Perlcon-Riga-eth .= new-from-date($Perlcon-Riga-grg);

say $Perlcon-Riga-cop.strftime("%A %e %B %Y");
#--> Peftoou 1 Misra 1735
say $Perlcon-Riga-eth.strftime("%A %e %B %Y");
#--> Rob 1 Nahas 2011
```

Conversion  d'une  date  copte  et  d'une  date  éthiopienne  vers  le
calendrier grégorien

```perl6
use Date::Calendar::Coptic;
use Date::Calendar::Ethiopic;

my Date::Calendar::Coptic   $TPC-Pittsburgh-cop;
my Date::Calendar::Ethiopic $TPC-Pittsburgh-eth;
my Date			    $TPC-Pittsburgh-grg1;
my Date			    $TPC-Pittsburgh-grg2;

$TPC-Pittsburgh-cop .= new(year => 1735, month => 10, day => 9);
$TPC-Pittsburgh-grg1 = $TPC-Pittsburgh-cop.to-date;
#--> 9 Bauna 1735 = 16 June 2019

$TPC-Pittsburgh-eth .= new(year => 2011, month => 10, day => 14);
$TPC-Pittsburgh-grg2 = $TPC-Pittsburgh-eth.to-date;
#--> 14 Sane 2011 = 21 June 2019
```

INSTALLATION
============

```shell
zef install Date::Calendar::CopticEthiopic
```

ou bien

```shell
git clone https://github.com/jforget/raku-Date-Calendar-CopticEthiopic.git
cd Date-Calendar-CopticEthiopic
zef install .
```

DESCRIPTION
===========

La distribution de  module Date::Calendar::CopticEthiopic fournit deux
classes,   Date::Calendar::Coptic  et   Date::Calendar::Ethiopic.  Les
calendriers   correspondant  dérivent   du   calendrier  égyptien   de
l'Antiquité. Dans les  deux calendriers, une année est  composée de 12
mois de 30 jours, plus  cinq ou six jours complémentaires (épagomènes)
à la  fin de l'année. Une  année sur quatre est  une année bissextile,
sans  ajustement  pour les  années  séculaires.  Les deux  calendriers
comportent des semaines de 7 jours, du dimanche au samedi.

AUTEUR
======

Jean Forget <JFORGET@cpan.org>

COPYRIGHT ET LICENCE
====================

Copyright © 2019 Jean Forget, tous droits réservés.

Ce code constitue du logiciel libre. Vous pouvez le redistribuer et le
modifier  en accord  avec  la  « licence  artistique  2.0 »  (Artistic
License 2.0).

