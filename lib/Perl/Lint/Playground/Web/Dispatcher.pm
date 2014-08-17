package Perl::Lint::Playground::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Log::Minimal;
use Amon2::Web::Dispatcher::RouterBoom;
use Perl::Lint::Playground::Service::Lint;
use Perl::Lint::Playground::Web::M::SourceCodes;
use Perl::Lint::Playground::Constants;

get '/' => sub {
    my ($c) = @_;
    return $c->render('index.tx', {});
};

get '/api/src' => sub {
    my ($c) = @_;

    my $src = undef;
    if (my $id = $c->req->param('id')) {
        my $source_codes = Perl::Lint::Playground::Web::M::SourceCodes->new(id => $id);
        $src = $source_codes->get_src();
        if (not defined $src) {
            my $res = $c->render_json({error => 'Not Found'});
            $res->status(404);
            return $res;
        }
    }

    return $c->render_json({src => $src});
};

post '/api/lint' => sub {
    my ($c) = @_;

    my $src = $c->req->param('src');
    my ($violations, $status) = Perl::Lint::Playground::Service::Lint::lint($src);

    if ($status == FAIL) {
        my $res = $c->render_json({error => '[ERROR] SEGV was occurd when tokenizing the code. It is possibly bug, so please report this!'});
        $res->status(500);
        return $res;
    }

    return $c->render_json($violations);
};

post '/api/share' => sub {
    my ($c) = @_;

    my $src = $c->req->param('src');

    my $source_codes =Perl::Lint::Playground::Web::M::SourceCodes->new(src => $src);
    eval { $source_codes->save() };
    if (my $e = $@) {
        warnf('Failed to save source code: %s', $e);
        my $res = $c->render_json({error => "Failed"});
        $res->status(500);
        return $res;
    }

    return $c->render_json({id => $source_codes->id});
};

1;

