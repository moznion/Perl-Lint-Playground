package Perl::Lint::Playground;
use strict;
use warnings;
use utf8;
use DBIx::Sunny;
our $VERSION='0.01';
use 5.008001;

use parent qw/Amon2/;
# Enable project local mode.
__PACKAGE__->make_local_context();
__PACKAGE__->load_plugins(qw/Web::JSON/);

sub db {
    my $c = shift;
    if (!exists $c->{db}) {
        my $conf = $c->config->{DBI} or die "Missing configuration about DBI";
        $c->{db} = DBIx::Sunny->connect(@$conf);
    }
    return $c->{db};
}

1;
__END__

=head1 NAME

Perl::Lint::Playground - Perl::Lint::Playground

=head1 DESCRIPTION

This is a main context class for Perl::Lint::Playground

=head1 AUTHOR

Perl::Lint::Playground authors.

