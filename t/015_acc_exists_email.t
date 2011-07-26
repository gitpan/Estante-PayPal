### testa criar conta 3 vezes com o mesmo email. Paypal deve retornar
### o mesmo account_id para os mesmos emails
use strict;
use warnings;
use utf8;
use lib "t/tlib";
use Test::EstanteSetup;

use Test::More;
use Estante::PayPal::Simple::Account;
my ( $config, $acc_detail, $DEBUG ) = &Test::EstanteSetup::info;

my $account = Estante::PayPal::Simple::Account->new($config);

$acc_detail = &acc_detail;

#PART 1/3: cria uma conta com emailXYZ@gmail...
my $acc1         = $account->create($acc_detail);
my $account_id_1 = $acc1->account_id
    if defined $acc1->account_id;

#PART 2/3: cria conta com email já cadastrado no paypal
my $acc_new = Estante::PayPal::Simple::Account->new($config);
$acc_detail->{contactPhoneNumber} = '99-2233-2211';
$acc_detail->{dateOfBirth}        = '1978-02-03';
$acc_new->create($acc_detail);
my $account_id_2 = $acc_new->adaptive_account->account_id
    if defined $acc_new->adaptive_account->account_id;

#PART 3/3: cria conta com email já cadastrado no paypal
#cadastra mais uma vez (terceira) o mesmo email no paypal
$acc_detail->{address} = {
    line1       => 'Street Faria Lima 992',
    line2       => '-',
    city        => 'Sao paulo',
    state       => 'SP',
    postalCode  => '04364-020',
    countryCode => 'BR',
};
my $acc_new2     = Estante::PayPal::Simple::Account->new($config);
my $acc3         = $acc_new2->create($acc_detail);
my $account_id_3 = $acc3->account_id if defined $acc3->account_id;

ok( $account_id_1 eq $account_id_2, 'mesmo account_id ao
    cadastrar duas vezes o mesmo email'
);

ok( $account_id_2 eq $account_id_3, 'mesmo account_id ao
    cadastrar o mesmo email pela terceira vez'
);

warn $account_id_1 if $DEBUG;
warn $account->adaptive_account->response_raw if $DEBUG;    #Print RAW resp

ok( $account->adaptive_account->is_success, 'Conta criada com sucesso' );

done_testing();

sub acc_detail {
    my ($self) = @_;
    return {
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
}

