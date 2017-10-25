package Fireworq::Launcher;
use strict;
use warnings;

use parent qw(TheSchwartz::Worker);
use Furl;
use JSON qw(encode_json decode_json);

sub max_retries {
    my ($class, $job) = @_;
    return $job->arg->{max_retries};
}

sub work {
    my ($class, $job) = @_;

    my $url = $job->arg->{url};
    my $payload = $job->arg->{payload};
    my $timeout = $job->arg->{timeout} || 31536000;

    # Ignore `retry_delay` because there is no way to specify per job setting.

    my $ua = Furl->new(timeout => $timeout);
    my $res = $ua->post(
        $url,
        [ 'Content-Type' => 'application/json' ],
        encode_json($payload),
    );

    $res->is_success or do {
        $job->failed(sprintf '%d: %s', $res->code, $res->content);
        return;
    };

    my $content = eval { decode_json($res->content) } // {};
    $content->{status} eq 'permanent-failure' and do {
        $job->permanent_failure(sprintf '%d: %s', $res->code, $res->content);
        return;
    };
    $content->{status} eq 'success' or do {
        $job->failed(sprintf '%d: %s', $res->code, $res->content);
        return;
    };


    $job->completed;
}

1;
__END__
