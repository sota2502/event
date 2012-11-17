use strict;
use warnings;

use Event;

my $app = Event->apply_default_middlewares(Event->psgi_app);
$app;

