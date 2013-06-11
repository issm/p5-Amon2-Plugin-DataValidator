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
use Plack::Test;
use Test::Requires {
    'HTTP::Message' => '6.06',
};
use Plack::Request;
use HTTP::Request::Common;

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

subtest 'arg is-a Plack::Request' => sub {
    my $app = sub {
        my $env = shift;
        my $req = Plack::Request->new($env);
        my $v = $c->new_validator(
            foobar => { isa => 'Int' },
        )->with('NoThrow');
        $v->validate($req);

        if ( $v->has_errors ) {
            return [ 500, [ 'Content-Type' => 'text/plain' ], [ 'validation failed' ] ];
        }
        return [ 200, [ 'Content-Type' => 'text/plain' ], [ 'validation passed' ] ];
    };

    test_psgi $app, sub {
        my $cb = shift;
        my ($req, $res);

        $req = GET '/';
        $res = $cb->($req);
        is $res->code, 500;

        $req = GET '/?foobar=123';
        $res = $cb->($req);
        is $res->code, 200;
    };
};

subtest 'arg is-a Plack::Request, includes file uploads' => sub {
    my $app = sub {
        my $env = shift;
        my $req = Plack::Request->new($env);
        my $v = $c->new_validator(
            foo   => { isa => 'Int' },
            file1 => { isa => 'Plack::Request::Upload' },
            file2 => { isa => 'Plack::Request::Upload' },
        )->with('NoThrow');
        $v->validate($req);

        if ( $v->has_errors ) {
            return [ 500, [ 'Content-Type' => 'text/plain' ], [ 'validation failed' ] ];
        }
        return [ 200, [ 'Content-Type' => 'text/plain' ], [ 'validation passed' ] ];
    };

    test_psgi $app, sub {
        my $cb = shift;
        my ($req, $res);
        my $basedir = $c->base_dir();

        my $file1 = "$basedir/t/data/file1";
        my $file2 = "$basedir/t/data/file2";

        $req = POST(
            '/',
            'Content-Type' => 'multipart/form-data',
            'Content' => [ foo => 1 ],
        );
        $res = $cb->($req);
        is $res->code, 500;

        $req = POST(
            '/',
            'Content-Type' => 'multipart/form-data',
            'Content' => [ foo => 1, file1 => [ $file1 ] ],
        );
        $res = $cb->($req);
        is $res->code, 500;

        $req = POST(
            '/',
            'Content-Type' => 'multipart/form-data',
            'Content' => [ foo => 1, file1 => [ $file1 ], file2 => [ $file2 ] ],
        );
        $res = $cb->($req);
        is $res->code, 200;
    };
};

done_testing;
