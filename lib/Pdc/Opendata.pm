package Opendata;
use Modern::Perl;
use JSON::MaybeXS;
use File::Find::Rule;


sub extract_metadata_from_md {
  my ($md_filename) = @_;
  my $json_data;
  open my $fh, '<', "$md_filename";
  while (<$fh>) {
    $json_data .= $_ if /^\s*{/ .. 0;
    last if /}\s*$/;
  }
  close $fh;

  my $json_obj = JSON->new();
  my $perl_data = $json_obj->decode("$json_data");
  return %{$perl_data};
}

1;