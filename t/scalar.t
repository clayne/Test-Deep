use strict;

use Test::More qw(no_plan);

use Test::Deep;

use lib '../Test-Tester/lib';
use Test::Tester;

Test::Deep::builder(Test::Tester::capture());

use Carp qw(confess);

$SIG{__WARN__} = $SIG{__DIE__} = \&confess;

{
	my $a = [];
	check_test(
		sub {
			cmp_deeply($a."", $a);
		},
		{
			actual_ok => 0,
			diag => <<EOM,
Compared \$data
   got : '$a'
expect : $a
EOM
		},
		"stringified ref not eq"
	);

	check_test(
		sub {
			cmp_deeply(undef, "");
		},
		{
			actual_ok => 0,
			diag => <<EOM,
Compared \$data
   got : undef
expect : ''
EOM
		},
		"undef ne ''"
	);

	check_test(
		sub {
			cmp_deeply([$a."", ["b"]], [shallow($a), ["b"]]);
		},
		{
			actual_ok => 0,
			diag => <<EOM,
Compared \$data->[0]
   got : '$a'
expect : $a
EOM
		},
		"shallow not eq"
	);

	check_test(
		sub {
			cmp_deeply([$a, ["b"]], [shallow($a), ["a"]]);
		},
		{
			actual_ok => 0,
			diag => <<EOM,
Compared \$data->[1][0]
   got : 'b'
expect : 'a'
EOM
		},
		"deep after shallow not eq"
	);
}