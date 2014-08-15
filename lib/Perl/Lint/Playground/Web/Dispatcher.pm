package Perl::Lint::Playground::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;
use Perl::Lint::Playground::Service::Lint;

get '/' => sub {
    my ($c) = @_;
    return $c->render('index.tx', {});
};

post '/api/lint' => sub {
    my ($c) = @_;

    my $src = $c->req->param('src');
    return $c->render_json(Perl::Lint::Playground::Service::Lint::lint($src));
};

1;

