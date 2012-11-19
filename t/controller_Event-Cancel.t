use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Event';
use Event::Controller::Event::Cancel;

ok( request('/event/cancel')->is_success, 'Request should succeed' );
done_testing();
