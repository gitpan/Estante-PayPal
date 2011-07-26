### 1. cria uma conta
### 2. executa pagamentos
### 3. verifica se valor do pagamento bate com o valor registrado no pagamento no paypal.
use strict;
use warnings;
use utf8;
use lib "t/tlib";
use Test::EstanteSetup;
use Estante::PayPal::Simple::Payment;

use Test::More;
use Estante::PayPal;

my ( $config, $acc_detail, $DEBUG ) = &Test::EstanteSetup::info;

# TODO: Load the account, not create one.
my $acc_detail_hernan = {
    requestEnvelope => { errorLanguage => 'en_US', },
    emailAddress    => 'hernanlopes@gmail.com',
    dateOfBirth     => '1980-05-15',
    name            => {
        firstName => 'Hernán',
        lastName  => 'Lopes',
    },
    address => {
        line1       => 'Paulista Avenue 945',
        line2       => '-',
        city        => 'Sao paulo',
        state       => 'SP',
        postalCode  => '04431-000',
        countryCode => 'BR',
    },
    contactPhoneNumber      => '11-9982-3999',
    currencyCode            => 'BRL',
    citizenshipCountryCode  => 'BZ',
    preferredLanguageCode   => 'pt_BR',
    notificationURL         => 'http://www.example.com/notify',
    registrationType        => 'WEB',
    createAccountWebOptions => { returnUrl => 'http://www.google.com', },
};
ok( my $pp2 = Estante::PayPal->new($config) );
ok( $pp2->adaptive_account->create_account($acc_detail_hernan) );
ok(
    $pp2->adaptive_account->ack eq 'Success',
    'ADAPTIVE ACCOUNTs->account_create'
);
ok(
    $pp2->adaptive_account->status eq 'COMPLETED', 'user must open url and
    finish account creation'
);
if ( $DEBUG
    and defined $pp2->adaptive_account->redirect_url )
{
    warn "REDIRECT-URL: " . $pp2->adaptive_account->redirect_url;
}

my $invoice_id_1 = Test::EstanteSetup->tracking_id;
my $invoice_id_2 = Test::EstanteSetup->tracking_id;
my $pgto_valor1  = 3.49;
my $pgto_valor2  = 2.97;
my $pgto_total   = $pgto_valor1 + $pgto_valor2;
warn "RESPONS: " . $pp2->adaptive_account->response_raw if $DEBUG;
{
    my $payment_details_now = {
        senderEmail  => 'pro_1309461541_biz@gmail.com',
        actionType   => 'PAY',
        currencyCode => 'USD',
        feesPayer    => 'EACHRECEIVER',
        receiverList => {
            receiver => [
                {
                    email       => 'hernanlopes@gmail.com',
                    primary     => 'false',
                    amount      => $pgto_valor1,
                    paymentType => 'GOODS',
                    invoiceId => $invoice_id_1,    #num interno da empresa
                },
                {
                    email       => 'sell1_1309460084_biz@gmail.com',
                    primary     => 'false',
                    amount      => $pgto_valor2,
                    paymentType => 'GOODS',
                    invoiceId => $invoice_id_2,    #num interno da empresa
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
    $pp2->adaptive_payment->pay($payment_details_now)
      ;    #execute a payment and create a paykey
    warn "EXEC-PAY ACK: " . $pp2->adaptive_payment->ack          if $DEBUG;
    warn "EXEC-PAY RAW: " . $pp2->adaptive_payment->response_raw if $DEBUG;
    ok(
        $pp2->adaptive_payment->ack eq 'Success',
        'adaptive_payment->execute_payment'
    );
    ok(
        $pp2->adaptive_payment->status eq 'COMPLETED', 'congrats! payment was
        successful!! Total Amount: 6.46'
    );

}

my $payk = $pp2->adaptive_payment->paykey
  if defined $pp2->adaptive_payment->paykey;
{

#agora vamos obter informacao sobre os dois pagamentos realizados e provar que elas batem

    $pp2->adaptive_payment->pay_details(
        {
            payKey          => $payk,
            requestEnvelope => { errorLanguage => 'en_US', },
        }
    );
    warn "PAY KEY: " . $pp2->adaptive_payment->paykey            if $DEBUG;
    warn "PAY INFO-RAW: " . $pp2->adaptive_payment->response_raw if $DEBUG;

    my $pay_detail_response_total = 0;
    foreach my $payment (
        @{ $pp2->adaptive_payment->payment_info_list->{paymentInfo} } )
    {
        $pay_detail_response_total += $payment->{receiver}->{amount};
    }
    warn "PGTO TOTAL: " . $pgto_total                      if $DEBUG;
    warn "PAY DETAIL TOTAL: " . $pay_detail_response_total if $DEBUG;

    ok(
        $pgto_total == $pay_detail_response_total,
        'PROOF that paid value == payment detail values'
    );

}

{
    #### agora vamos provar que os valores pagos batem via Simple Payment

    my $payment_simple = Estante::PayPal::Simple::Payment->new($config);
    $payment_simple->pay_details( { payKey => $payk, } );

    warn "PGTO TOTAL: " . $pgto_total if $DEBUG;
    warn "PAY DETAIL TOTAL: " . $payment_simple->total_amount_paid if $DEBUG;

    ok(
        $pgto_total == $payment_simple->total_amount_paid,
        'PROOF that paid value == payment detail values (with simple::payment)'
    );
}

done_testing();
