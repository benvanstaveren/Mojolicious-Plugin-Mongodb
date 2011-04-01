package Mojolicious::Plugin::Mongodb;
use warnings;
use strict;
use version;
use Mojo::Base 'Mojolicious::Plugin';
use MongoDB;

our $VERSION = qv(0.04);

sub register {
    my $self = shift;
    my $app  = shift;
    my $conf = shift || {}; 

    $conf->{helper} ||= 'db';

    $app->attr('defaultdb' => sub { delete($conf->{'database'}) || undef });
    $app->attr('connection' => sub { MongoDB::Connection->new($conf) });
    $app->helper($conf->{helper} => sub {
        my $self = shift;
        my $db   = shift || $self->app->defaultdb;
        return ($db) ? $self->app->connection->get_database($db) : undef;
    });
    $app->helper('coll' => sub {
        my $self = shift;
        my $coll = shift;
        my $db   = shift || $self->app->defaultdb;

        return undef unless($db && $coll);
        return $self->app->connection->get_database($db)->get_collection($coll);
    });
}

1; 
__END__
=head1 NAME

Mojolicious::Plugin::Mongodb - Use MongoDB in Mojolicious

=head1 VERSION

Version 0.04

=head1 SYNOPSIS

Provides a few helpers to ease the use of MongoDB in your Mojolicious application.

    use Mojolicious::Plugin::Mongodb

    sub startup {
        my $self = shift;
        $self->plugin('mongodb', { 
            host => 'localhost',
            port => 27017,
            database => 'default_database',
            helper => 'db',
            });
    }

=head1 CONFIGURATION OPTIONS

All options passed to the plugin are used to connect to MongoDB, with the exception of the optional 'database' argument; if you pass the 'database' argument, this will be your default database which you will access using the helper you specified. The default name for the helper is 'db'.

=head1 HELPERS/METHODS

=head2 connection

This plugin attribute holds the MongoDB::Connection object, use this if you need to access it for some reason. 

=head2 db([dbname]) (or if you've given it another name using the 'helper' argument to the plugin method, use that)

This helper will return the database you specify, if you don't specify one, then the default database is returned. If no default has been set and you have not specified a database name, undef will be returned.

    sub someaction {
        my $self = shift;

        # select a database yourself
        $self->db('my_snazzy_database')->get_collection('foo')->insert({ bar => 'baz' });

        # if you passed 'my_snazzy_database' during plugin load as the default, this is equivalent:
        $self->db->get_collection('foo')->insert({ bar => 'baz' });

        # if you want to be anal retentive about things in case no default exists and no database was passed:
        $self->db and $self->db->get_collection('foo')->insert({ bar => 'baz' });
    }

=head2 coll(collname, [dbname])

This helper allows easy access to a collection. If you don't pass the dbname argument, it will return the given collection inside the default database.


    sub someaction {
        my $self = shift;

        # get the 'foo' collection in the default database
        my $collection = $self->coll('foo');

        # get the 'bar' collection in the 'baz' database
        my $collection = $self->coll('bar', 'baz');
    }


=head1 AUTHOR

Ben van Staveren, C<< <madcat at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-mojolicious-plugin-mongodb at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Mojolicious-Plugin-Mongodb>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 CONTRIBUTING

If you want to contribute changes or otherwise involve yourself in development, feel free to fork the Mercurial repository from
L<http://bitbucket.org/xirinet/mojolicious-plugin-mongodb/>.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Mojolicious::Plugin::Mongodb


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Mojolicious-Plugin-Mongodb>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Mojolicious-Plugin-Mongodb>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Mojolicious-Plugin-Mongodb>

=item * Search CPAN

L<http://search.cpan.org/dist/Mojolicious-Plugin-Mongodb/>

=back


=head1 ACKNOWLEDGEMENTS

Based on Mojolicious::Plugin::Database because I don't want to leave the MongoDB crowd in the cold.

Thanks to Henk van Oers for pointing out a few errors in the documentation, and letting me know I should really fix the MANIFEST

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Ben van Staveren.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut
