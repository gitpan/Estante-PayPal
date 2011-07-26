use strict;
use warnings;
use utf8;
use lib "t/tlib";
use Test::EstanteSetup;

use Test::More;
use Estante::PayPal;

my ( $config, $acc_detail, $DEBUG ) = &Test::EstanteSetup::info;

ok( my $pp = Estante::PayPal->new($config) );
ok( $pp->adaptive_account->create_account($acc_detail) );
ok( $pp->adaptive_account->ack eq 'Success', 'ADAPTIVE ACCOUNTs->account_create' );
warn "RESPONSE: " . $pp->adaptive_account->response_raw if $DEBUG;

isa_ok( $pp, 'Estante::PayPal' );
ok( my $account_id = $pp->adaptive_account->response->{accountId} );

### Estante::PayPal adaptive_account->add_bank_account
{
    my $bank_acc_details = {
        bankAccountNumber => "053679235391991",
        bankAccountType   => "CHECKING",
        bankCountryCode   => "US",
        bankName          => "Bank of America",
        confirmationType  => "WEB",
        emailAddress      => 'sell1_1309460084_biz@gmail.com',
        requestEnvelope   => { errorLanguage => "en_US", },
        routingNumber     => "111900659",
        webOptions        => {
            cancelUrl            => "http://www.paypal.com",
            cancelUrlDescription => "My Cancel URL",
            returnUrl            => "http://www.paypal.com",
            returnUrlDescription => "My return URL"
        },
    };
    $pp->adaptive_account->add_bank_account($bank_acc_details);

    ok( $pp->adaptive_account->ack eq 'Success', 'ADAPTIVE ACCOUNTs->add_bank_account' );
    warn "ADDBANK-RESPONS: " . $pp->adaptive_account->response_raw if $DEBUG;
}

### Estante::PayPal adaptive_account->get_user_agreement
{
    my $get_user_agreement_params = {
        countryCode     => 'US',                            # OPT, this or createAccountKey
        languageCode    => "en_US",
        requestEnvelope => { errorLanguage => "en_US", },

        #   createAccountKey => $pp->adaptive_account->create_account_key, #
        agreementType => 'Personal',
    };
    $pp->adaptive_account->get_user_agreement($get_user_agreement_params);
    ok( $pp->adaptive_account->ack eq 'Success', 'ADAPTIVE ACCOUNTs->get_user_agreement' );
    warn "GETUSERAGREEMNT-RESPONS: " . $pp->adaptive_account->response_raw
        if $DEBUG;
}

### Estante::PayPal adaptive_account->get_verified_status
{
    my $verified_status_params = {
        emailAddress    => 'sell1_1309460084_biz@gmail.com',
        requestEnvelope => { errorLanguage => "en_US", },
        matchCriteria   => "NAME",
        firstName       => "Hernan",
        lastName        => "Lopes"
    };
    $pp->adaptive_account->get_verified_status($verified_status_params);
    ok( $pp->adaptive_account->ack eq 'Success', 'ADAPTIVE ACCOUNTs->get_verified_status' );
    warn "GETVERIFIEDSTATUS-RESPONS: " . $pp->adaptive_account->response_raw
        if $DEBUG;
}

### Estante::PayPal adaptive_account->add_payment_card
my $funding_source_key;
{
    my $add_payment_card_params = {
        cardNumber       => '4943871033202264',
        confirmationType => 'WEB',
        emailAddress     => 'sell1_1309460084_biz@gmail.com',
        cardType         => 'Visa',
        expirationDate   => {
            month => '01',
            year  => '2014',
        },
        billingAddress => {
            line1       => '1 Main St',
            line2       => '2nd cross',
            city        => 'San Jose',
            state       => 'CA',
            postalCode  => '95131',
            countryCode => 'US',
        },
        nameOnCard => {
            firstName => 'John',
            lastName  => 'Deo',
        },
        requestEnvelope => {
            detailLevel   => 'ReturnAll',
            errorLanguage => "en_US",
        },

        #   webOptions => {
        #       cancelUrl => "http://www.paypal.com",
        #       cancelUrlDescription => "My Cancel URL",
        #       returnUrl => "http://www.paypal.com",
        #       returnUrlDescription => "My return URL"
        #   }, #OPT WHEN confirmationType ne 'NONE'
        #    ## IF confirmationType eq 'NONE' set cardVerificationNumber and createAccountKey
    };
    ok( $pp->adaptive_account->add_payment_card($add_payment_card_params) );
    ok( $pp->adaptive_account->ack eq 'Success', 'ADAPTIVE ACCOUNTs->add_payment_card' );
    warn "ADD-PAY-CARD-RESPONS: " . $pp->adaptive_account->response_raw
        if $DEBUG;
    $funding_source_key = $pp->adaptive_account->response->{fundingSourceKey};
}
### Estante::PayPal adaptive_account->set_funding_source_confirmed
# ainda não implementado
#   {
#       warn "ACCount ID:" . $account_id         if $DEBUG;
#       warn "Funding ID:" . $funding_source_key if $DEBUG;

#       my $sfscr_params = {
#           accountId => $account_id,

#           #   emailAddress => 'sell1_1309460084_biz@gmail.com',
#           fundingSourceKey => $funding_source_key,    #is returned from add_payment_card and addbank
#           requestEnvelope  => {
#               detailLevel   => 'ReturnAll',
#               errorLanguage => "en_US",
#           },
#       };
#       ok( $pp->adaptive_account->set_funding_source_confirmed($sfscr_params) );
#       ok( $pp->adaptive_account->ack eq 'Success', 'ADAPTIVE ACCOUNTs->set_funding_source_confirmed' );
#       warn "SET-FUND-CONFIRMED: " . $pp->adaptive_account->response_raw if $DEBUG;
#   }

done_testing();

