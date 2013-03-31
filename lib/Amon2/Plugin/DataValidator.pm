use strict;
use warnings;

package Data::Validator::Filterable;
use Mouse;
extends 'Data::Validator';

has filter_map => (
    is  => 'ro',
    isa => 'HashRef',
);

no Mouse;

sub BUILDARGS {
    my ($class, @mapping) = @_;
    my $args = {};
    my %filter_map;
    my @mapping_4_super;
    while ( my ($name, $rule) = splice @mapping, 0, 2 ) {
        if ( ref($rule) eq 'HASH'  &&  ref($rule->{filter}) eq 'CODE' ) {
            $filter_map{$name} = $rule->{filter};
            delete $rule->{filter};
        }
        push @mapping_4_super, $name, $rule;
    }
    $args = $class->SUPER::BUILDARGS(@mapping_4_super);
    $args->{filter_map} = \%filter_map;
    return $args;
}

### override
sub validate {
    my $self = shift;
    my $args = $self->initialize(@_);  # isa Hashref
    my $fm = $self->filter_map;
    for my $k ( keys %$args ) {
        my $f = $fm->{$k};
        next  unless $f && ref($f) eq 'CODE';
        $args->{$k} = $f->($args->{$k});
    }
    return $self->SUPER::validate($args);
}

1;

package Amon2::Plugin::DataValidator;

our $VERSION = '0.02';

sub init {
    my ($class, $context_class, $config) = @_;
    no strict 'refs';
    *{"$context_class\::validator"}     = \&_validator;
    *{"$context_class\::new_validator"} = \&_validator;
}

sub _validator {
    my ($self, %params) = @_;
    return Data::Validator::Filterable->new(%params);
}

1;
__END__

=head1 NAME

Amon2::Plugin::DataValidator -

=head1 SYNOPSIS

  package MyApp;
  use parent 'Amon2';
  __PACKAGE__->load_plugin('DataValidator');


  package anywhere;

  # $c is a context object of MyApp(Amon2)
  my $validator = $c->new_validator(
      foo => { isa => 'Str' },
      bar => { isa => 'Num' },
      baz => { isa => 'Str', filter => { uc $_[0] } },
  );

=head1 DESCRIPTION

Amon2::Plugin::DataValidator is

=head1 AUTHOR

issm E<lt>issmxx@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
