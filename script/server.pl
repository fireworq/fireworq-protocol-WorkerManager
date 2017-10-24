#!/usr/bin/env perl
use strict;
use warnings;

use Getopt::Long;
use Proclet;
use Plack::Loader;

GetOptions(
    'web-host=s'        => \my $web_host,
    'web-port=i'        => \my $web_port,
    'web-max-workers=i' => \my $web_max_workers,
    'queue-db=s'        => \my $queue_db,
    'queue-host=s'      => \my $queue_host,
    'queue-port=s'      => \my $queue_port,
    'queue-user=s'      => \my $queue_user,
    'queue-password=s'  => \my $queue_pass,
);

$web_host //= 0;
$web_port //= 8080;
$web_max_workers //= 256;
$queue_db //= 'theschwartz';
$queue_host //= '127.0.0.1';
$queue_port //= '3306';
$ENV{'THESCHWARTZ_DSN'} = "dbi:mysql:database=${queue_db};host=${queue_host};port=${queue_port}";
$ENV{'THESCHWARTZ_USER'} = $queue_user // 'root';
$ENV{'THESCHWARTZ_PASSWORD'} = $queue_pass // '';

my $server = Proclet->new(color => 1);
$server->service(
    tag  => 'web',
    code => sub {
        my $loader = Plack::Loader->load(
            'Starlet',
            port        => $web_port,
            host        => $web_host,
            max_workers => $web_max_workers,
        );
        $loader->run(do './script/app.psgi');
    },
);

$server->run;