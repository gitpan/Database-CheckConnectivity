package Database::CheckConnectivity::Driver::Pg;

use warnings;
use strict;

sub system_database {
    return 'template1';
}

sub not_exist_error {
    return qr/not exist/i;
}

1;

__END__

=head1 NAME

Database::CheckConnectivity::Pg - 

=head1 INTERFACE

=over 4

=item system_database

return 'template1'

=item not_exist_error

return qr/not exist/

=back

=head1 AUTHOR

sunnavy  C<< <sunnavy@bestpractical.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright 2009 Best Practical Solutions.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

