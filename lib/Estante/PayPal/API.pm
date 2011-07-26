package Estante::PayPal::API;

use Moose;
with 'MooseX::Traits';

has '+_trait_namespace' => ( default => 'Estante::PayPal::API::Role' );

1;

