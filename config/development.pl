my $env = 'development';

+{
    'DBI' => [
        "dbi:mysql:database=perl_lint_playground_$env", '', '',
        +{
            mysql_enable_utf8 => 1 ,
            mysql_auto_reconnect => 1,
            RaiseError => 1,
        },
    ],
};
