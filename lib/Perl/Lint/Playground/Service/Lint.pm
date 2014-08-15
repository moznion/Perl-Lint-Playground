package Perl::Lint::Playground::Service::Lint;
use strict;
use warnings;
use utf8;
use Perl::Lint;

sub lint {
    my ($src) = @_;

    # TODO syntax check;

    my $lint = Perl::Lint->new;
    my @violations = @{$lint->lint_string($src)};
    @violations = sort {$a->{line} <=> $b->{line}} @violations;

    return \@violations;
}

1;

