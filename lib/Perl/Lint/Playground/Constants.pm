package Perl::Lint::Playground::Constants;
use strict;
use warnings;
use utf8;
use parent "Exporter";
our @EXPORT = qw/SUCCESS FAIL/;

use constant {
    SUCCESS => 1,
    FAIL    => -1,
};

1;

