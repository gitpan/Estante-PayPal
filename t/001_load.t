use Test::More;

use strict;
use warnings;

use_ok( 'Estante::PayPal' );
use_ok( 'Estante::PayPal::Adaptive');
use_ok( 'Estante::PayPal::AdaptiveAccount' );
use_ok( 'Estante::PayPal::AdaptivePayment' );
use_ok( 'Estante::PayPal::Agent' );
use_ok( 'Estante::PayPal::Simple::Account' );
use_ok( 'Estante::PayPal::Simple::Payment' );

use_ok( 'Estante::PayPal::API' );
use_ok( 'Estante::PayPal::API::Role::Sandbox' );
use_ok( 'Estante::PayPal::API::Role::Live');

done_testing();

