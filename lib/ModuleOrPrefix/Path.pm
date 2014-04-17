package ModuleOrPrefix::Path;

use 5.010001;
use strict;
use warnings;
use File::Basename 'dirname';

our $VERSION = '0.01'; # VERSION
our $DATE = '2014-04-17'; # DATE

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw(module_or_prefix_path);

my $SEPARATOR;

BEGIN {
    if ($^O =~ /^(dos|os2)/i) {
        $SEPARATOR = '\\';
    } elsif ($^O =~ /^MacOS/i) {
        $SEPARATOR = ':';
    } else {
        $SEPARATOR = '/';
    }
}

sub module_or_prefix_path {
    my $module = shift;
    my $relpath;
    my $fullpath;

    ($relpath = $module) =~ s/::/$SEPARATOR/g;
    $relpath .= '.pm' unless $relpath =~ m!\.pm$!;

    my $relpathp = $relpath;
    $relpathp =~ s/\.pm$//;

    for my $which ('f', 'd') {
        foreach my $dir (@INC) {
            next if ref($dir);

            if ($which eq 'f') {
                $fullpath = $dir . $SEPARATOR . $relpath;
                return $fullpath if -f $fullpath;
            } else {
                $fullpath = $dir . $SEPARATOR . $relpathp;
                return $fullpath . $SEPARATOR if -d $fullpath;
            }
        }
    }

    return undef;
}

1;
# ABSTRACT: Get the full path to a locally installed module or prefix

__END__

=pod

=encoding UTF-8

=head1 NAME

ModuleOrPrefix::Path - Get the full path to a locally installed module or prefix

=head1 VERSION

version 0.01

=head1 SYNOPSIS

 use ModuleOrPrefix::Path qw(module_or_prefix_path);

 say module_or_prefix_path('Test::More');  # "/path/to/Test/More.pm"
 say module_or_prefix_path('Test');        # "/path/to/Test.pm"
 say module_or_prefix_path('File::Slurp'); # "/path/to/File/Slurp.pm"
 say module_or_prefix_path('File');        # "/path/to/File/"
 say module_or_prefix_path('Foo');         # undef

=head1 DESCRIPTION

The code is based on Neil Bower's L<Module::Path>.

=head1 FUNCTIONS

=head2 module_or_prefix_path($mod) => STR

=head1 SEE ALSO

L<Module::Path>

=head1 HOMEPAGE

Please visit the project's homepage at L<https://metacpan.org/release/ModuleOrPrefix-Path>.

=head1 SOURCE

Source repository is at L<https://github.com/sharyanto/perl-ModuleOrPrefix-Path>.

=head1 BUGS

Please report any bugs or feature requests on the bugtracker website L<https://rt.cpan.org/Public/Dist/Display.html?Name=ModuleOrPrefix-Path>

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
