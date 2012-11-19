package Event::Controller::Event::View;
use Moose;
use namespace::autoclean;
use Date::Calc;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Event::Controller::Event::View - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args {
    my ($self, $c, $event_id ) = @_;

    my $resultset = $c->model('DBIC::Event');
    my $event = $resultset->find($event_id);
    return unless ( $event );

    $c->stash->{event} = $event;
    my ($year, $month) = split /\D/, $event->scheduled_datetime;
    $c->stash->{year}  = $year;
    $c->stash->{month} = $month;

    $c->stash->{template} = 'event/view.tt';

    $self->assign_is_attended($c, $event_id);
}

sub assign_is_attended {
    my ($self, $c, $event_id ) = @_;

    my $attend_member = $c->model('DBIC::AttendMember')->find($event_id, $c->member_id );
    $c->stash->{is_attended} = $attend_member ? 1 : 0;
    return unless ( $attend_member );
    $c->stash->{attend_member} = $attend_member;
}


=head1 AUTHOR

中森 創太

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
