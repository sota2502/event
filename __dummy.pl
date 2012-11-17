#!/usr/bin/perl 
use strict;
use warnings;

use DBI;
use Date::Calc;

my $dbh = DBI->connect('dbi:SQLite:dbname=data/event.db', '', '');
my $sth = $dbh->prepare(q{
    INSERT INTO
        event(page_id, module_id, title, description, scheduled_datetime, created_datetime)
        VALUES (?, ?, ?, ?, ?, ?)
});
my ($page_id, $module_id) = (1, 1);


foreach my $index ( 1 .. 10 ) {
    my $day = int(rand(30));

    my $scheduled = sprintf "2012-11-%02d 12:00:00", $day;
    my $created   = sprintf "%04d-%02d-%02d %02d:%02d:%02d", Date::Calc::Today_and_Now();
    my $title     = sprintf "%d-%d-%d", $page_id, $module_id, $index;
    my $description = sprintf "description %d-%d-%d", $page_id, $module_id, $index;
    $sth->execute($page_id, $module_id, $title, $description, $scheduled, $created);
}
