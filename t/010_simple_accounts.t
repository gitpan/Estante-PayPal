### TESTA CRIAR CONTAS
use strict;
use warnings;
use utf8;
use lib "t/tlib";
use Test::EstanteSetup;

use Test::More;
use Estante::PayPal::Simple::Account;
my ( $config, $acc_detail, $DEBUG ) = &Test::EstanteSetup::info;

my $account = Estante::PayPal::Simple::Account->new($config);

$acc_detail = {
    emailAddress => 'sell1_1309460084_biz@gmail.com',
    dateOfBirth  => '1980-05-15',
    name         => {
        firstName => 'Cleber',
        lastName  => 'Silva',
    },
    address => {
        line1       => 'Street Faria Lima 992',
        line2       => '-',
        city        => 'Sao paulo',
        state       => 'SP',
        postalCode  => '04364-020',
        countryCode => 'BR',
    },
    contactPhoneNumber      => '11-9982-3827',
    createAccountWebOptions => { returnUrl => 'http://www.google.com', },
};

my $acc = $account->create($acc_detail);

warn $acc->response_raw if $DEBUG;    #Print RAW sandbox response

ok( $acc->is_success, 'Conta criada com sucesso' );

done_testing();

