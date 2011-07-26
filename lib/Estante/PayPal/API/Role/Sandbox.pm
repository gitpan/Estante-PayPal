package Estante::PayPal::API::Role::Sandbox;

use Moose::Role;

has endpoints => (
    is       => 'ro',
    isa      => 'HashRef',
    init_arg => undef,
    builder  => 'builder_endpoints'
);

sub builder_endpoints {
    return {
        adaptive_accounts => {
            create_account      => 'https://svcs.sandbox.paypal.com/AdaptiveAccounts/CreateAccount',
            add_bank_account    => 'https://svcs.sandbox.paypal.com/AdaptiveAccounts/AddBankAccount',
            get_user_agreement  => 'https://svcs.sandbox.paypal.com/AdaptiveAccounts/GetUserAgreement',
            get_verified_status => 'https://svcs.sandbox.paypal.com/AdaptiveAccounts/GetVerifiedStatus',
            add_payment_card    => 'https://svcs.sandbox.paypal.com/AdaptiveAccounts/AddPaymentCard',
            set_funding_source_confirmed =>
                'https://svcs.sandbox.paypal.com/AdaptiveAccounts/SetFundingSourceConfirmed',
        },
        adaptive_payments => {
            pay                  => 'https://svcs.sandbox.paypal.com/AdaptivePayments/Pay',
            currency_conversion  => 'https://svcs.sandbox.paypal.com/AdaptivePayments/ConvertCurrency',
            pay_details          => 'https://svcs.sandbox.paypal.com/AdaptivePayments/PaymentDetails',
            preapproval_canceled => 'https://svcs.sandbox.paypal.com/AdaptivePayments/CancelPreapproval',
            preapproval          => 'https://svcs.sandbox.paypal.com/AdaptivePayments/Preapproval',
            preapproval_details  => 'https://svcs.sandbox.paypal.com/AdaptivePayments/PreapprovalDetails',
            refund               => 'https://svcs.sandbox.paypal.com/AdaptivePayments/Refund',
            execute_payment      => 'https://svcs.sandbox.paypal.com/AdaptivePayments/ExecutePayment/',
            get_payment_options  => 'https://svcs.sandbox.paypal.com/AdaptivePayments/GetPaymentOptions/',
            set_payment_options  => 'https://svcs.sandbox.paypal.com/AdaptivePayments/SetPaymentOptions/',
            get_funding_plans    => 'https://svcs.sandbox.paypal.com/AdaptivePayments/GetFundingPlans/',
            get_shipping_address => 'https://svcs.sandbox.paypal.com/AdaptivePayments/GetShippingAddresses/',
        }
    };
}

=head1 NAME

Estante::Paypal::API::Role::Sandbox;

=head1 SYNOPSIS

  use Estante::PayPal::API::Role::Sandbox;

=head1 DESCRIPTION

Use this role to test your application.
When its ready, switch to Estante::PayPal::API::Role::Live

Dont forget to signup at (you will need it to use Paypal Sandbox):

1. https://developer.paypal.com
2. http://www.x.com

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

