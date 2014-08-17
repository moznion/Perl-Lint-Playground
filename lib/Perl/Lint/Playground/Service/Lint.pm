package Perl::Lint::Playground::Service::Lint;
use strict;
use warnings;
use utf8;
use IO::Pipe;
use JSON::XS qw/encode_json decode_json/;
use Perl::Lint;
use Perl::Lint::Playground::Constants;

sub lint {
    my ($src) = @_;

    # TODO syntax check;

    my $violations;

    my $pipe = IO::Pipe->new;

    my $pid = fork;
    die "Cannot fork: $!" unless defined $pid;
    if ($pid) {
        wait;

        if ($? != 0) { # When SEGV, ABRT and etc...
            return ([], FAIL);
        }

        $pipe->reader;
        $violations = decode_json($_ = <$pipe>);
    }
    else {
        my $lint = Perl::Lint->new;
        $pipe->writer;
        print $pipe encode_json($lint->lint_string($src)) . "\n";
        exit;
    }

    my @violations = sort {$a->{line} <=> $b->{line}} @$violations;

    return (\@violations, SUCCESS);
}

1;

