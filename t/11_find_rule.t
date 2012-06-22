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
my $v = $c->new_validator(
    foo => 'Str',
    bar => { isa => 'Str' },
    baz => { isa => 'Str', filter => sub { 1 } },
);

{
    my $r = $v->find_rule('foo');
    isa_ok $r, 'HASH';
    isa_ok $r->{type}, 'Mouse::Meta::TypeConstraint';
    is $r->{name}, 'foo';
    is $r->{type}{name}, 'Str';
};

{
    my $r = $v->find_rule('bar');
    is $r->{name}, 'bar';
    is $r->{type}{name}, 'Str';
};

{
    my $r = $v->find_rule('baz');
    is $r->{name}, 'baz';
    is $r->{type}{name}, 'Str';
};

is $v->find_rule('hoge'), undef;


done_testing;
