use ExtUtils::MakeMaker;

my @TEST_TARGET = qw{ t/*.t t/*/*.t };

WriteMakefile(
    NAME => 'Amon2::Plugin::DataValidator',
    VERSION_FROM => 'lib/Amon2/Plugin/DataValidator.pm',
    ABSTRACT => 'Amon2::Plugin::DataValidator',
    PREREQ_PM => {
        'ExtUtils::MakeMaker' => 6.31,
        'ExtUtils::Install'   => 1.46,

        'Amon2'               => 3.32,
        'Data::Validator'     => 0.09,
    },
    test => {
        TESTS => join( ' ', @TEST_TARGET ),
    },
    LICENSE => 'perl',
);
