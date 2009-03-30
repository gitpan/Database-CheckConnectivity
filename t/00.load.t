use Test::More tests => 4;

BEGIN {
use_ok( 'Database::CheckConnectivity' );
use_ok( 'Database::CheckConnectivity::Driver::Pg' );
use_ok( 'Database::CheckConnectivity::Driver::mysql' );
use_ok( 'Database::CheckConnectivity::Driver::SQLite' );
}

diag( "Testing Database::CheckConnectivity $Database::CheckConnectivity::VERSION" );
