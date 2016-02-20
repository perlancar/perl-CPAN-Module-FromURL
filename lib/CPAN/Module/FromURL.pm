package CPAN::Module::FromURL;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Exporter qw(import);
our @EXPORT_OK = qw(extract_module_from_cpan_url);

our %SPEC;

$SPEC{extract_module_from_cpan_url} = {
    v => 1.1,
    summary => 'Detect and extract module name from some CPAN-related URL',
    args => {
        url => {
            schema => 'str*',
            req => 1,
            pos => 0,
        },
    },
    args_as => 'array',
    result => {
        schema => 'str',
    },
    result_naked => 1,
    examples => [
        {
            args => {url=>'https://metacpan.org/pod/Foo::Bar'},
            result => 'Foo::Bar',
            test => 0, # TMP: there's still a bug in testri?
        },
        {
            args => {url=>'https://metacpan.org/pod/release/SMONF/Dependencies-Searcher-0.066_001/lib/Dependencies/Searcher.pm'},
            result => 'Dependencies::Searcher',
            test => 0, # TMP: there's still a bug in testri?
        },
        {
            args => {url=>'https://www.google.com/'},
            result => undef,
            test => 0, # TMP: there's still a bug in testri?
        },
    ],
};
sub extract_module_from_cpan_url {
    my $url = shift;

    if ($url =~ m!\Ahttps?://metacpan\.org/pod/(\w+(?:::\w+)*)\z!i) {
        return $1;
    }

    if ($url =~ m!\Ahttps?://metacpan\.org/pod/release/[^/]+/[^/]+/lib/((?:[^/]+/)*\w+)\.pm\z!i) {
        my $mod = $1;
        $mod =~ s!/!::!g;
        return $mod;
    }

    if ($url =~ m!\Ahttps?://search\.cpan\.org/~[^/]+/[^/]+/lib/((?:[^/]+/)*\w+).pm\z!i) {
        my $mod = $1;
        $mod =~ s!/!::!g;
        return $mod;
    }

    undef;
}

1;
# ABSTRACT:
