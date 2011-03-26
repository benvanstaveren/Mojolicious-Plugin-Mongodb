#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Mojolicious::Plugin::MongoDB' ) || print "Bail out!
";
}

diag( "Testing Mojolicious::Plugin::MongoDB $Mojolicious::Plugin::MongoDB::VERSION, Perl $], $^X" );
