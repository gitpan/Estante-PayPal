package Estante::PayPal::Agent;
use Moose;

use JSON::XS;
use Carp;
use WWW::Mechanize;

has agent_alias => (
    is      => 'ro',
    isa     => 'Str',
    default => 'Windows IE 6',
);

has response_raw => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

has response => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} },
);

has interface => (
    is      => 'rw',
    isa     => 'WWW::Mechanize',
    lazy    => 1,
    default => sub { WWW::Mechanize->new },
);

has content => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

has status => (
    is      => 'rw',
    isa     => 'Int',
    default => '000',
);

sub BUILD {
    my ($self) = @_;
    $self->interface->agent_alias( $self->agent_alias );
}

sub fetch {
    my ( $self, $url, $config, $content ) = @_;

    my $content_json;
    if ( ref $content eq 'HASH' ) {
        $content_json = encode_json $content;
    }
    else {
        croak "'content' params must be a hashref";
    }

    my $headers = HTTP::Headers->new(
        'X-PAYPAL-SECURITY-USERID'       => $config->{api_username},
        'X-PAYPAL-SECURITY-PASSWORD'     => $config->{api_password},
        'X-PAYPAL-SECURITY-SIGNATURE'    => $config->{signature},
        'X-PAYPAL-APPLICATION-ID'        => $config->{x_id},
        'X-PAYPAL-DEVICE-IPADDRESS'      => '127.0.0.1',
        'X-PAYPAL-SANDBOX-EMAIL-ADDRESS' => $config->{sandbox_email},
        'X-PAYPAL-REQUEST-DATA-FORMAT'   => 'JSON',
        'X-PAYPAL-RESPONSE-DATA-FORMAT'  => 'JSON',
    );

    my $req = HTTP::Request->new( 'POST', $url, $headers, $content_json );
    $self->interface->request($req);
    $self->response_raw( $self->interface->content );
    $self->status( $self->interface->status );

    if ( $self->status == '200' ) {
        $self->response( decode_json $self->interface->content );
    }
}

=head1 NAME

Estante::PayPal::Agent

=head1 SYNOPSIS

  use Estante::PayPal::Agent;

=head1 DESCRIPTION

Responsible to make connections to paypal. Mechanize was chosen.

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

