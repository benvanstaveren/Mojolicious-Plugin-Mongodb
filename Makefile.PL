use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Mojolicious::Plugin::Mongodb',
    AUTHOR              => q{Ben van Staveren <madcat@cpan.org>},
    VERSION_FROM        => 'lib/Mojolicious/Plugin/Mongodb.pm',
    ABSTRACT_FROM       => 'lib/Mojolicious/Plugin/Mongodb.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'  => 0,
        'MongoDB'     => 0,
        'Mojolicious' => 0,
        'version'     => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Mojolicious-Plugin-Mongodb-*' },
);
