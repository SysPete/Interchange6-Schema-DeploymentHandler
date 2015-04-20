use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'Interchange6::Schema::DeploymentHandler',
    AUTHOR             => q{Peter Mottram (SysPete) <peter@sysnix.com>},
    VERSION_FROM       => 'lib/Interchange6/Schema/DeploymentHandler.pm',
    ABSTRACT_FROM      => 'lib/Interchange6/Schema/DeploymentHandler.pm',
    LICENSE            => 'Perl_5',
    PL_FILES           => {},
    MIN_PERL_VERSION   => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Class::Load' => 0,
        'Test::More'  => 0,
    },
    PREREQ_PM => {
        'DBIx::Class::DeploymentHandler' => 0,
        'DBIx::Class::Schema::Config'    => 0,
        'FindBin'                        => 0,
    },
    dist => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Interchange6-Schema-DeploymentHandler-*' },
);
