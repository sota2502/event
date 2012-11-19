package Event::Controller::Event::Cancel;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Event::Controller::Event::Cancel - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(1) {
    my ( $self, $c ) = @_;

    ## Todo: require validation
    my $event_id = $c->req->arguments->[0];


    my $result = $self->cancel($c);

    $c->res->redirect($c->uri_for('/event/view/' . $event_id));
}

sub cancel {
    my ($self, $c) = @_;

    my $event_id = $c->req->arguments->[0];
    ## check the attend_count less than attend limit
    my $event = $c->model('DBIC::Event')->find($event_id);

    ## check the user has already attend
    my $attend_resultset = $c->model('DBIC::AttendMember');
    my $attend_member = $attend_resultset->find({
        event_id  => $event_id,
        member_id => $c->member_id,
    });
    return unless ( $attend_member );

    my $result = $attend_member->delete();
    return unless ( $result );

    ## It's weak for parallel executing because no transaction
    my $new_count = ($event->attend_count || 0) - 1;
    $new_count = 0 if ( $new_count < 0 );
    $event->update({ attend_count => $new_count });
    return $result;
}

=head1 AUTHOR

中森 創太

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
