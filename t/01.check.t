use strict;
use warnings;

use Test::More tests => 29;
use_ok('Database::CheckConnectivity');
use_ok('Database::CheckConnectivity::Driver::SQLite');
use_ok('Database::CheckConnectivity::Driver::Pg');
use_ok('Database::CheckConnectivity::Driver::mysql');

is( Database::CheckConnectivity::Driver::mysql->system_database,
    '', 'system_database of mysql is empty' );
is(
    Database::CheckConnectivity::Driver::mysql->not_exist_error,
    qr/unknown database/i,
    'not_exist_error of mysql is qr/unknown database/i'
);

is( Database::CheckConnectivity::Driver::Pg->system_database,
    'template1', 'system_database of Pg is empty' );
is(
    Database::CheckConnectivity::Driver::Pg->not_exist_error,
    qr/not exist/i,
    'not_exist_error of Pg is qr/not exist/i'
);

is( Database::CheckConnectivity::Driver::SQLite->system_database,
    undef, 'system_database of SQLite is undef' );
is( Database::CheckConnectivity::Driver::SQLite->not_exist_error,
    undef, 'not_exist_error of SQLite is undef' );

is( $Database::CheckConnectivity::AUTO_CREATE,
    0, 'default we do not auto create' );

use Test::MockModule;
my $dbi = Test::MockModule->new('DBI');
use Carp;
$dbi->mock();
$dbi->mock(
    connect => sub {
        shift;    # shift the class
        my $dsn      = shift;
        my $user     = shift;
        my $password = shift;
        my $attr     = shift;
        is_deeply(
            $attr,
            { RaiseError => 0, PrintError => 0 },
            'we do not want to raise or print error by default'
        );

        if ( $dsn =~ /not_exist/ ) {
            if ($Database::CheckConnectivity::AUTO_CREATE) {
                DBI::errstr('');
                return 1;
            }
            else {
                if ( $dsn =~ /mysql/ ) {
                    DBI::errstr('unknown database');
                }
                elsif ( $dsn =~ /Pg/ ) {
                    DBI::errstr('not exist');
                }
                else {
                    DBI::errstr('');
                }
            }
        }
        elsif ( $password =~ /wrong/ ) {
            DBI::errstr('wrong password');
        }
        else {
            DBI::errstr('');
            return 1;
        }
        return;
    },
    do => sub {
        return 1;
    },
    errstr => sub {
        if (@_) {
            $Database::CheckConnectivity::_temp = shift;
        }
        else {
            return $Database::CheckConnectivity::_temp;
        }
    }
);

ok( check_connectivity( dsn => 'dbi:SQLite:database=xx;' ),
    'normal SQLite driver' );
ok( check_connectivity( dsn => 'dbi:Pg:database=xx;' ), 'normal pg driver' );
ok( check_connectivity( dsn => 'dbi:mysql:database=xx;' ),
    'normal mysql driver' );
ok( !check_connectivity( dsn => 'dbi:Pg:database=not_exist;' ),
    'pg with not_exist db' );
is( $Database::CheckConnectivity::ERROR, 'not exist', 'err' );
ok( !check_connectivity( dsn => 'dbi:mysql:database=not_exist;' ),
    'mysql with not_exist db' );
is( $Database::CheckConnectivity::ERROR, 'unknown database', 'err' );

ok(
    !check_connectivity(
        dsn      => 'dbi:Pg:database=xx;',
        password => 'wrong'
    ),
    'pg with wrong password'
);
is( $Database::CheckConnectivity::ERROR, 'wrong password', 'err' );

$Database::CheckConnectivity::AUTO_CREATE = 1;
ok( check_connectivity( dsn => 'dbi:Pg:database=not_exist;' ),
    'pg with not_exist db' );
is( $Database::CheckConnectivity::ERROR, '', 'err' );
