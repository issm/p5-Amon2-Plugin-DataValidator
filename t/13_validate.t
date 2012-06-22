package Foo;
use strict;
use warnings;
use parent 'Amon2';
__PACKAGE__->load_plugins(qw/
    DataValidator
/);


package main;
use strict;
use warnings;
use Test::More;

my $c = Foo->bootstrap;


subtest 'filter' => sub {
    my $v = $c->new_validator(
        foo => 'Str',
        bar => { isa => 'Str', filter => sub { uc $_[0] } },
    );
    my $q = $v->validate(
        foo => 'hoge',
        bar => 'fuga',
    );

    is $q->{foo}, 'hoge';
    is $q->{bar}, 'FUGA';
};


done_testing;
