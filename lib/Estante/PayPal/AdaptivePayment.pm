package Estante::PayPal::AdaptivePayment;

use Moose;
extends 'Estante::PayPal::Adaptive';

has '+adaptive_zone' => ( default => 'adaptive_payments' );

has paykey => (    #AP-...
    is  => 'rw',
    isa => 'Str',
);

has preapproval_key => (    #PA-....
    is  => 'rw',
    isa => 'Str',
);

has payment_exec_status => (
    is  => 'rw',
    isa => 'Any',
);

has status => (
    is  => 'rw',
    isa => 'Any',
);

has pay_error_list => (
    is  => 'rw',
    isa => 'Any',
);

has default_funding_plan => (
    is  => 'rw',
    isa => 'Any',
);

has action_type => (
    is  => 'rw',
    isa => 'Any',
);

has cancel_url => (
    is  => 'rw',
    isa => 'Any',
);

has currency_code => (
    is  => 'rw',
    isa => 'Any',
);

has ipn_notification_url => (
    is  => 'rw',
    isa => 'Any',
);

has memo => (
    is  => 'rw',
    isa => 'Any',
);

has payment_info_list => (
    is  => 'rw',
    isa => 'Any',
);

has return_url => (
    is  => 'rw',
    isa => 'Any',
);

has sender_email => (
    is  => 'rw',
    isa => 'Any',
);

has tracking_id => (
    is  => 'rw',
    isa => 'Any',
);

has fees_payer => (
    is  => 'rw',
    isa => 'Any',
);

has reverse_all_parallel_payments_on_error => (
    is  => 'rw',
    isa => 'Any',
);

has funding_constraint => (
    is  => 'rw',
    isa => 'Any',
);

has sender => (
    is  => 'rw',
    isa => 'Any',
);

sub pay {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('pay');
    $self->execute($params);
    if ( exists $self->response->{responseEnvelope}->{ack}
        and $self->response->{responseEnvelope}->{ack} eq 'Success' )
    {

        $self->paykey( $self->response->{payKey} )
            if exists $self->response->{payKey};

        $self->payment_exec_status( $self->response->{paymentExecStatus} )
            and $self->status( $self->payment_exec_status )
            if exists $self->response->{paymentExecStatus};

        $self->pay_error_list( $self->response->{payErrorList} )
            if exists $self->response->{payErrorList};

        $self->default_funding_plan( $self->response->{defaultFundingPlan} )
            if exists $self->response->{defaultFundingPlan};

    }
}

sub currency_conversion {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('currency_conversion');
    $self->execute($params);
}

sub pay_details {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('pay_details');
    $self->execute($params);
    if ( exists $self->response->{responseEnvelope}->{ack}
        and $self->response->{responseEnvelope}->{ack} eq 'Success' )
    {

        $self->paykey( $self->response->{payKey} )
            if exists $self->response->{payKey};

        $self->action_type( $self->response->{actionType} )
            if exists $self->response->{actionType};

        $self->cancel_url( $self->response->{cancelURL} )
            if exists $self->response->{cancelURL};

        $self->currency_code( $self->response->{currencyCode} )
            if exists $self->response->{currencyCode};

        $self->ipn_notification_url( $self->response->{ipnNotificationUrl} )
            if exists $self->response->{ipnNotificationUrl};

        $self->memo( $self->response->{memo} )
            if exists $self->response->{memo};

        $self->payment_info_list( $self->response->{paymentInfoList} )
            if exists $self->response->{paymentInfoList};

        $self->return_url( $self->response->{returnUrl} )
            if exists $self->response->{returnUrl};

        $self->sender_email( $self->response->{senderEmail} )
            if exists $self->response->{senderEmail};

        $self->status( $self->response->{status} )
            if exists $self->response->{status};

        $self->tracking_id( $self->response->{trackingId} )
            if exists $self->response->{trackingId};

        $self->fees_payer( $self->response->{feesPayer} )
            if exists $self->response->{feesPayer};

        $self->reverse_all_parallel_payments_on_error( $self->response->{reverseAllParallelPaymentsOnError} )
            if exists $self->response->{reverseAllParallelPaymentsOnError};

        $self->preapproval_key( $self->response->{preapprovalKey} )
            if exists $self->response->{preapprovalKey};

        $self->funding_constraint( $self->response->{fundingConstraint} )
            if exists $self->response->{fundingConstraint};

        $self->sender( $self->response->{sender} )
            if exists $self->response->{sender};

    }
}

sub preapproval {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('preapproval');
    $self->execute($params);

    $self->preapproval_key( $self->response->{preapprovalKey} )
        if exists $self->response->{preapprovalKey} and $self->ack eq 'Success';
}

sub preapproval_canceled {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('preapproval_canceled');
    $self->execute($params);
}

sub preapproval_details {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('preapproval_details');
    $self->execute($params);
}

sub refund {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('refund');
    $self->execute($params);
}

sub execute_payment {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('execute_payment');
    $self->execute($params);
}

sub get_payment_options {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('get_payment_options');
    $self->execute($params);
}

sub set_payment_options {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('set_payment_options');
    $self->execute($params);
}

sub get_funding_plans {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('get_funding_plans');
    $self->execute($params);
}

sub get_shipping_address {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('get_shipping_address');
    $self->execute($params);
}

=head1 NAME

Estante::PayPal::AdaptivePayment

=head1 SYNOPSIS

  use Estante::PayPal::AdaptivePayment;

=head1 DESCRIPTION

  This module is an implementation of: PayPal - Adaptive Payment API

  PDF: https://cms.paypal.com/cms_content/US/en_US/files/developer/PP_AdaptivePayments.pdf
  HTML: https://www.x.com/community/ppx/adaptive_payments
  SANDBOX: https://developer.paypal.com/

  TEST  | PayPal API          | Item
  ---------------------------------------------------------
  OK    | AdaptivePayments    | Pay
  OK    | AdaptivePayments    | PaymentDetails
  OK    | AdaptivePayments    | ExecutePayments
  OK    | AdaptivePayments    | GetPaymentOptions
  OK    | AdaptivePayments    | SetPaymentOptions
  OK    | AdaptivePayments    | Preapproval
  OK    | AdaptivePayments    | PreapprovalDetails
  OK    | AdaptivePayments    | CancelPreapproval
  OK    | AdaptivePayments    | Refund
  OK    | AdaptivePayments    | ConvertCurrency
  OK    | AdaptivePayments    | GetFundingPlans
  OK    | AdaptivePayments    | GetShippingAddress

=head1 USAGE

=head1 PAYPAL ADAPTIVE PAYMENT METHOD RESPONSES

=head2 method: pay response


response->{payKey}
response->{paymentExecStatus}
response->{payErrorList}        #array/list of ->{PayError} errors
response->{defaultFundingPlan}  #lots of info, use Dumper to see.or use pdfdocu.
response->{responseEnvelope}->{timestamp};
response->{responseEnvelope}->{ack};
response->{responseEnvelope}->{correlationId};
response->{responseEnvelope}->{build};


Pay response field highlights:

Everytime you execute a payment request, paypal will respond with some
of the following fields:

Response Field    | Meaning
-------------------------------------------------------------------------------
payKey            | Indentify payment
payErrorList      | Why payment failed information
paymentExecStatus | Payment status:
                  | - CREATED: payment request was received. Funds will be
                  |   transfered when payment is approved.
                  | - COMPLETED: payment was successful
                  | - INCOMPLETE: some transf failed and some succeeded, or,
                  |   secondary receivers have not been paid
                  | - ERROR: payment failed or complete transfers were reversed
                  | - REVERSALERROR: transfers failed while reverse payment
                  | - PROCESSING: payment in progress
                  | - PENDING: waiting processing
payError          | Indicates the error if any that resulted from an attempt to
                  |   pay a receiver



=head1 METHODS

=head2 paykey

Identifie a payment. Its a token generated by the paypal api after the pay
request. This paykay can be used in other adaptive payment methods. As well as
the cancelUrl and returnUrl to idenfify this payment.

*** paykey is valid for 3 hours ***

=head2 preapproval_key

Identifies the preapproval for this payment. This key can be used in other
adaptive payment methods to identify the preapproval.

=head2 payment_exec_status

Status of the payment. Possible values are:

 - CREATED: payment request was received. Funds will be
   transfered when payment is approved.
 - COMPLETED: payment was successful
 - INCOMPLETE: some transf failed and some succeeded, or,
   secondary receivers have not been paid
 - ERROR: payment failed or complete transfers were reversed
 - REVERSALERROR: transfers failed while reverse payment
 - PROCESSING: payment in progress
 - PENDING: waiting processing

=head2

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

