use strict;
use warnings;
use utf8;
use t::Util;
use Perl::Lint::Playground;
use Perl::Lint::Playground::Web::M::SourceCodes;

use Test::More;

Perl::Lint::Playground->bootstrap();

subtest '#save' => sub {
    subtest 'save ok' => sub {
        my $sc = Perl::Lint::Playground::Web::M::SourceCodes->new(src => 'foobar');
        $sc->save;

        is $sc->id, '8843d7f92416211de9ebb963ff4ce28125932878';
        is $sc->c->db->select_one('SELECT src from source_codes WHERE id = ?', $sc->id), 'foobar';
    };

    subtest 'save again, nothing occurs' => sub {
        my $sc = Perl::Lint::Playground::Web::M::SourceCodes->new(src => 'foobar');
        eval { $sc->save };
        ok !$@;
    };

    subtest 'should fail when it given lacked arguments' => sub {
        subtest 'when it with no members' => sub {
            my $sc = Perl::Lint::Playground::Web::M::SourceCodes->new();
            eval { $sc->save };
            ok $@;
        };

        subtest 'when it has only id' => sub {
            my $sc = Perl::Lint::Playground::Web::M::SourceCodes->new(id => 'XXX');
            eval { $sc->save };
            ok $@;
        };
    };
};

subtest '#get_src' => sub {
    subtest 'Should success when instance has already had src' => sub {
        my $sc = Perl::Lint::Playground::Web::M::SourceCodes->new(src => 'foobar');
        $sc->save;
        is $sc->get_src, 'foobar';
    };

    subtest 'Should success when existed ID is specified by different instance' => sub {
        my $sc1 = Perl::Lint::Playground::Web::M::SourceCodes->new(src => 'foobar');
        $sc1->save;

        my $sc2 = Perl::Lint::Playground::Web::M::SourceCodes->new(id => '8843d7f92416211de9ebb963ff4ce28125932878');
        is $sc2->get_src, 'foobar';
    };

    subtest 'Should get nothng when non-existed ID is specified' => sub {
        my $sc = Perl::Lint::Playground::Web::M::SourceCodes->new(id => 'non-existed');
        ok !$sc->get_src;
    };
};

done_testing;

