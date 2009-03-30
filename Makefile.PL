use inc::Module::Install;

name     'Database-CheckConnectivity';
all_from 'lib/Database/CheckConnectivity.pm';
author   'sunnavy <sunnavy@bestpractical.com>';
license  'perl';

build_requires 'Test::More';
build_requires 'Test::MockModule';
requires 'DBI';
requires 'Params::Validate';
requires 'UNIVERSAL::require';
recursive_author_tests( 'xt' );
auto_install;

WriteAll;

