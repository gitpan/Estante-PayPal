### TESTA PAGAMENTOS MULTIPLOS
use strict;
use warnings;
use utf8;
use lib "t/tlib";
use Test::EstanteSetup;

use Test::More;
use Estante::PayPal::Simple::Payment;
my ( $config, $acc_detail, $DEBUG ) = &Test::EstanteSetup::info;

my $payment = Estante::PayPal::Simple::Payment->new($config);

{
    $payment->tracking_id( Test::EstanteSetup->tracking_id );
    $payment->add_payment(
        {   email   => 'sell1_1309460084_biz@gmail.com',
            primary => 'false',
            amount  => '0.56',
        }
    );
    $payment->add_payment(
        {   email   => 'sell2_1309460084_biz@gmail.com',
            primary => 'false',
            amount  => '0.96',
        }
    );
    $payment->add_payment(
        {   email   => 'sell3_1309460084_biz@gmail.com',
            primary => 'false',
            amount  => '0.73',
        }
    );
    $payment->cancel_url('http:mycancelurl');
    $payment->return_url('http:myreturnurl');
    $payment->pay();

    warn 'STATS:' . $payment->adaptive_payment->ack if $DEBUG;
    ok( $payment->adaptive_payment->ack eq 'Success', 'Pagamento para 3 emails/pessoa diferentes' );
    warn 'RESP: ' . $payment->adaptive_payment->response_raw if $DEBUG;
}

done_testing();

