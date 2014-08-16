requires 'Amon2', '6.09';
requires 'HTML::FillInForm::Lite', '1.11';
requires 'JSON', '2.50';
requires 'Module::Functions', '2';
requires 'Plack::Middleware::ReverseProxy', '0.09';
requires 'Router::Boom', '0.06';
requires 'Starlet', '0.20';
requires 'Test::WWW::Mechanize::PSGI';
requires 'Text::Xslate', '2.0009';
requires 'Time::Piece', '1.20';
requires 'perl', '5.010_001';
requires 'DBD::mysql', '4.028';
requires 'DBD::SQLite', '1.33';
requires 'DBIx::Sunny', '0.22';
requires 'Mouse', '2.3.0';
requires 'Log::Minimal', '0.19';
requires 'Digest::SHA1', '2.13';

on configure => sub {
    requires 'Module::Build', '0.38';
    requires 'Module::CPANfile', '0.9010';
};

on test => sub {
    requires 'Test::More', '0.98';
    requires 'File::Find::Rule';
    requires 'Path::Tiny';
};
