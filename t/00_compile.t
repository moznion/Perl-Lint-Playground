use strict;
use warnings;
use Test::More;
use Path::Tiny;
use File::Find::Rule;

my $lib_dir = path(__FILE__)->realpath->parent->parent->child('lib') . '';
my @files = File::Find::Rule->file()->name('*.pm')->in($lib_dir);

for my $path (@files) {
    $path = path($path)->relative($lib_dir);
    $path =~ s!/!::!g;
    $path =~ s!\.pm$!!g;
    use_ok($path) or die $@;
}

done_testing;

