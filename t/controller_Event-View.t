use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Event';
use Event::Controller::Event::View;

ok( request('/event/view')->is_success, 'Request should succeed' );
done_testing();
