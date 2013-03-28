use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

( do 'maint/Makefile.PL.include' or die $@ ) unless -f 'META.yml';

my %BUILD_DEPS = (
    'Test::InDistDir' => 0,
    'Test::More'      => 0,
    'Test::Fatal'     => 0,
);

my %RUN_DEPS = (
    'Moo'          => 1.001000,
    'strictures'   => 0,
    'Scalar::Util' => 0,
);

# have to do this since old EUMM dev releases miss the eval $VERSION line
my $mymeta_works = do { no warnings; $ExtUtils::MakeMaker::VERSION >= 6.5707 };
my $mymeta       = do { no warnings; $ExtUtils::MakeMaker::VERSION >= 6.5702 };

my %extra_info = ( resources => { repository => 'git://git.shadowcat.co.uk/gitmo/Moo.git' } );

WriteMakefile(
    NAME         => 'MooX::OneArgHas',
    VERSION_FROM => 'lib/MooX/OneArgHas.pm',
    PREREQ_PM    => { %RUN_DEPS, ( $mymeta_works ? () : ( %BUILD_DEPS ) ), },
    (
        $mymeta_works ? (    # BUILD_REQUIRES makes MYMETA right, requires stops META being wrong
            BUILD_REQUIRES => \%BUILD_DEPS,
            META_ADD       => { requires => \%RUN_DEPS, %extra_info }
          )
        : (                  # META_ADD both to get META right - only Makefile written
            META_ADD => {
                requires       => \%RUN_DEPS,
                build_requires => \%BUILD_DEPS,
                %extra_info,
            }
        )
    ),
    ( $mymeta && !$mymeta_works ? ( NO_MYMETA => 1 ) : () ),
    LICENSE => 'perl',
);
