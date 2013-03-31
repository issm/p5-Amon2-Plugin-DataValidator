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
isa_ok $c, 'Foo';
ok $c->can('validator');
ok $c->can('new_validator');

my $v = $c->new_validator( foo => 'Str' );
isa_ok $v, 'Data::Validator::Filterable';
isa_ok $v->filter_map, 'HASH';


done_testing;
