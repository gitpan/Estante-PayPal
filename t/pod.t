
use Test::More;
use strict;

eval "use Test::Pod::Coverage 1.00";
plan skip_all => "Test::Pod::Coverage 1.00 required for testing POD coverage" if $@ or !$ENV{'AUTHOR_POD'};
all_pod_coverage_ok();

