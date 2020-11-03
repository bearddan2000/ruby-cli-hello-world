package DockerFilePath;

our $basefile = "DockerFilePath.pm";
our $logfile = 'general.log';
our $timestamp = qx(date '+%Y-%m-%d %H:%M:%S');

our %platform = ("-u -c" => "/centos",
                 "-u -u" => "/ubuntu");

our %action = ("-u" => ".",
               "-d" => "down",
               "-h" => "help");

sub startup {
   my($path, $fh) = @_;
   my $lfh = $$fh;

   my $scope="startup";
   my $docker_img_name="ruby-cli-hello-world";
   my $info_base="[$timestamp INFO]: $basefile::$scope";

   print($lfh "$info_base started\n");

   print($lfh "$info_base build image from $path\n");

   print($lfh qx(sudo docker build -t $docker_img_name $path));

   print($lfh "$info_base running image\n");

   print($lfh qx(sudo docker run -ti --rm $docker_img_name));

   print($lfh "$info_base ended\n");
}

sub teardown {
   my $fh = shift;
   my $lfh = $$fh;
   my $scope="teardown";
   my $info_base="[$timestamp INFO]: $basefile::$scope";

   print($lfh "$info_base started\n");

   print($lfh "$info_base services removed\n");

   print($lfh "$info_base ended\n");
}

sub usage {
  $msg = "Usage\n";
  $msg .= "-u <PLATFORM> start\n";
  $msg .= "PLATFORM\n";
  $msg .= "<blank> alpine\n";
  $msg .= "-c centos\n";
  $msg .= "-u ubuntu\n";
  return $msg;
}

sub hash_sub {
  my ($opt, $hash_ref) = @_;
  my %hash = %{ $hash_ref };
    if(defined $hash{$opt}){
      return $hash{$opt};
    } else {
      print "key: $opt not found.\n";
      print &usage;
      exit 1;
    }
}

sub opt {
  my ($opt, $hash_ref) = @_;
  chomp($opt);
  return &hash_sub($opt, $hash_ref);
}

sub fire {
  my $line = shift;

  open my $fh, '>./general.log' or die "";

  if( (rindex $line, ".", 0) == 0 )
  {
    &startup($line, \$fh);
  }
  elsif ( $line eq "down" ){
    &teardown(\$fh);
  }
  else{
    print &usage;
  }

  close $fh;

  print(qx(grep OUTPUT general.log));
}

sub create{
  my $arr_ref = shift;
  my @arr = @{ $arr_ref };
  my $line = "";
  my $prior = "";
  for ( my $i = 0; $i < $#arr+1; $i++ ){
      if($i == 0) {
        $prior = $arr[$i];
        $line .= &opt($arr[$i], \%action);
      }
      elsif($i == 1) {
        $prior .= " " . $arr[$i];
        $line .= &opt($prior, \%platform);
      }
  }
  #print rindex $line, ".", 0 . "\n";
   &fire($line);
}

1;
