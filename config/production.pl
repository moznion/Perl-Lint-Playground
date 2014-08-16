my $env = 'production';

+{
    'DBI' => [
        "dbi:mysql:database=perl_lint_playground_$env:mysql_socket=/var/lib/mysql/mysql.sock", '', '',
        +{
            mysql_enable_utf8 => 1 ,
            mysql_auto_reconnect => 1,
            RaiseError => 1,
        },
    ],
};
