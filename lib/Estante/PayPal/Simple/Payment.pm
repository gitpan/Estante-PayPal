package Estante::PayPal::Simple::Payment;
use Moose;
use Estante::PayPal;
use Carp;

has adaptive_payment => (
    is      => 'rw',
    isa     => 'Estante::PayPal::AdaptivePayment',
    default => sub { Estante::PayPal::AdaptivePayment->new },
);

has tracking_id => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

has payments => (
    is      => 'rw',
    isa     => 'ArrayRef',
    default => sub { [] },
);

has return_url => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

has cancel_url => (
    is      => 'rw',
    isa     => 'Str',
    default => '',
);

has paypal => (
    is      => 'rw',
    isa     => 'Estante::PayPal',
);

has total_amount_paid => (
    is      => 'rw',
    isa     => 'Any',
);

sub BUILD {
    my ($self, $config ) = @_;
    croak 'ERROR: Estante::PayPal::Simple::Payment->new( $config ) $config not
    defined' if ! $config;
    $self->paypal( Estante::PayPal->new( $config ) );
}

sub add_payment {
    my ( $self, $item ) = @_;
    push @{ $self->payments }, $item;
}

sub pay {
    my ( $self, $args ) = @_;
    $self->adaptive_payment( $self->paypal->adaptive_payment );
    $args = $self->prepare_pay($args);
    $self->adaptive_payment->pay($args);
}

sub prepare_pay {
    my ( $self, $args ) = @_;
    $args = $self->paypal->set_defaults( 'adaptive_payment_pay', $args); #config Test::EstanteSetup
    $args->{trackingId} = $self->tracking_id
      if !exists $args->{trackingId} and defined $self->tracking_id;
    $args->{cancelUrl} = $self->cancel_url
      if !exists $args->{cancelUrl};
    $args->{returnUrl} = $self->return_url
      if !exists $args->{returnUrl};
    if ( !exists $args->{receiverList}->{receiver} ) {
        $args->{receiverList}->{receiver} = $self->payments;
    }
    return $args;
}



sub pay_details {
    my ( $self, $args ) = @_;
    $self->adaptive_payment( $self->paypal->adaptive_payment );
    $args = $self->prepare_pay_details($args);
    $self->adaptive_payment->pay_details($args);

    if ( $self->adaptive_payment->ack eq 'Success' ) {
        $self->sum_pay_amount()
        if exists $self->adaptive_payment->payment_info_list->{paymentInfo};
    }

}

sub prepare_pay_details {
    my ( $self, $args ) = @_;
    $args = $self->paypal->set_defaults('adaptive_payment_pay_details', $args);
    return $args;
}

sub sum_pay_amount {
    my ( $self ) = @_;
    my $total = 0;
    foreach my $payment (@{ $self->adaptive_payment->payment_info_list->{paymentInfo} } ) {
        $total += $payment->{receiver}->{amount};
    }
    $self->total_amount_paid( $total );
}

sub cleanup {
    my ($self) = @_;
}

=head1 NAME

Estante::PayPal::Payment

=head1 SYNOPSIS

my $payment = Estante::PayPal::Payment->new;
{
    $payment->tracking_id(Test::EstanteSetup-> tracking_id ); #random id
    $payment->add_payment( {
        email => 'sell1_1309460084_biz@gmail.com',
        primary => 'false',
        amount => '0.56',
        memo => 'Livro XYZ v-I',
    } );
    $payment->add_payment( {
        email => 'sell2_1309460084_biz@gmail.com',
        primary => 'false',
        amount => '0.96',
        memo => 'Livro XYZ v-II',
    } );
    $payment->add_payment( {
        email => 'sell3_1309460084_biz@gmail.com',
        primary => 'false',
        amount => '0.73',
        memo => 'Livro XYZ v-III',
    } );
    $payment->cancel_url( 'http:mycancelurl' );
    $payment->return_url( 'http:myreturnurl' );
    $payment->pay( );

    warn 'status:  ' . $payment->adaptive_payment->ack;
    warn 'response:' . $payment->adaptive_payment->response_raw;
}

=head1 DESCRIPTION

=head1 METHODS

=head2 pay

Shortcut for adaptive_payment->pay
Transfers funds from a senders PayPal account to one or more
receivers PayPal accounts (up to 6 receivers)


=head2 tracking_id

You can specify your own unique tracking ID in the trackingID field and use
this value to obtain information about a payment or to request a refund. The
tracking ID is provided as a convenience in cases when you already maintain
an ID that you want to associate with a payment. You can also track payments
using the payKey.

=head2 add_payment

Prepares multiple payments, for multiple emails/persons.

usage example( add multiple payments):
    $payment->add_payment( {
        email => 'sell3_1309460084_biz@gmail.com',
        primary => 'false',                       #OPTIONAL
        amount => '0.73',
        memo => 'Livro XYZ v-III',                #OPTIONAL 1000chars limit
    } );

=head2 cancel_url

The URL to which the senders browser is redirected if the sender cancels the
approval for a payment on paypal.com. Use the pay key to identify the
payment as follows: payKey=${payKey}.

=head2 return_url

The URL to which the senders browser is redirected after approving a
payment on paypal.com. Use the pay key to identify the payment as follows:
payKey=${payKey}.

=head1 PAYMENTS PARAMETERS

=head2 primary (optional)

Whether this receiver is the primary receiver, which makes the
payment a chained payment. You can specify at most one primary receiver.
Omit this field for simple and parallel payments.
Allowable values are:

    true - Primary receiver
    false - Secondary receiver (default)

=head2 memo (optional) 1000 chars limit

A note associated with the payment (text, not HTML).
Maximum length: 1000 characters, including newline characters

=head1 OBS

Apparently paypal will only accept amount+memoi per transfer.

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

