package Event::Controller::Event::Add;
use Moose;
use namespace::autoclean;
use Date::Calc;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Event::Controller::Event::Add - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'event/add.tt';
}

sub commit :Path {
    my ($self, $c) = @_;

    ## ToDo: require validation

    my %param = map {
        +($_ => $c->req->param($_))
    } qw/title description scheduled_datetime attend_limit/;

    my $resultset = $c->model('DBIC::Event');
    my $now = $c->now;

    $param{page_id}   = $c->page_id;
    $param{module_id} = $c->module_id;
    $param{created_datetime} = $now;

    my $row = $resultset->create({%param});
    unless ( $row ) {
        $c->response->body('Failed Creating Event');
    }

    my $url = sprintf '/event/view/%d', $row->event_id;

    $c->res->redirect($c->uri_for($url));
}


=head1 AUTHOR

中森 創太

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
