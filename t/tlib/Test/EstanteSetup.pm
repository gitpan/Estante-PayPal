
package Test::EstanteSetup;

use strict;
use warnings;
use Data::UUID;

my $DEBUG = $ENV{TRACE_ESTANTE} || 0;

my $config = {
    sandbox       => 1,
    api_username  => 'pro_1309461541_biz_api1.gmail.com',
    api_password  => '1309461584',
    signature     => 'AFcWxV21C7fd0v3bYYYRCpSSRl31A448SI-TBJC3HTb.E2sFUyXyRm1G',
    x_id          => 'APP-80W284485P519543T',
    device_ip     => '127.0.0.1',
    sandbox_email => 'pro_1309461541_biz@gmail.com',
    config_default => './config_default.json',

};

my $acc_detail = {
    requestEnvelope => { errorLanguage => 'en_US', },
    emailAddress    => 'sell1_1309460084_biz@gmail.com',
    dateOfBirth     => '1980-05-15',
    name            => {
        firstName => 'Joao',
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
    currencyCode            => 'USD',
    citizenshipCountryCode  => 'US',
    preferredLanguageCode   => 'pt_BR',
    notificationURL         => 'http://www.example.com/notify',
    registrationType        => 'WEB',
    createAccountWebOptions => { returnUrl => 'http://www.google.com', },
};

sub info { return ( $config, $acc_detail, $DEBUG ) }

sub tracking_id {
    my $ug    = new Data::UUID;
    my $uuid = $ug->create();
    return $ug->to_string( $uuid );
}
