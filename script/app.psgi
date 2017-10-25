#!/usr/bin/env plackup
use strict;
use warnings;

use Plack::Request;
use JSON qw(decode_json);
use DBIx::Handler;
use TheSchwartz::Simple;
use TheSchwartz::Simple::Job;

my $dsn = $ENV{THESCHWARTZ_DSN};
my $user = $ENV{THESCHWARTZ_USER};
my $pass = $ENV{THESCHWARTZ_PASSWORD};

my $db = DBIx::Handler->connect($dsn, $user, $pass, {
    RaiseError => 1,
    PrintError => 0,
    AutoCommit => 1,
});
my $app = sub {
    my ($env) = @_;
    my $req = Plack::Request->new($env);

    $req->path_info =~ qr!\A/job/!
        or return $req->new_response(200)->finalize;

    my $incoming = decode_json($req->raw_body);
    my $url = $incoming->{url} // '';
    my $payload = $incoming->{payload} // {};
    my $run_after = $incoming->{run_after} // 0;
    my $timeout = $incoming->{timeout} // 0;
    my $retry_delay = $incoming->{retry_delay} // 0;
    my $max_retries = $incoming->{max_retries} // 0;

    my $job = TheSchwartz::Simple::Job->new;
    $job->funcname('Fireworq::Launcher');
    $job->arg({
        url         => $url,
        payload     => $payload,
        timeout     => $timeout,
        retry_delay => $retry_delay,
        max_retries => $max_retries,
    });
    $job->run_after(time + $run_after);

    my $client = TheSchwartz::Simple->new([ $db->dbh ]);
    $client->insert($job);

    my $res = $req->new_response(200);
    return $res->finalize;
};

$app;
