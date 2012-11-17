use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Event';
use Event::Controller::Event;

ok( request('/event')->is_success, 'Request should succeed' );
done_testing();
