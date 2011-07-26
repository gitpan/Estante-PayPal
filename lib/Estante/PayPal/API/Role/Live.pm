package Estante::PayPal::API::Role::Live;

use Moose::Role;

has endpoints => (
    is       => 'ro',
    isa      => 'HashRef',
    init_arg => undef,
    builder  => '_builder_endpoints'
);

sub _builder_endpoints {
    return {
        adaptive_accounts => {
            create_account               => 'https://svcs.paypal.com/AdaptiveAccounts/CreateAccount',
            add_bank_account             => 'https://svcs.paypal.com/AdaptiveAccounts/AddBankAccount',
            get_user_agreement           => 'https://svcs.paypal.com/AdaptiveAccounts/GetUserAgreement',
            get_verified_status          => 'https://svcs.paypal.com/AdaptiveAccounts/GetVerifiedStatus',
            add_payment_card             => 'https://svcs.paypal.com/AdaptiveAccounts/AddPaymentCard',
            set_funding_source_confirmed => 'https://svcs.paypal.com/AdaptiveAccounts/SetFundingSourceConfirmed',
        },
        adaptive_payments => {
            pay                  => 'https://svcs.paypal.com/AdaptivePayments/Pay',
            currency_conversion  => 'https://svcs.paypal.com/AdaptivePayments/ConvertCurrency',
            pay_details          => 'https://svcs.paypal.com/AdaptivePayments/PaymentDetails',
            preapproval_canceled => 'https://svcs.paypal.com/AdaptivePayments/CancelPreapproval',
            preapproval          => 'https://svcs.paypal.com/AdaptivePayments/Preapproval',
            preapproval_details  => 'https://svcs.paypal.com/AdaptivePayments/PreapprovalDetails',
            refund               => 'https://svcs.paypal.com/AdaptivePayments/Refund',
            execute_payment      => 'https://svcs.paypal.com/AdaptivePayments/ExecutePayment/',
            get_payment_options  => 'https://svcs.paypal.com/AdaptivePayments/GetPaymentOptions/',
            set_payment_options  => 'https://svcs.paypal.com/AdaptivePayments/SetPaymentOptions/',
            get_funding_plans    => 'https://svcs.paypal.com/AdaptivePayments/GetFundingPlans/',
            get_shipping_address => 'https://svcs.paypal.com/AdaptivePayments/GetShippingAddresses/',
        }
    };
}

=head1 NAME

Estante::Paypal::API::Role::Live;

=head1 SYNOPSIS

  use Estante::PayPal::API::Role::Live;

=head1 DESCRIPTION

This role will make your application go LIVE (with real money envolved).
Only use this role when your app is 100% tested.

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

