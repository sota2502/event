package Event::Controller::Event;
use Moose;
use namespace::autoclean;
use Date::Calc;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

Event::Controller::Event - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

my @DAY_OF_WEEK = (qw/Sun Mon Tue Wed Thu Fri Sat/);

sub index :Path {
    my ( $self, $c ) = @_;
    my ($year, $month) = @{$c->req->arguments}[0, 1];
    unless ( defined $year && defined $month ) {
        ($year, $month) = Date::Calc::Today();
    }

    $c->stash->{template} = 'event/index.tt';

    my $schedule = $self->find_schedule($c, $year, $month);

    $c->stash->{schedule_calendar} = $self->create_schedule_calendar(
        schedule => $schedule,
        year     => $year,
        month    => $month,
    );

    $c->stash->{year}  = $year;
    $c->stash->{month} = $month;

    my $neightbor = __neightbor($year, $month);
    $c->stash->{$_} = $neightbor->{$_} for ( qw/prev next/ );
}
=cut
sub view: Local: Args(1) {
    my ($self, $c, $event_id ) = @_;

    my $resultset = $c->model('DBIC::Event');
    my $event = $resultset->find($event_id);
    return unless ( $event );

    $c->stash->{event} = $event;
    my ($year, $month) = split /\D/, $event->scheduled_datetime;
    $c->stash->{year}  = $year;
    $c->stash->{month} = $month;
}
=cut

sub create_schedule_calendar {
    my ($self, %args) = @_;

    my ($year, $month, $schedule) = @args{qw/year month schedule/};
    my $days = Date::Calc::Days_in_Month($year, $month);
    my $start_dow = Date::Calc::Day_of_Week($year, $month, 1) - 1;

        
    my @schedule_calendar = map {
        my $dow = ($_ + $start_dow) % 7;
        +{
            day         => $_,
            dow_number  => $dow,
            dow_caption => $DAY_OF_WEEK[$dow],
            schedules   => $schedule->{$_} || [],
        }
    } (1 .. $days);

    return \@schedule_calendar;
}

sub find_schedule {
    my ($self, $c, $year, $month) = @_;

    my ($page_id, $module_id) = (1, 1);

    my $resultset = $c->model('DBIC::Event');
    my $month_days = Date::Calc::Days_in_Month($year, $month);
    my $start = sprintf '%04d-%02d-01 00:00:00', $year, $month;
    my $end   = sprintf '%04d-%02d-%02d 23:59:59', $year, $month, $month_days;

    my @schedules = $resultset->search({
        page_id   => $page_id,
        module_id => $module_id,
        scheduled_datetime => {between => [$start, $end]},
    });

    my %result;
    foreach my $entry (@schedules) {
        my $day = __day($entry->scheduled_datetime);
        $result{$day} ||= [];
        push @{$result{$day}}, $entry;
    }

    return \%result;
}

sub __day {
    my $dt = shift;
    my @elem = split /\D/, $dt;
    return int($elem[2]);
}

sub __neightbor {
    my ($year, $month) = @_;

    my $format = '/event/%d/%d';
    my $prev = sprintf $format, (
        ( $month == 1 ) ? ( $year - 1, 12 ) : ( $year, $month - 1 )
    );
    my $next = sprintf $format, (
        ( $month == 12 ) ? ( $year +1, 1 ) : ( $year, $month + 1 )
    );

    return {
        prev => $prev,
        next => $next,
    };
}


=head1 AUTHOR

中森 創太

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
