package Perl::Lint::Playground::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Log::Minimal;
use Amon2::Web::Dispatcher::RouterBoom;
use Perl::Lint::Playground::Service::Lint;
use Perl::Lint::Playground::Web::M::SourceCodes;

get '/' => sub {
    my ($c) = @_;

    my $src = <<'...';
use strict;
use warnings;

print "Hello, world!!";

eval 'I am evil!';
...

    if (my $id = $c->req->param('id')) {
        my $source_codes = Perl::Lint::Playground::Web::M::SourceCodes->new(id => $id);
        $src = $source_codes->get_src();
        if (not defined $src) {
            $c->res_404();
        }
    }

    return $c->render('index.tx', {src => $src});
};

post '/api/lint' => sub {
    my ($c) = @_;

    my $src = $c->req->param('src');
    return $c->render_json(Perl::Lint::Playground::Service::Lint::lint($src));
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

