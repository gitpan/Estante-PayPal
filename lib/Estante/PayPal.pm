package Estante::PayPal;
use Moose;
use Estante::PayPal::AdaptiveAccount;
use Estante::PayPal::AdaptivePayment;
use Config::Any;

use Carp;

our $VERSION = '0.01';

has api_username => (
    is       => 'rw',
    isa      => 'Str',
    default  => '',
    required => 1,
);

has api_password => (
    is       => 'rw',
    isa      => 'Str',
    default  => '',
    required => 1,
);

has signature => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

has x_id => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

has sandbox => (
    is      => 'rw',
    isa     => 'Int',
    default => 1,
);

has sandbox_email => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

has device_ip => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

has adaptive_account => (
    is       => 'ro',
    isa      => 'Estante::PayPal::AdaptiveAccount',
    init_arg => undef,
    lazy     => 1,
    default  => sub { Estante::PayPal::AdaptiveAccount->new },
);

has adaptive_payment => (
    is       => 'ro',
    isa      => 'Estante::PayPal::AdaptivePayment',
    lazy     => 1,
    init_arg => undef,
    default  => sub { Estante::PayPal::AdaptivePayment->new },
);

has config => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} },
);

sub BUILD {
    my ( $self, $args ) = @_;

    if (   !exists $args->{defaults}
        and exists $args->{config_default}
        and -e $args->{config_default} )
    {
        my $config = Config::Any->load_files( { files => [ $args->{config_default} ], use_ext => 1 } );
        $args->{defaults} = $config->[0]->{ $args->{config_default} }->{defaults};
    }

    $self->config($args);
    $self->adaptive_payment->iface_config( $self->iface_config );
    $self->adaptive_account->iface_config( $self->iface_config );
}

sub iface_config {
    my ($self) = @_;
    return {
        api_username => $self->api_username,
        api_password => $self->api_password,
        signature    => $self->signature,

        #       api_endpoint  => $self->api_endpoint,
        x_id          => $self->x_id,
        device_ip     => $self->device_ip,
        sandbox_email => $self->sandbox_email,
    };
}

sub set_defaults {
    my ( $self, $method, $args ) = @_;
    if ( exists $self->config->{defaults}->{$method} ) {
        my $defaults = $self->config->{defaults}->{$method};
        foreach my $k ( keys %$defaults ) {
            if ( !exists $args->{$k} ) {
                $args->{$k} = $defaults->{$k};
            }
        }
    }
    return $args;
}

=head1 NAME

Estante::PayPal

=head1 SYNOPSIS

  use Estante::PayPal;


=head1 DESCRIPTION

This module implements PayPal Adaptive API

=head1 USAGE

=head1 BUGS

http://git.aware.com.br/estante-paypal/trac.cgi

=head1 SUPPORT

http://www.aware.com.br

=head1 AUTHOR

Aware TI.

=head1 COPYRIGHT

(c) 2011 Aware TI.

=head1 SEE ALSO

perl(1).

=cut

#################### main pod documentation end ###################

1;

# The preceding line will help the module return a true value

