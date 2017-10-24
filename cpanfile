requires 'Proclet';
requires 'Starlet';
requires 'Plack';
requires 'Plack::Loader';
requires 'JSON';
requires 'TheSchwartz::Simple';
requires 'DBI';
requires 'DBI::DBD';
requires 'DBD::mysql';

# submodules
do $_ for <./*/cpanfile>;
