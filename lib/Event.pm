package Event;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;
use Date::Calc;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in event.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'Event',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
);

# Start the application
__PACKAGE__->setup();


sub page_id {
    return 1;
}

sub module_id {
    return 1;
}

sub member_id {
    return 'abcdefghijklmnopqrst';
}

sub now {
    return sprintf "%04d-%02d-%02d %02d:%02d:%02d", Date::Calc::Today_and_Now;
}

=head1 NAME

Event - Catalyst based application

=head1 SYNOPSIS

    script/event_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Event::Controller::Root>, L<Catalyst>

=head1 AUTHOR

中森 創太

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
