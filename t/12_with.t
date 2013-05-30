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

my @roles = qw/
    StrictSequenced
    Sequenced
    AllowExtra
    NoThrow
    Croak
/;
for (@roles) {
    isa_ok $v->with($_), 'Data::Validator::Amon2';
}


done_testing;
