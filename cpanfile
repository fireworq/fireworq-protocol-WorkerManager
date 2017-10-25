requires 'Proclet';
requires 'Starlet';
requires 'Plack';
requires 'Plack::Loader';
requires 'JSON';
requires 'YAML::Tiny';
requires 'Furl';
requires 'TheSchwartz::Simple';
requires 'TheSchwartz::Worker';
requires 'DBI';
requires 'DBI::DBD';
requires 'DBD::mysql';
requires 'DBIx::Handler';

# submodules
do $_ for <./*/cpanfile>;
