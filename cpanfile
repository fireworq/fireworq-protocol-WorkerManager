requires 'Proclet';
requires 'Starlet';
requires 'Plack';
requires 'Plack::Loader';
requires 'JSON';
requires 'TheSchwartz::Simple';
requires 'DBI';
requires 'DBI::DBD';
requires 'DBD::mysql';
requires 'DBIx::Handler';

# submodules
do $_ for <./*/cpanfile>;
