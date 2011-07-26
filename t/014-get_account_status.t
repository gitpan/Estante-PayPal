### VERIFICA STATUS DE CONTAS CRIADAS
use strict;
use warnings;
use utf8;
use lib "t/tlib";
use Test::EstanteSetup;

use Test::More;
use Estante::PayPal::Simple::Account;
my ( $config, $acc_detail, $DEBUG ) = &Test::EstanteSetup::info;

my $simple= Estante::PayPal::Simple::Account->new( $config );

### Estante::PayPal adaptive_account->get_verified_status
{
    my $verified_status_params = {
        emailAddress    => 'sell1_1309460084_biz@gmail.com',
        matchCriteria   => "NAME",
        firstName       => "Hernan",
        lastName        => "Lopes"
    };

    my $acc = $simple->get_verified_status($verified_status_params);
    ok( $acc->ack eq 'Success', 'ADAPTIVE ACCOUNTs->get_verified_status' );
    warn "GETVERIFIEDSTATUS-RESPONS: " . $acc->response_raw
        if $DEBUG;
}

done_testing();
