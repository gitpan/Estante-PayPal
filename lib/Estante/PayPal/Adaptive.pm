package Estante::PayPal::Adaptive;

use Moose;
use Estante::PayPal::Agent;
use Estante::PayPal::API;

has api_endpoint => (
    is  => 'rw',
    isa => 'Str',
);

has sandbox => (
    is      => 'ro',
    isa     => 'Bool',
    default => 1,        # TODO: Change to zero!
);

has api => (
    is       => 'ro',
    init_arg => undef,
    lazy     => 1,
    builder  => '_builder_api'
);

has ack => (
    is      => 'rw',
    isa     => 'Str',
    default => 0,
);

has response => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} },
);

has response_raw => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

has response_envelope => (
    is  => 'rw',
    isa => 'Any',
);

has iface_config => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} },
);

has agent => (
    is      => 'rw',
    isa     => 'Estante::PayPal::Agent',
    default => sub { Estante::PayPal::Agent->new },
);

has adaptive_zone => (
    is      => 'ro',
    isa     => 'Str',
    default => ''
);

has build => (
    is  => 'rw',
    isa => 'Str',
);

has correlation_id => (
    is  => 'rw',
    isa => 'Str',
);

has timestamp => (
    is  => 'rw',
    isa => 'Str',
);

sub _builder_api {
    my $self = shift;
    return Estante::PayPal::API->with_traits('Sandbox')->new if $self->sandbox;
    return Estante::PayPal::API->with_traits('Live')->new;
}

sub cleanup {
    my ($self) = @_;
    $self->api_endpoint('');
    $self->ack('');
    $self->response( {} );
    $self->response_raw('');
}

sub execute {
    my ( $self, $params ) = @_;
    $self->agent->fetch( $self->api_endpoint, $self->iface_config, $params );
    $self->set_response;
}

sub set_response {
    my ($self) = @_;
    $self->response( $self->agent->response );
    $self->response_raw( $self->agent->response_raw );

    $self->response_envelope( $self->response->{responseEnvelope} )
        if ( exists $self->response->{responseEnvelope} );

    $self->ack( $self->response->{responseEnvelope}->{ack} )
        if exists $self->response->{responseEnvelope}->{ack};

    $self->build( $self->response->{responseEnvelope}->{build} )
        if exists $self->response->{responseEnvelope}->{build};

    $self->correlation_id( $self->response->{responseEnvelope}->{correlationId} )
        if exists $self->response->{responseEnvelope}->{correlationId};

    $self->timestamp( $self->response->{responseEnvelope}->{timestamp} )
        if exists $self->response->{responseEnvelope}->{timestamp};
}

sub define_api_endpoint {
    my ( $self, $type ) = @_;
    $self->api_endpoint( $self->api->endpoints->{ $self->adaptive_zone }{$type} );
}

#################### main pod documentation begin ###################self->adaptive_zone}
## Below is the stub of documentation for your module.
## You better edit it!

=head1 NAME

Estante::PayPal::Adaptive

=head1 SYNOPSIS

  use Estante::PayPal::Adaptive;

=head1 DESCRIPTION

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
