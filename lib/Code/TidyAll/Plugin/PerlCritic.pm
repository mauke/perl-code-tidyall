package Code::TidyAll::Plugin::PerlCritic;

use strict;
use warnings;

use IPC::Run3 qw(run3);
use Text::ParseWords qw(shellwords);

use Moo;

extends 'Code::TidyAll::Plugin';

our $VERSION = '0.64';

# On Windows only the batch file is actually executable.
my $cmd = $^O eq 'MSWin32' ? 'perlcritic.bat' : 'perlcritic';
sub _build_cmd {$cmd}

sub validate_file {
    my ( $self, $file ) = @_;

    my @cmd = ( $self->cmd, shellwords( $self->argv ), $file );
    my $output;
    run3( \@cmd, \undef, \$output, \$output );
    die "$output\n" if $output !~ /^.* source OK\n/s;
}

1;

# ABSTRACT: Use perlcritic with tidyall

__END__

=pod

=head1 SYNOPSIS

   In configuration:

   ; Configure in-line
   ;
   [PerlCritic]
   select = lib/**/*.pm
   argv = --severity 5 --exclude=nowarnings

   ; or refer to a .perlcriticrc in the same directory
   ;
   [PerlCritic]
   select = lib/**/*.pm
   argv = --profile $ROOT/.perlcriticrc

=head1 DESCRIPTION

Runs L<perlcritic>, a Perl validator, and dies if any problems were found.

=head1 INSTALLATION

Install perlcritic from CPAN.

    cpanm perlcritic

=head1 CONFIGURATION

=over

=item argv

Arguments to pass to perlcritic

=back
