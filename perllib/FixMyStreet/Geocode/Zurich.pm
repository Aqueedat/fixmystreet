#!/usr/bin/perl
#
# FixMyStreet::Geocode::Zurich
# Geocoding with Zurich web service.
#
# Thanks to http://msdn.microsoft.com/en-us/library/ms995764.aspx
# and http://noisemore.wordpress.com/2009/03/19/perl-soaplite-wsse-web-services-security-soapheader/
# for SOAP::Lite pointers
#
# Copyright (c) 2012 UK Citizens Online Democracy. All rights reserved.
# Email: matthew@mysociety.org; WWW: http://www.mysociety.org/

package FixMyStreet::Geocode::Zurich;

use strict;
use Geo::Coordinates::CH1903;
use SOAP::Lite;
use mySociety::Locale;

my ($soap, $method, $security);

sub setup_soap {
    return if $soap;

    # Variables for the SOAP web service
    my $geocoder = FixMyStreet->config('GEOCODER');
    my $url = $geocoder->{url};
    my $username = $geocoder->{username};
    my $password = $geocoder->{password};
    my $attr = 'http://ch/geoz/fixmyzuerich/service';
    my $action = "$attr/IFixMyZuerich/";

    # Set up the SOAP handler
    $security = SOAP::Header->name("Security")->attr({
        'mustUnderstand' => 'true',
        'xmlns' => 'http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd'
    })->value(
        \SOAP::Header->name(
            "UsernameToken" => \SOAP::Header->value(
                SOAP::Header->name('Username', $username),
                SOAP::Header->name('Password', $password)
            )
        )
    );
    $soap = SOAP::Lite->on_action( sub { $action . $_[1]; } )->proxy($url);
    $method = SOAP::Data->name('getLocation')->attr({ xmlns => $attr });
}

# string STRING CONTEXT
# Looks up on Zurich web service a user-inputted location.
# Returns array of (LAT, LON, ERROR), where ERROR is either undef, a string, or
# an array of matches if there are more than one. The information in the query
# may be used to disambiguate the location in cobranded versions of the site.
sub string {
    my ( $s, $c ) = @_;

    setup_soap();

    my $search = SOAP::Data->name('search' => $s)->type('');
    my $count = SOAP::Data->name('count' => 10)->type('');
    my $result;
    eval {
        $result = $soap->call($method, $security, $search, $count);
    };
    if ($@) {
        return { error => 'The geocoder appears to be down.' };
    }
    $result = $result->result;

    if (!$result || !$result->{Location}) {
        return { error => _('Sorry, we could not parse that location. Please try again.') };
    }

    my $results = $result->{Location};
    $results = [ $results ] unless ref $results eq 'ARRAY';

    my ( $error, @valid_locations, $latitude, $longitude );
    foreach (@$results) {
        ($latitude, $longitude) = Geo::Coordinates::CH1903::to_latlon($_->{easting}, $_->{northing});
        mySociety::Locale::in_gb_locale {
            push (@$error, {
                address => $_->{text},
                latitude => sprintf('%0.6f', $latitude),
                longitude => sprintf('%0.6f', $longitude)
            });
        };
        push (@valid_locations, $_);
        last if lc($_->{text}) eq lc($s);
    }

    return { latitude => $latitude, longitude => $longitude } if scalar @valid_locations == 1;
    return { error => $error };
}

1;

