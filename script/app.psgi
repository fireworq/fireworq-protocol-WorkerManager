#!/usr/bin/env plackup
use strict;
use warnings;

use Plack::Request;
use JSON qw(decode_json);
use DBI;
use TheSchwartz::Simple;
use TheSchwartz::Simple::Job;

my $dsn = $ENV{'THESCHWARTZ_DSN'};
my $user = $ENV{'THESCHWARTZ_USER'};
my $pass = $ENV{'THESCHWARTZ_PASSWORD'};

my $dbh = DBI->connect($dsn, $user, $pass, {
    RaiseError => 1,
    PrintError => 0,
    AutoCommit => 1,
});
my $client = TheSchwartz::Simple->new([ $dbh ]);

my $app = sub {
    my ($env) = @_;
    my $req = Plack::Request->new($env);

    my $incoming = decode_json($req->raw_body);
    my $payload = $incoming->{payload} // {};
    my $run_after = $incoming->{run_after} // 0;

    my $job = TheSchwartz::Simple::Job->new;
    $job->funcname('Fireworq::Launcher');
    $job->arg($payload);
    $job->run_after(time + $run_after);

    $client->insert($job);

    my $res = $req->new_response(200);
    return $res->finalize;
};

$app;
