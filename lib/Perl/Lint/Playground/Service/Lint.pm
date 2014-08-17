package Perl::Lint::Playground::Service::Lint;
use strict;
use warnings;
use utf8;
use JSON::XS qw/encode_json decode_json/;
use Perl::Lint;
use Perl::Lint::Playground::Constants;

sub lint {
    my ($src) = @_;

    # TODO syntax check;

    pipe(READH, WRITEH);
    select(WRITEH); $|=1;
    select(STDOUT);

    my $violations;

    my $pid = fork;
    die "Cannot fork: $!" unless defined $pid;
    if ($pid) {
        wait;

        return ([], FAIL) if $? != 0; # When SEGV, ABRT and etc...

        $violations = decode_json($_ = <READH>);
    }
    else {
        my $lint = Perl::Lint->new;
        print WRITEH encode_json($lint->lint_string($src)) . "\n";
        close WRITEH;
        close READH;
        exit;
    }

    my @violations = sort {$a->{line} <=> $b->{line}} @$violations;

    return (\@violations, SUCCESS);
}

1;

