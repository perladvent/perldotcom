package Pdc::Opendata;
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
  return $perl_data;
}

sub _extract_data_with_meta {
  my ($meta, $metadata) = @_;

  return $metadata->{$meta};
}

sub extract_tags_from_metadata {
  my $metadata = shift;
  my @tags = @{_extract_data_with_meta('tags', $metadata)};
  return @tags;
}

sub extract_authors_from_metadata {
  my $metadata = shift;
  my @authors = @{_extract_data_with_meta('authors', $metadata)};
  return @authors;
}

sub extract_category_from_metadata {
  my $metadata = shift;
  my $category = _extract_data_with_meta('categories', $metadata);
  return $category;
}

1;