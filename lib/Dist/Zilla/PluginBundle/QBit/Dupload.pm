package Dist::Zilla::PluginBundle::QBit::Dupload;

use Moose;
with 'Dist::Zilla::Role::PluginBundle::Easy';

use namespace::autoclean;

sub configure {
    my ($self) = @_;

    $self->add_plugins(
        ['GatherDir'  => {include_dotfiles => 1,               exclude_match => '^\.git'}],
        ['PruneCruft' => {except           => ['\.perltidyrc', '\.proverc']}],
        'AutoPrereqs',

        'Git::Init',
        'Git::Check',
        ['Git::NextVersion'                     => {first_version => 0.001, version_regexp => '^([0-9.]+)$'}],
        ['ChangelogFromGit::Debian::Sequential' => {tag_regexp    => '^(\d+.*)$'}],

        'License',
        'Readme',
        'MetaYAML',
        'ExecDir',
        'ShareDir',
        'Manifest',
        'MakeMaker',

        'OurPkgVersion',

        ($self->payload->{'from_test'} ? () : 'ConfirmRelease'),
        ($self->payload->{'from_test'} ? ['Release::DuploadDist' => {test_release => 1}] : 'Release::DuploadDist'),

        [
            'Git::Commit' => {
                changelog   => 'debian/changelog',
                commit_msg  => 'Version %v',
                allow_dirty => ['debian/changelog', 'debian/control']
            }
        ],
        ['Git::Tag' => {tag_format => '%v'}],

        ($self->payload->{'from_test'} ? () : 'Git::Push')
    );
}

__PACKAGE__->meta->make_immutable;

__END__

=pod

=head1 NAME

Dist::Zilla::PluginBundle::QBit::Dupload - build and release Dupload QBit Framework packages

=head1 DESCRIPTION

It does not generate debian/* files, you must create them by yourself in advance.

=head1 AUTHOR

Dmitry Lukiyanchuk <wtertius@gmail.com>

=cut
