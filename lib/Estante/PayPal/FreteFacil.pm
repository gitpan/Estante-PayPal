
package Estante::PayPal::FreteFacil;

use Moose;

has sandbox => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

has url_api => (
    is         => 'ro',
    init_arg   => undef,
    lazy_build => 1
);

sub _build_url_api {
    my $self = shift;
    return $self->sandbox
        ? 'https://sistemas.homol.fastsolutions.com.br/FretesPayPalWS/WSFretesPayPal?wsdl'
        : 'http://187.8.77.72/FretesPayPalWS/WSFretesPayPal?wsdl';
}

1;

