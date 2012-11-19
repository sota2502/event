package Event::Controller::Event::Attend;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Event::Controller::Event::Attend - Catalyst Controller

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

    my %param = (
        page_id          => $c->page_id,
        module_id        => $c->module_id,
        event_id         => $event_id,
        member_id        => $c->member_id,
        created_datetime => $c->now,
    );

    my $result = $self->attend($c);

    $c->res->redirect($c->uri_for('/event/view/' . $event_id));
}

sub attend {
    my ($self, $c) = @_;

    my $event_id = $c->req->arguments->[0];


    ## check the attend_count less than attend limit
    my $event = $c->model('DBIC::Event')->find($event_id);
    if ( $event->attend_limit && $event->attend_count >= $event->attend_limit ) {
        return;
    }

    ## check the user has already attend
    my $attend_resultset = $c->model('DBIC::AttendMember');
    my $attend_member = $attend_resultset->find({
        event_id  => $event_id,
        member_id => $c->member_id,
    });
    return if ( $attend_member );

    my $max_number = $attend_resultset->search(
        { event_id => $event_id },
    )->get_column('number')->max;
    my $number = ( $max_number ) ? $max_number + 1 : 1;

    my %param = (
        page_id          => $c->page_id,
        module_id        => $c->module_id,
        event_id         => $event_id,
        member_id        => $c->member_id,
        number           => $number,
        created_datetime => $c->now,
    );

    my $result = $attend_resultset->create({ %param });
    return unless ( $result );

    ## It's weak for parallel executing because no transaction
    my $new_count = ($event->attend_count || 0) + 1;
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
