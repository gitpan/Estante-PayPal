use strict;
use warnings;
use utf8;
use lib "t/tlib";
use Test::EstanteSetup;

use Test::More;
use Estante::PayPal;

my ( $config, $acc_detail, $DEBUG ) = &Test::EstanteSetup::info;

# TODO: Load the account, not create one.
ok( my $pp = Estante::PayPal->new($config) );
ok( $pp->adaptive_account->create_account($acc_detail) );
ok( $pp->adaptive_account->ack eq 'Success', 'ADAPTIVE ACCOUNTs->account_create');
warn "RESPONS: " . $pp->adaptive_account->response_raw if $DEBUG;

isa_ok( $pp, 'Estante::PayPal' );
ok( my $account_id = $pp->adaptive_account->response->{accountId} );
my $store_tracking_id = Test::EstanteSetup->tracking_id; #chave interna da sua loja

### Estante::PayPal adaptive_payment->pay
{
    my $payment_details = {
        reverseAllParallelPaymentsOnError => 'true',
        trackingId  => $store_tracking_id, #to obtain info about payment or to request a refund
        senderEmail  => 'pro_1309461541_biz@gmail.com',
        actionType   => 'PAY',
        currencyCode => 'USD',
        feesPayer    => 'EACHRECEIVER',
        receiverList => {
            receiver => [
                {   email   => 'sell1_1309460084_biz@gmail.com',
                    primary => 'false',
                    amount  => '2.22',
                },
            ],
        },
        returnUrl       => 'http:myreturnurl',
        cancelUrl       => 'http:mycancelurl',
        requestEnvelope => { errorLanguage => 'en_US', },
        clientDetails   => {
            ipAddress     => '127.0.0.1',
            deviceId      => 'mydevice',
            applicationId => 'PayNvpDemo',
        },
    };
    $pp->adaptive_payment->pay($payment_details);
    warn 'PAY-SUCESSO: ' . $pp->adaptive_payment->ack if $DEBUG;
    ok( $pp->adaptive_payment->ack eq 'Success', 'adaptive_payment->pay' );
    warn 'PAY-RESPONS: ' . $pp->adaptive_payment->response_raw if $DEBUG;
}

### Estante::PayPal adaptive_payment->currency_conversion
{
    my $currency_params = {
        requestEnvelope => {
            errorLanguage => 'en_US',
            detailLevel   => 'ReturnAll',
        },
        baseAmountList => {
            currency => {
                code   => 'USD',
                amount => 1.23,
            },
        },
        convertToCurrencyList => { currencyCode => 'EUR', },
    };
    $pp->adaptive_payment->currency_conversion($currency_params);
    warn "CURRENCY-CONV ACK: " . $pp->adaptive_payment->ack          if $DEBUG;
    warn "CURRENCY-CONV RAW: " . $pp->adaptive_payment->response_raw if $DEBUG;
    ok( $pp->adaptive_payment->ack eq 'Success', 'adaptive_payment->currency_conversion' );
}

### Estante::PayPal adaptive_payment->pay_details
{
    my $pay_details_params = {
        payKey       => $pp->adaptive_payment->paykey,
        senderEmail  => 'pro_1309461541_biz@gmail.com',
        actionType   => 'PAY',
        currencyCode => 'USD',
        feesPayer    => 'EACHRECEIVER',
        receiverList => {
            receiver => [
                {   email   => 'sell1_1309460084_biz@gmail.com',
                    primary => 'false',
                    amount  => 2.02,
                },
            ],
        },
        returnUrl       => 'http:myreturnurl',
        cancelUrl       => 'http:mycancelurl',
        requestEnvelope => { errorLanguage => 'en_US', },
        clientDetails   => {
            ipAddress     => '127.0.0.1',
            deviceId      => 'mydevice',
            applicationId => 'PayNvpDemo',
        },
    };

    $pp->adaptive_payment->pay_details($pay_details_params);
    warn "PAY-DETAILS ACK: " . $pp->adaptive_payment->ack          if $DEBUG;
    warn "PAY-DETAILS RAW: " . $pp->adaptive_payment->response_raw if $DEBUG;
    ok( $pp->adaptive_payment->ack eq 'Success', 'adaptive_payment->pay_details' );
}

### Estante::PayPal adaptive_payment->preapproval
{
    my $preapproval_params = {
        senderEmail  => 'pro_1309461541_biz@gmail.com',
        actionType   => 'PAY',
        currencyCode => 'USD',
        feesPayer    => 'EACHRECEIVER',
        receiverList => {
            receiver => [
                {   email   => 'sell1_1309460084_biz@gmail.com',
                    primary => 'false',
                    amount  => '2.01',
                }
            ],
        },
        returnUrl       => 'http:myreturnurl',
        cancelUrl       => 'http:mycancelurl',
        requestEnvelope => { errorLanguage => 'en_US', },
        clientDetails   => {
            ipAddress     => '127.0.0.1',
            deviceId      => 'mydevice',
            applicationId => 'PayNvpDemo',
        },
        maxTotalAmountOfAllPayments => '16',
        startingDate                => '2011-10-30T00:11:11',    # *** must be on the future says API
        endingDate                  => '2011-11-27T00:00:22'
    };
    $pp->adaptive_payment->preapproval($preapproval_params);
    warn "PREAPPROVAL ACK: " . $pp->adaptive_payment->ack          if $DEBUG;
    warn "PREAPPROVAL RAW: " . $pp->adaptive_payment->response_raw if $DEBUG;
    ok( $pp->adaptive_payment->ack eq 'Success', 'adaptive_payment->preapproval' );
}

### Estante::PayPal adaptive_payment->preapproval_canceled
{
    my $preapproval_canceled_params = {
        preapprovalKey  => $pp->adaptive_payment->preapproval_key,
        detailLevel     => 'ReturnAll',
        requestEnvelope => { errorLanguage => 'en_US', }
    };

    $pp->adaptive_payment->preapproval_canceled($preapproval_canceled_params);
    warn "PREAPPROVAL-CANCEL ACK: " . $pp->adaptive_payment->ack if $DEBUG;
    warn "PREAPPROVAL-CANCEL RAW: " . $pp->adaptive_payment->response_raw
        if $DEBUG;
    ok( $pp->adaptive_payment->ack eq 'Success', 'adaptive_payment->preapproval_canceled' );
}




### Estante::PayPal adaptive_payment->execute_payment
### desc: cria pagamento e executa pagamento em um segundo momento
{
    my $payment_details_later = {
        senderEmail  => 'pro_1309461541_biz@gmail.com',
        actionType   => 'CREATE',                         #Necessary to execute_payment later
        currencyCode => 'USD',
        feesPayer    => 'EACHRECEIVER',
        receiverList => {
            receiver => [
                {   email   => 'sell1_1309460084_biz@gmail.com',
                    primary => 'false',
                    amount  => '2.90',
                },
            ],
        },
        returnUrl       => 'http:myreturnurl',
        cancelUrl       => 'http:mycancelurl',
        requestEnvelope => { errorLanguage => 'en_US', },
        clientDetails   => {
            ipAddress     => '127.0.0.1',
            deviceId      => 'mydevice',
            applicationId => 'PayNvpDemo',
        },
    };
    $pp->adaptive_payment->pay($payment_details_later);    #execute a payment and create a paykey
    my $exec_pay_params = {
        payKey          => $pp->adaptive_payment->paykey,
        requestEnvelope => {
            errorLanguage => 'en_US',
            detailLevel   => 'ReturnAll',
        }
    };
    $pp->adaptive_payment->execute_payment($exec_pay_params);
    warn "EXEC-PAY ACK: " . $pp->adaptive_payment->ack          if $DEBUG;
    warn "EXEC-PAY RAW: " . $pp->adaptive_payment->response_raw if $DEBUG;
    ok( $pp->adaptive_payment->ack eq 'Success', 'adaptive_payment->execute_payment' );
}

### Estante::PayPal adaptive_payment->get_payment_options
{
    my $gpo = {
        senderEmail  => 'pro_1309461541_biz@gmail.com',
        actionType   => 'CREATE',                         #Necessary to execute_payment later
        currencyCode => 'USD',
        feesPayer    => 'EACHRECEIVER',
        receiverList => {
            receiver => [
                {   email   => 'sell1_1309460084_biz@gmail.com',
                    primary => 'false',
                    amount  => '2.80',
                },
            ],
        },
        returnUrl       => 'http:myreturnurl',
        cancelUrl       => 'http:mycancelurl',
        requestEnvelope => { errorLanguage => 'en_US', },
        clientDetails   => {
            ipAddress     => '127.0.0.1',
            deviceId      => 'mydevice',
            applicationId => 'PayNvpDemo',
        },
    };
    $pp->adaptive_payment->pay($gpo);    #execute a payment and create a paykey
    my $get_pay_opts = {
        payKey          => $pp->adaptive_payment->paykey,
        requestEnvelope => {
            errorLanguage => 'en_US',
            detailLevel   => 'ReturnAll',
        }
    };
    $pp->adaptive_payment->get_payment_options($get_pay_opts);
    warn "GET-PAY-OPTIONS ACK: " . $pp->adaptive_payment->ack          if $DEBUG;
    warn "GET-PAY-OPTIONS RAW: " . $pp->adaptive_payment->response_raw if $DEBUG;
    ok( $pp->adaptive_payment->ack eq 'Success', 'adaptive_payment->get_payment_options' );
}

### Estante::PayPal adaptive_payment->set_payment_options
{
    my $spo_payment = {
        senderEmail  => 'pro_1309461541_biz@gmail.com',
        actionType   => 'CREATE',                         #Necessary to execute_payment later
        currencyCode => 'USD',
        feesPayer    => 'EACHRECEIVER',
        receiverList => {
            receiver => [
                {   email   => 'sell1_1309460084_biz@gmail.com',
                    primary => 'false',
                    amount  => '2.70',
                },
            ],
        },
        returnUrl       => 'http:myreturnurl',
        cancelUrl       => 'http:mycancelurl',
        requestEnvelope => { errorLanguage => 'en_US', },
        clientDetails   => {
            ipAddress     => '127.0.0.1',
            deviceId      => 'mydevice',
            applicationId => 'PayNvpDemo',
        },
    };
    $pp->adaptive_payment->pay($spo_payment);    #execute a payment and create a paykey
    my $spo = {
        emailHeaderImageUrl    => 'http://img.server.com/email_header.gif',
        emailMarketingImageUrl => 'http://img.server.com/email_mkt.gif',
        payKey                 => $pp->adaptive_payment->paykey,
        requestEnvelope        => {
            errorLanguage => 'en_US',
            detailLevel   => 'ReturnAll',
        }
    };
    $pp->adaptive_payment->set_payment_options($spo);
    warn "SET-PAY-OPTIONS ACK: " . $pp->adaptive_payment->ack          if $DEBUG;
    warn "SET-PAY-OPTIONS RAW: " . $pp->adaptive_payment->response_raw if $DEBUG;
    ok( $pp->adaptive_payment->ack eq 'Success', 'adaptive_payment->set_payment_options' );
}

### Estante::PayPal adaptive_payment->get_funding_plans
{
    my $gfp_payment = {
        senderEmail  => 'pro_1309461541_biz@gmail.com',
        actionType   => 'CREATE',
        currencyCode => 'USD',
        feesPayer    => 'EACHRECEIVER',
        receiverList => {
            receiver => [
                {   email   => 'sell1_1309460084_biz@gmail.com',
                    primary => 'false',
                    amount  => '2.60',
                },
            ],
        },
        returnUrl       => 'http:myreturnurl',
        cancelUrl       => 'http:mycancelurl',
        requestEnvelope => { errorLanguage => 'en_US', },
        clientDetails   => {
            ipAddress     => '127.0.0.1',
            deviceId      => 'mydevice',
            applicationId => 'PayNvpDemo',
        },
    };
    $pp->adaptive_payment->pay($gfp_payment);    #execute a payment and create a paykey
    my $gfp = {
        payKey          => $pp->adaptive_payment->paykey,
        requestEnvelope => {
            errorLanguage => 'en_US',
            detailLevel   => 'ReturnAll',
        }
    };
    $pp->adaptive_payment->get_funding_plans($gfp);
    warn "GET-FUNDING-PLANS ACK: " . $pp->adaptive_payment->ack          if $DEBUG;
    warn "GET-FUNDING-PLANS RAW: " . $pp->adaptive_payment->response_raw if $DEBUG;
    ok( $pp->adaptive_payment->ack eq 'Success', 'adaptive_payment->get_funding_plans' );
}

### Estante::PayPal adaptive_payment->get_shipping_address
{
    my $gsa_payment = {
        senderEmail  => 'pro_1309461541_biz@gmail.com',
        actionType   => 'CREATE',
        currencyCode => 'USD',
        feesPayer    => 'EACHRECEIVER',
        receiverList => {
            receiver => [
                {   email   => 'sell1_1309460084_biz@gmail.com',
                    primary => 'false',
                    amount  => '2.50',
                    address => {
                        line1       => 'Street Faria Lima 992',
                        line2       => '-',
                        city        => 'São paulo',
                        state       => 'SP',
                        postalCode  => '04364-020',
                        countryCode => 'BR',
                    },
                },
            ],
        },
        returnUrl       => 'http:myreturnurl',
        cancelUrl       => 'http:mycancelurl',
        requestEnvelope => { errorLanguage => 'en_US', },
        clientDetails   => {
            ipAddress     => '127.0.0.1',
            deviceId      => 'mydevice',
            applicationId => 'PayNvpDemo',
        },
    };
    $pp->adaptive_payment->pay($gsa_payment);    #execute a payment and create a paykey
    my $gsa = {
        key             => $pp->adaptive_payment->paykey,    ### PREAPPROVAL OR PAYKEY.
        requestEnvelope => {
            errorLanguage => 'en_US',
            detailLevel   => 'ReturnAll',
        }
    };
    $pp->adaptive_payment->get_shipping_address($gsa);
    warn "GET-ADDRESS ACK: " . $pp->adaptive_payment->ack          if $DEBUG;
    warn "GET-ADDRESS RAW: " . $pp->adaptive_payment->response_raw if $DEBUG;
    ok( $pp->adaptive_payment->ack eq 'Success', 'adaptive_payment->get_shipping_address #paykey' );
}

### Estante::PayPal adaptive_payment->preapproval_details
{
    my $preapproval_detail_params = {
        senderEmail    => 'pro_1309461541_biz@gmail.com',
        actionType     => 'PAY',
        preapprovalKey => $pp->adaptive_payment->preapproval_key,
        currencyCode   => 'USD',
        feesPayer      => 'EACHRECEIVER',
        receiverList   => {
            receiver => [
                {   email   => 'sell1_1309460084_biz@gmail.com',
                    primary => 'false',
                    amount  => '2.40',
                },
            ],
        },
        returnUrl       => 'http:myreturnurl',
        cancelUrl       => 'http:mycancelurl',
        requestEnvelope => { errorLanguage => 'en_US' },
        clientDetails   => {
            ipAddress     => '127.0.0.1',
            deviceId      => 'mydevice',
            applicationId => 'PayNvpDemo',
        },
        maxTotalAmountOfAllPayments => '16',
        startingDate                => '2009-10-30T00:11:11',
        endingDate                  => '2009-11-27T00:00:22'
    };
    $pp->adaptive_payment->preapproval_details($preapproval_detail_params);
    warn "PREAPPRV-DETAILS ACK: " . $pp->adaptive_payment->ack          if $DEBUG;
    warn "PREAPPRV-DETAILS RAW: " . $pp->adaptive_payment->response_raw if $DEBUG;
    ok( $pp->adaptive_payment->ack eq 'Success', 'adaptive_payment->preapproval_details' );
}

### Estante::PayPal adaptive_payment->refund
{
    my $refund_params = {
        senderEmail  => 'pro_1309461541_biz@gmail.com',
        actionType   => 'PAY',
        payKey       => $pp->adaptive_payment->paykey,
        currencyCode => 'USD',
        feesPayer    => 'EACHRECEIVER',
        receiverList => {
            receiver => [
                {   email   => 'sell1_1309460084_biz@gmail.com',
                    primary => 'false',
                    amount  => '2.30',
                },
            ],
        },
        returnUrl       => 'http:myreturnurl',
        cancelUrl       => 'http:mycancelurl',
        requestEnvelope => { errorLanguage => 'en_US', },
        clientDetails   => {
            ipAddress     => '127.0.0.1',
            deviceId      => 'mydevice',
            applicationId => 'PayNvpDemo',
        },
        maxTotalAmountOfAllPayments => '16',
        endingDate                  => '2011-11-27T00:00:22'
    };
    $pp->adaptive_payment->refund($refund_params);
    warn "REFUND ACK: " . $pp->adaptive_payment->ack          if $DEBUG;
    warn "REFUND RAW: " . $pp->adaptive_payment->response_raw if $DEBUG;
    ok( $pp->adaptive_payment->ack eq 'Success', 'adaptive_payment->refund' );
}

done_testing();
