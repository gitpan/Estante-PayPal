package Estante::PayPal::Simple::Account;
use Moose;
use Estante::PayPal;
use Carp;

has adaptive_account => (
    is      => 'rw',
    isa     => 'Estante::PayPal::AdaptiveAccount',
    default => sub { Estante::PayPal::AdaptiveAccount->new },
);

has id => (
    is      => 'rw',
    isa     => 'Str',
    clearer => 'clear_id',
    default => '',
);

has paypal => (
    is  => 'rw',
    isa => 'Estante::PayPal',
);

sub BUILD {
    my ( $self, $config ) = @_;
    croak 'Estante::PayPal::Simple::Account->new( $config ) $config not defined'
        unless $config;
    $self->paypal( Estante::PayPal->new($config) );
}

sub create {
    my ( $self, $acc_detail ) = @_;
    $self->adaptive_account( $self->paypal->adaptive_account );
    $acc_detail = $self->paypal->set_defaults( 'adaptive_account_create', $acc_detail );

    # default params.
    $acc_detail->{registrationType} = 'WEB'
        unless defined( $acc_detail->{registrationType} );
    $acc_detail->{citizenshipCountryCode} = 'BZ'
        unless defined( $acc_detail->{citizenshipCountryCode} );
    $acc_detail->{currencyCode} = 'BRL'
        unless defined( $acc_detail->{currencyCode} );

    #   $self->cleanup;
    $self->adaptive_account->create_account($acc_detail);
    $self->id( $self->adaptive_account->response->{accountId} )
        if $self->adaptive_account->is_success
            and defined $self->adaptive_account->response->{accountId};
    return $self->adaptive_account;
}

sub get_verified_status {
    my ( $self, $args ) = @_;
    $self->adaptive_account( $self->paypal->adaptive_account );
    $args = $self->paypal->set_defaults( 'adaptive_account_get_verified_status', $args );
    $self->adaptive_account->get_verified_status($args);
    return $self->adaptive_account;
}

sub cleanup {
    my ($self) = @_;
    $self->clear_id;
}

=head1 NAME

Estante::PayPal::Simple::Account

=head1 SYNOPSIS

use utf8;
use Estante::PayPal::Simple::Account;

my $account = Estante::PayPal::Account->new;
my $acc_detail = {
    emailAddress    => 'sell1_1309460084_biz@gmail.com',
    dateOfBirth     => '1980-05-15',
    name            => {
        firstName => 'Joao',
        lastName  => 'Silva',
    },
    address => {
        line1       => 'Street Faria Lima 992',
        line2       => '-',
        city        => 'Sao paulo',
        state       => 'SP',
        postalCode  => '04364-020',
        countryCode => 'BR',
    },
    contactPhoneNumber      => '11-9982-3827',
    createAccountWebOptions => {
        returnUrl => 'http://www.google.com',
    },
};

my $acc = $account->create( $acc_detail );

warn $acc->is_success;   #indicates paypal received your request.
warn $acc->response_raw; #display raw response
warn $acc->status;       #show account creation status (CREATED or COMPLETED)

=head1 DESCRIPTION

Create accounts easier.

=head1 METHODS

=head2 create

The CreateAccount API operation enables you to create a PayPal account on
behalf of a third party.

=head2 get_verified_status

The GetVerifiedStatus API operation lets you check if a PayPal account status
is verified. A PayPal account gains verified status under a variety of
circumstances, such as when an account is linked to a verified funding source.
Verified status serves to indicate a trust relationship. For more information
about account verified status, refer to PayPal.com.

=head1 ACCOUNT PARAMETERS

=head2 createAccountWebOptions (Required)

The URL to which the business redirects the PayPal user for
PayPal account setup completion.

    createAccountWebOptions => {
        returnUrl => 'http://www.website.com.br/user_page',
    },

=head2 registrationType (Optional)

Whether the PayPal account holder will use a mobile device or the
web to complete registration. This attribute determines whether a key or a
URL is returned for the redirect URL. Allowable values are:

    Mobile - Returns a key (default)
    Web - Returns a URL

=head2 OBS

Apparently for security reasons, paypal does not let you search users details.
You can search for a valid match of email+firstname+lastname
Its not possible to search any other user info. ( not possible to search CEP )

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

