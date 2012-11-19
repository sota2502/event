use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Event';
use Event::Controller::Event::Add;

ok( request('/event/add')->is_success, 'Request should succeed' );
done_testing();
