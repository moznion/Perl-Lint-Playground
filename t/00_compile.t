use strict;
use warnings;
use Test::More;


use Perl::Lint::Playground;
use Perl::Lint::Playground::Web;
use Perl::Lint::Playground::Web::View;
use Perl::Lint::Playground::Web::ViewFunctions;

use Perl::Lint::Playground::DB::Schema;
use Perl::Lint::Playground::Web::Dispatcher;


pass "All modules can load.";

done_testing;
