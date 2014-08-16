package Perl::Lint::Playground::Web::M::SourceCodes;
use strict;
use warnings;
use utf8;
use Digest::SHA1 qw/sha1_hex/;
use Perl::Lint::Playground;

use Mouse;

has c => (
    is   => 'ro',
    lazy => 1,
    default => sub {
        Perl::Lint::Playground->context;
    },
);

has src => (
    is  => 'ro',
    isa => 'Str',
);

has id => (
    is   => 'ro',
    isa  => 'Str',
    lazy => 1,
    default => sub {
        my $self = shift;

        my $src = $self->src;
        if (not defined $src) {
            return;
        }
        return sha1_hex($self->src);
    }
);

no Mouse;

sub get_src {
    my ($self) = @_;

    if (my $src = $self->src) {
        return $src;
    }

    my $dbh = $self->c->db;
    return $dbh->select_one('SELECT src from source_codes WHERE id = ?', $self->id);
}

sub save {
    my ($self) = @_;

    my $dbh = $self->c->db;

    my $id  = $self->id;
    my $src = $self->src;

    if (!defined($id) || !defined($src)) {
        die "Some arguments are lacked";
    }

    if ($dbh->select_one('SELECT id from source_codes WHERE id = ?', $id)) {
        return; # already registered
    }

    my $sql = <<'...';
INSERT INTO source_codes
(id, src) VALUES (?, ?)
...
    $self->c->db->query($sql, $id, $src);
}

1;

