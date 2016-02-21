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
        # metacpan.org/pod/PKG
        {
            args => {url=>'https://metacpan.org/pod/Foo::Bar'},
            result => 'Foo::Bar',
        },
        {
            args => {url=>'http://metacpan.org/pod/Foo'},
            result => 'Foo',
        },

        # metacpan.org/module/PKG
        {
            args => {url=>'https://metacpan.org/module/Foo::Bar'},
            result => 'Foo::Bar',
        },

        # metacpan.org/release/DIST
        {
            args => {url=>'https://metacpan.org/release/Foo-Bar'},
            result => 'Foo::Bar',
        },

        # metacpan.org/release/AUTHOR/RELEASE
        {
            args => {url=>'https://metacpan.org/release/PAUSEID/Foo-Bar-1.23'},
            result => 'Foo::Bar',
        },

        # metacpan.org/pod/release/PAUSEID/RELEASE/lib/PKG.pm
        {
            args => {url=>'https://metacpan.org/pod/release/SMONF/Dependencies-Searcher-0.066_001/lib/Dependencies/Searcher.pm'},
            result => 'Dependencies::Searcher',
        },
        {
            args => {url=>'http://metacpan.org/pod/release/SRI/Mojolicious-6.46/lib/Mojo.pm'},
            result => 'Mojo',
        },

        # search.cpan.org/~PAUSEID/RELEASE/lib/PKG.pm
        {
            args => {url=>'http://search.cpan.org/~unera/DR-SunDown-0.02/lib/DR/SunDown.pm'},
            result => 'DR::SunDown',
        },
        {
            args => {url=>'https://search.cpan.org/~sri/Mojolicious-6.47/lib/Mojo.pm'},
            result => 'Mojo',
        },

        # search.cpan.org/dist/DIST
        {
            args => {url=>'http://search.cpan.org/dist/Foo-Bar/'},
            result => 'Foo::Bar',
        },

        # search.cpan.org/perldoc?MOD
        {
            args => {url=>'http://search.cpan.org/perldoc?Foo::Bar'},
            result => 'Foo::Bar',
        },
        {
            args => {url=>'http://search.cpan.org/perldoc?Foo'},
            result => 'Foo',
        },

        {
            args => {url=>'https://www.google.com/'},
            result => undef,
        },
    ],
};
sub extract_module_from_cpan_url {
    my $url = shift;

    # note: /module is the old URL
    if ($url =~ m!\Ahttps?://metacpan\.org/(?:pod|module)/(\w+(?:::\w+)*)\z!) {
        return $1;
    }

    if ($url =~ m!\Ahttps?://metacpan\.org/pod/release/[^/]+/[^/]+/lib/((?:[^/]+/)*\w+)\.pm\z!) {
        my $mod = $1;
        $mod =~ s!/!::!g;
        return $mod;
    }

    if ($url =~ m!\Ahttps?://metacpan\.org/release/(\w+(?:-\w+)*)/?\z!) {
        my $mod = $1;
        $mod =~ s!-!::!g;
        return $mod;
    }

    if ($url =~ m!\Ahttps?://metacpan\.org/release/[^/]+/(\w+(?:-\w+)*)-\d[^-]*/?\z!) {
        my $mod = $1;
        $mod =~ s!-!::!g;
        return $mod;
    }

    if ($url =~ m!\Ahttps?://search\.cpan\.org/~[^/]+/[^/]+/lib/((?:[^/]+/)*\w+).pm\z!) {
        my $mod = $1;
        $mod =~ s!/!::!g;
        return $mod;
    }

    if ($url =~ m!\Ahttps?://search\.cpan\.org/dist/([A-Za-z0-9_-]+)/?\z!) {
        my $mod = $1;
        $mod =~ s!-!::!g;
        return $mod;
    }

    if ($url =~ m!\Ahttps?://search\.cpan\.org/perldoc\?(\w+(?:::\w+)*)\z!) {
        return $1;
    }

    undef;
}

1;
# ABSTRACT:
