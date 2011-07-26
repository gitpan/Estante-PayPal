package Estante::PayPal::AdaptiveAccount;

use Moose;
extends 'Estante::PayPal::Adaptive';

has '+adaptive_zone' => ( default => 'adaptive_accounts' );

has account_id => (
    is  => 'rw',
    isa => 'Any',
);

has redirect_url => (
    is  => 'rw',
    isa => 'Any',
);

has create_account_key => (
    is  => 'rw',
    isa => 'Any',
);

has exec_status => (
    is  => 'rw',
    isa => 'Any',
);

has status => (
    is  => 'rw',
    isa => 'Any',
);

has funding_source_key => (
    is  => 'rw',
    isa => 'Any',
);

sub is_success {
    my $self = shift;
    return $self->ack eq 'Success' ? 1 : 0;
}

sub create_account {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('create_account');
    $self->execute($params);

    if ( exists $self->response->{responseEnvelope}->{ack}
        and $self->response->{responseEnvelope}->{ack} eq 'Success' )
    {

        $self->account_id( $self->response->{accountId} )
            if exists $self->response->{accountId};

        $self->redirect_url( $self->response->{redirectURL} )
            if exists $self->response->{redirectURL};

        $self->exec_status( $self->response->{execStatus} )
            and $self->status( $self->exec_status )
            if exists $self->response->{execStatus};

        $self->create_account_key( $self->response->{createAccountKey} )
            if exists $self->response->{createAccountKey};

    }
}

sub add_bank_account {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('add_bank_account');
    $self->execute($params);
    if ( exists $self->response->{responseEnvelope}->{ack}
        and $self->response->{responseEnvelope}->{ack} eq 'Success' )
    {

        $self->funding_source_key( $self->response->{fundingSourceKey} )
            if exists $self->response->{fundingSourceKey};

    }
}

sub get_user_agreement {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('get_user_agreement');
    $self->execute($params);
}

sub add_payment_card {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('add_payment_card');
    $self->execute($params);
}

sub get_verified_status {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('get_verified_status');
    $self->execute($params);
}

sub set_funding_source_confirmed {
    my ( $self, $params ) = @_;
    $self->cleanup;
    $self->define_api_endpoint('set_funding_source_confirmed');
    $self->execute($params);
}

=head1 NAME

Estante::PayPal::AdaptiveAccount

=head1 SYNOPSIS

  use Estante::PayPal::AdaptiveAccount;

=head1 DESCRIPTION

  This module is an implementation of: PayPal - Adaptive Accounts API

  PDF: https://cms.paypal.com/cms_content/US/en_US/files/developer/PP_AdaptiveAccounts.pdf
  HTML: https://www.x.com/community/ppx/adaptive_accounts
  SANDBOX: https://developer.paypal.com/

  TEST  | PayPal API          | Item
  ---------------------------------------------------------
  OK    | AdaptiveAccounts    | CreateAccount
  OK    | AdaptiveAccounts    | AddBankAccount
  OK    | AdaptiveAccounts    | AddPaymentCard
  OK    | AdaptiveAccounts    | SetFundingCard
  TODO  | AdaptiveAccounts    | SetFundingSourceConfirmed
  OK    | AdaptiveAccounts    | GetVerifiedStatus
  OK    | AdaptiveAccounts    | GetUserAgreement

=head1 PAYPAL ADAPTIVE ACCOUNT METHOD RESPONSES

=head2 method: create_account response

response->{accountId};
response->{redirectURL};
response->{execStatus};
response->{createAccountKey;
response->{responseEnvelope}->{timestamp};
response->{responseEnvelope}->{ack};
response->{responseEnvelope}->{correlationId};
response->{responseEnvelope}->{build};

Create Account response field highlights:

Everytime you execute a create_account request, paypal will respond with some
of the following fields:

Response Field    | Meaning
-------------------------------------------------------------------------------
accountId         | ID for PayPal created account. Only for Premiere and
                  | business accounts.
createAccountKey  | Unique Key to identify created account.
                  | *** You can use this key to identify account on
                  | GetUserAgreement
execStatus        | CREATED: account creation complete. no redirect necessary.
                  | COMPLETED: account creation successful. user must redirect
                  | for approval.
redirectURL       | url for your user for approval.
responseEnvelope  | Common response information


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

