#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Interchange6::Schema::DeploymentHandler' ) || print "Bail out!\n";
}

diag( "Testing Interchange6::Schema::DeploymentHandler $Interchange6::Schema::DeploymentHandler::VERSION, Perl $], $^X" );
