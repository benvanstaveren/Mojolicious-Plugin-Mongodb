#!/usr/bin/env perl
use strict;
use warnings;

# Disable IPv6, epoll and kqueue
BEGIN { $ENV{MOJO_NO_IPV6} = $ENV{MOJO_POLL} = 1 }

use Test::More;
use Try::Tiny;

if(!$ENV{TEST_MONGODB}) {
    plan skip_all => 'Please set the TEST_MONGODB variable to a MongoDB connection string (host:port) in order to test';
} else {
    plan tests => 3;
}

# testing code starts here
use Mojolicious::Lite;
use Test::Mojo;

my ($host, $port) = split(/:/, $ENV{TEST_MONGODB});
$host ||= 'localhost';
$port ||= 27017;


plugin 'mongodb', { 
    'host'      => $host,
    'port'      => $port,
    'database'  => 'froofypants_' . $$,
    'nohelper'  => 1,
    };

get '/test' => sub {
    my $self = shift;
    my $rv = 0;

    try {
        my $foo = $self->db;
    } catch {
        $rv = 1;
    };
    $self->render(text => ($rv == 1) ? 'ok' : 'fail');
};


my $t = Test::Mojo->new;

$t->get_ok('/test')->status_is(200)->content_is('ok');
