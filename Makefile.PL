
use strict;
use warnings;

use 5.014;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  'ABSTRACT' => 'Módulos para facilitarem a intergração entre a EV e o PayPal.',
  'AUTHOR' => 'Aware <desenvolvimento@aware.com.br>',
  'BUILD_REQUIRES' => {
    'Data::UUID' => '0',
    'English' => '0',
    'File::Find' => '0',
    'File::Temp' => '0',
    'Test::EstanteSetup' => '0',
    'Test::More' => '0',
    'utf8' => '0'
  },
  'CONFIGURE_REQUIRES' => {
    'ExtUtils::MakeMaker' => '6.30'
  },
  'DISTNAME' => 'Estante-PayPal',
  'EXE_FILES' => [],
  'LICENSE' => 'restrictive',
  'NAME' => 'Estante::PayPal',
  'PREREQ_PM' => {
    'Carp' => '0',
    'Config::Any' => '0',
    'JSON::XS' => '0',
    'Moose' => '0',
    'Moose::Role' => '0',
    'MooseX::Traits' => '0',
    'WWW::Mechanize' => '0'
  },
  'VERSION' => '20110726',
  'test' => {
    'TESTS' => 't/*.t'
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



