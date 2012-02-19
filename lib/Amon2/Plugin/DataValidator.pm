package Amon2::Plugin::DataValidator;
use strict;
use warnings;
use Data::Validator;

our $VERSION = '0.01';

sub init {
    my ($class, $context_class, $config) = @_;
    no strict 'refs';
    *{"$context_class\::new_validator"} = \&_new_validator;
}

sub _new_validator {
    my ($self, %params) = @_;
    return Data::Validator->new(%params);
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
