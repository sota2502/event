package Event::Model::DBIC;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'Event::Schema',
    
    connect_info => {
        dsn => 'dbi:SQLite:dbname=data/event.db',
        user => '',
        password => '',
    }
);

=head1 NAME

Event::Model::DBIC - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<Event>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<Event::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.59

=head1 AUTHOR

中森 創太

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
