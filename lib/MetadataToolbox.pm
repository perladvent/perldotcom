package MetadataToolbox;
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

sub browse_articles_metadata_from {
  my $directory_to_browse = shift;
  return map { my $filename = "$_";$filename => extract_metadata_from_md("$filename") } File::Find::Rule->file->name('*.md')->in("$directory_to_browse");
}

sub build_categories_registry {
  my ($registry, $repository) = @_;
  my %categories_registry;
  foreach my $filename (keys %{$registry}){
    my $current_category = $registry->{$filename}->{'categories'};
    if (exists $categories_registry{$current_category}){
      push @{$categories_registry{$current_category}}, "$filename";
    }
    else {
      $categories_registry{$current_category} = [ "$filename" ];
    }
  }
  my $json_data = JSON::MaybeXS->new(pretty => 1);
  my $categories_registry_json_format = $json_data->encode(\%categories_registry);
  open my $ofh, '>', "$repository/categories.json";
  print $ofh $categories_registry_json_format;
  close $ofh;
  return 1;
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