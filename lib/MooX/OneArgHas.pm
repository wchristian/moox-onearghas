use strictures;

package MooX::OneArgHas;

use Scalar::Util 'blessed';

our $VERSION = '1.000000';
$VERSION = eval $VERSION;

sub import {
    my ( $class ) = @_;
    
    my $target = caller;
    my $has    = $target->can( 'has' );
    return if !$has;
    
    no strict 'refs';
    no warnings 'redefine';
    
    *{ $target . '::has' } = sub {
        $has->( process_has( $target, @_ ) );
    };
    
    return;
}

sub process_has {
    my ( $target, $name, $arg, @opts ) = @_;

    return ( $name, $arg, @opts )
      if ref $arg ne 'CODE'
          and !( blessed( $arg ) and eval { \&{$arg} } );

    die "Accessor '$target\::$name' cannot take further arguments." if @opts;

    return ( $name, is => 'ro', builder => $arg );
}

1;

=head1 NAME

MooX::OneArgHas - create Moo attributes with minimum fuss

=head1 SYNOPSIS

  package My;
  use Moo;
  use MooX::OneArgHas;
  has foo => sub { 'foo' };

is equivalent to:

  package My;
  use Moo;
  has foo => ( is => 'ro', builder => sub { 'foo' });

=head1 DESCRIPTION

Sometimes all you need is a few simple read-only accessors that merely have a
default. This Moo extension adapts has() to allow this task to be done with the
minimum syntax that can still be considered safe.

If it detects that the args for the accessor creation consist of only a single
code ref, it will expand that into the template shown in the synopsis. Take note
that it will not accept any arguments past the code ref and will die if it
detects such. Further note that the code ref can be a bare code ref, or any
code-convertible object, like the ones Sub::Quote produces.

=head1 AUTHOR

mithaldu - Christian Walde (cpan:MITHALDU) <walde.christian@gmail.com>

=head1 CONTRIBUTORS

None yet - maybe this software is perfect! (ahahahahahahahahaha)

=head1 COPYRIGHT

Copyright (c) 2013 the MooX::OneArgHas L</AUTHOR> and L</CONTRIBUTORS>
as listed above.

=head1 LICENSE

This library is free software and may be distributed under the same terms
as perl itself.
