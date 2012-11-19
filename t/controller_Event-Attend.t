use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Event';
use Event::Controller::Event::Attend;

ok( request('/event/attend')->is_success, 'Request should succeed' );
done_testing();
