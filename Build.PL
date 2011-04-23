use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Mojolicious::Plugin::Mongodb',
    license             => 'perl',
    dist_author         => q{Ben van Staveren <madcat@cpan.org>},
    dist_version_from   => 'lib/Mojolicious/Plugin/Mongodb.pm',
    dist_abstract       => q{Access MongoDB easily from your Mojolicious apps},
    configure_requires  => {
        'Module::Build'     =>  '0.38',
    },
    build_requires      => {
        'Test::More'        =>  0,
        'Test::Mojo'        =>  0,
    },
    requires            =>  {
        'Mojolicious'       =>  '1.21',
        'MongoDB'           =>  '0.42',
    },
    add_to_cleanup      => [ 'Mojolicious-Plugin-Mongodb-*' ],
);
$builder->create_build_script();
