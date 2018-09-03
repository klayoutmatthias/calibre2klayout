#!/usr/bin/env perl
##  ----------------------------------------------------------------------------
##                    Information
##  ----------------------------------------------------------------------------
##
##  File            : calibre2klayout.pl
##
##  Description     : Creates layer mapping file for klayout, using calibre layermap
##
##  Author          : N.J.H.M. van Beurden (nickvanbeurden@telfort.nl)
##
##  ----------------------------------------------------------------------------
##                    Revision History
##  ----------------------------------------------------------------------------
##
##  Date        Author  Revision  Change Description
##  ==========  ======  ========  ==============================================
##  2010-02-04   NvB      beta    Beta version
##
##  ----------------------------------------------------------------------------
##
##  Any modification of this file is unsupported and usage is at your own risk.
##

use strict;
use Switch;

# Version number
my $version="beta";

#################
# Get arguments #
#################

if (@ARGV eq 0)
{
 print("+-------------------------------------------------------------+\n");
 print("| Layer color creation for Klayout using calibre layer colors |\n");
 print("|                                                             |\n");
 print("| Use: calibre2klayout -input <calibre colorfile> [-verbose]  |\n");
 print("+-------------------------------------------------------------+\n");
} 

# Get the arguments
my %arguments;
my $i=1;
while (@ARGV ne 0) 
{
 # single argumented
 if ($ARGV[0] =~ m/-input$/i)
 {
  $arguments{$ARGV[0]} = $ARGV[1];
  shift;shift;
 }
 # option argument
 elsif ($ARGV[0] =~ m/-verbose$/i)
 {
  $arguments{$ARGV[0]} = 1;
  shift;
 }
 # invalid/unused arguments
 else
 {
  print("-> ERROR: Invalid argument $ARGV[0] !!!\n");
  die;
 }
}

# Assign the arguments to internal parameters
my $verbose=0;
my $input="";
my $output="";

if (exists ($arguments{"-verbose"}))          { $verbose=   $arguments{"-verbose"} };
if (exists ($arguments{"-input"}))            { $input=     $arguments{"-input"} };

# Exit when no input file specified
if (exists ($arguments{"-input"})==0)
{
 print("-> ERROR: Invalid argument specification.\n");
 print("->        Specify input file (-input)\n");
 die;
}

######################
# Generic procedures #
######################

# Verbose printing to screen
sub printverb ($)
{
 # Pop $@
 my $string=shift;

 # Print string is verbose option is specified
 if ($verbose == 1)
 {
  print($string);
 }
}

#################
# File Handling #
#################

# Some information about the script
printverb("-> Welcome, this is $0 version $version\n");

# Check if input file can be opened
if (open(INPUT_FILE, "<$input") == 0)
{  
 print("-> ERROR: Cannot open specified input file $input !\n");
 die;
}

my $output=$input . ".klayout";
# Check if output file can be opened
if (open(OUTPUT_FILE, ">$output") == 0)
{  
 print("-> ERROR: Cannot open output file $output !\n");
 die;
}

##############
# Processing #
##############
my @colorcodes   = qw(F0F8FF    FAEBD7       FFEFDB        EEDFCC        CDC0B0        8B8378        7FFFD4     76EEC6      66CDAA      458B74      F0FFFF E0EEEE C1CDCD 838B8B F5F5DC FFE4C4 EED5B7  CDB79E  8B7D6B  000000 FFEBCD         0000FF BFEFFF      0000EE B2DFEE      0000CD 9AC0CD      00008B 68838B      ADD8E6     8A2BE2     A52A2A FF4040 EE3B3B CD3333 8B2323 DEB887    FFD39B     EEC591     CDAA7D     8B7355     5F9EA0    98F5FF     8EE5EE     7AC5CD     53868B     7FFF00     76EE00      66CD00      458B00      D2691E    FF7F24     EE7621     CD661D     8B4513     FF7F50 FF7256 EE6A50 CD5B45 8B3E2F F08080      6495ED         FFF8DC   EEE8CD    CDC8B1    8B8878    00FFFF 00EEEE D1EEEE      00CDCD B4CDCD      008B8B 7A8B8B      E0FFFF     696969  1E90FF     1C86EE      1874CD      104E8B      B22222    FF3030     EE2C2C     CD2626     8B1A1A     FFFAF0      228B22      DCDCDC    F8F8FF     FFD700 FFD700 EEC900 CDAD00 8B7500 DAA520    FFC125     FFB90F          FFEC8B           EEB422     EEAD0E          EEDC82           CD9B1D     CD950C          CDBE70           8B6914     8B6508          8B814C           B8860B         EEDD82          EEE8AA         FAFAD2                BEBEBE  BEBEBE 030303 050505 080808 0A0A0A 0D0D0D 0F0F0F 121212 141414 171717 1A1A1A 1C1C1C 1F1F1F 212121 242424 262626 292929 2B2B2B 2E2E2E 303030 333333 363636 383838 3B3B3B 3D3D3D 404040 424242 454545 474747 4A4A4A 4D4D4D 4F4F4F 525252 545454 575757 595959 5C5C5C 5E5E5E 616161 636363 666666 6B6B6B 6E6E6E 707070 737373 757575 787878 7A7A7A 7D7D7D 7F7F7F 828282 858585 878787 8A8A8A 8C8C8C 8F8F8F 919191 949494 969696 999999 9C9C9C 9E9E9E A1A1A1 A3A3A3 A6A6A6 A8A8A8 ABABAB ADADAD B0B0B0 B3B3B3 B5B5B5 B8B8B8 BABABA BDBDBD BFBFBF C2C2C2 C4C4C4 C7C7C7 C9C9C9 CCCCCC CFCFCF D1D1D1 D4D4D4 D6D6D6 D9D9D9 DBDBDB DEDEDE E0E0E0 E3E3E3 E5E5E5 E8E8E8 EBEBEB EDEDED F0F0F0 F2F2F2 F7F7F7 FAFAFA FCFCFC A9A9A9 D3D3D3 00FF00 9AFF9A 00EE00 00CD00 7CCD7C 008B00 548B54 006400 90EE90 98FB98 ADFF2F F0FFF0 E0EEE0 C1CDC1 838B83 FF69B4 FF6EB4 EE6AA7 CD6090 8B3A62 CD5C5C FF6A6A EE6363 CD5555 8B3A3A FFFFF0 EEEEE0 CDCDC1 8B8B83 F0E68C FFF68F EEE685 CDC673 8B864E BDB76B E6E6FA FFF0F5 EEE0E5 CDC1C5 8B8386 7CFC00 FFFACD EEE9BF CDC9A5 8B8970 32CD32 FAF0E6 FF00FF EE00EE CD00CD 8B008B B03060 FF34B3 EE30A7 CD2990 8B1C62 191970 F5FFFA FFE4E1 EED5D2 CDB7B5 8B7D7B FFE4B5 FFDEAD EECFA1 CDB38B 8B795E 000080 FDF5E6 6B8E23 C0FF3E B3EE3A 9ACD32 698B22 CAFF70 BCEE68 A2CD5A 6E8B3D 556B2F FFA500 FF7F00 EE9A00 EE7600 CD8500 CD6600 8B5A00 8B4500 FF8C00 FF4500 EE4000 CD3700 8B2500 DA70D6 FF83FA BF3EFF E066FF EE7AE9 B23AEE D15FEE CD69C9 9A32CD B452CD 8B4789 68228B 7A378B 9932CC BA55D3 FFEFD5 FFDAB9 EECBAD CDAF95 8B7765 CD853F FFC0CB FFB5C5 FFAEB9 EEA9B8 EE1289 EEA2AD CD919E CD1076 CD8C95 8B636C 8B0A50 8B5F65 FF1493 FFB6C1 DDA0DD FFBBFF EEAEEE CD96CD 8B668B B0E0E6 A020F0 9B30FF AB82FF 912CEE 9F79EE 7D26CD 8968CD 551A8B 5D478B 9370DB FF0000 EE0000 CD0000 8B0000 BC8F8F FFC1C1 EEB4B4 CD9B9B 8B6969 4169E1 4876FF 436EEE 3A5FCD 27408B FA8072 FF8C69 EE8262 EE9572 CD7054 CD8162 8B4C39 8B5742 E9967A FFA07A F4A460 2E8B57 54FF9F C1FFC1 4EEE94 B4EEB4 43CD80 9BCD9B 698B69 8FBC8F 20B2AA 3CB371 FFF5EE EEE5DE CDC5BF 8B8682 A0522D FF8247 EE7942 CD6839 8B4726 87CEEB 87CEFF B0E2FF 7EC0EE 00B2EE A4D3EE 6CA6CD 009ACD 8DB6CD 4A708B 00688B 607B8B 00BFFF 87CEFA 6A5ACD 836FFF 7A67EE 6959CD 473C8B 483D8B 8470FF 7B68EE 708090 C6E2FF 97FFFF B9D3EE 8DEEEE 9FB6CD 79CDCD 6C7B8B 528B8B 2F4F4F 778899 FFFAFA EEE9E9 CDC9C9 8B8989 00FF7F 00EE76 00CD66 008B45 00FA9A 4682B4 63B8FF CAE1FF 5CACEE BCD2EE 4F94CD A2B5CD 36648B 6E7B8B B0C4DE D2B48C FFA54F EE9A49 8B5A2B D8BFD8 FFE1FF EED2EE CDB5CD 8B7B8B FF6347 EE5C42 CD4F39 8B3626 40E0D0 00F5FF BBFFFF 00E5EE AEEEEE 00C5CD 96CDCD 00868B 668B8B 00CED1 48D1CC AFEEEE EE82EE 9400D3 D02090 FF3E96 FF82AB EE3A8C EE799F CD3278 CD6889 8B2252 8B475D C71585 DB7093 F5DEB3 FFE7BA EED8AE CDBA96 8B7E66 FFFFFF F5F5F5 FFFF00 EEEE00 EEEED1 CDCD00 CDCDB4 8B8B00 8B8B7A FFFFE0);
my @colorstrings = qw(aliceblue antiquewhite antiquewhite1 antiquewhite2 antiquewhite3 antiquewhite4 aquamarine aquamarine2 aquamarine3 aquamarine4 azure  azure2 azure3 azure4 beige  bisque bisque2 bisque3 bisque4 black  blanchedalmond blue   blue1_light blue2  blue2_light blue3  blue3_light blue4  blue4_light blue_light blueviolet brown  brown1 brown2 brown3 brown4 burlywood burlywood1 burlywood2 burlywood3 burlywood4 cadetblue cadetblue1 cadetblue2 cadetblue3 cadetblue4 chartreuse chartreuse2 chartreuse3 chartreuse4 chocolate chocolate1 chocolate2 chocolate3 chocolate4 coral  coral1 coral2 coral3 coral4 coral_light cornflowerblue cornsilk cornsilk2 cornsilk3 cornsilk4 cyan   cyan2  cyan2_light cyan3  cyan3_light cyan4  cyan4_light cyan_light dimgray dodgerblue dodgerblue2 dodgerblue3 dodgerblue4 firebrick firebrick1 firebrick2 firebrick3 firebrick4 floralwhite forestgreen gainsboro ghostwhite gold   gold1  gold2  gold3  gold4  goldenrod goldenrod1 goldenrod1_dark goldenrod1_light goldenrod2 goldenrod2_dark goldenrod2_light goldenrod3 goldenrod3_dark goldenrod3_light goldenrod4 goldenrod4_dark goldenrod4_light goldenrod_dark goldenrod_light goldenrod_pale goldenrodyellow_light gray100 gray   gray01 gray02 gray03 gray04 gray05 gray06 gray07 gray08 gray09 gray10 gray11 gray12 gray13 gray14 gray15 gray16 gray17 gray18 gray19 gray20 gray21 gray22 gray23 gray24 gray25 gray26 gray27 gray28 gray29 gray30 gray31 gray32 gray33 gray34 gray35 gray36 gray37 gray38 gray39 gray40 gray42 gray43 gray44 gray45 gray46 gray47 gray48 gray49 gray50 gray51 gray52 gray53 gray54 gray55 gray56 gray57 gray58 gray59 gray60 gray61 gray62 gray63 gray64 gray65 gray66 gray67 gray68 gray69 gray70 gray71 gray72 gray73 gray74 gray75 gray76 gray77 gray78 gray79 gray80 gray81 gray82 gray83 gray84 gray85 gray86 gray87 gray88 gray89 gray90 gray91 gray92 gray93 gray94 gray95 gray97 gray98 gray99 gray_dark gray_light green green1_pale green2 green3 green3_pale green4 green4_pale green_dark green_light green_pale greenyellow honeydew honeydew2 honeydew3 honeydew4 hotpink hotpink1 hotpink2 hotpink3 hotpink4 indianred indianred1 indianred2 indianred3 indianred4 ivory ivory2 ivory3 ivory4 khaki khaki1 khaki2 khaki3 khaki4 khaki_dark lavender lavenderblush lavenderblush2 lavenderblush3 lavenderblush4 lawngreen lemonchiffon lemonchiffon2 lemonchiffon3 lemonchiffon4 limegreen linen magenta magenta2 magenta3 magenta_dark maroon maroon1 maroon2 maroon3 maroon4 midnightblue mintcream mistyrose mistyrose2 mistyrose3 mistyrose4 moccasin navajowhite navajowhite2 navajowhite3 navajowhite4 navy oldlace olivedrab olivedrab1 olivedrab2 olivedrab3 olivedrab4 olivegreen1_dark olivegreen2_dark olivegreen3_dark olivegreen4_dark olivegreen_dark orange orange1_dark orange2 orange2_dark orange3 orange3_dark orange4 orange4_dark orange_dark orangered orangered2 orangered3 orangered4 orchid orchid1 orchid1_dark orchid1_medium orchid2 orchid2_dark orchid2_medium orchid3 orchid3_dark orchid3_medium orchid4 orchid4_dark orchid4_medium orchid_dark orchid_medium papayawhip peachpuff peachpuff2 peachpuff3 peachpuff4 peru pink pink1 pink1_light pink2 pink2_deep pink2_light pink3 pink3_deep pink3_light pink4 pink4_deep pink4_light pink_deep pink_light plum plum1 plum2 plum3 plum4 powderblue purple purple1 purple1_medium purple2 purple2_medium purple3 purple3_medium purple4 purple4_medium purple_medium red red2 red3 red_dark rosybrown rosybrown1 rosybrown2 rosybrown3 rosybrown4 royalblue royalblue1 royalblue2 royalblue3 royalblue4 salmon salmon1 salmon2 salmon2_light salmon3 salmon3_light salmon4 salmon4_light salmon_dark salmon_light sandybrown seagreen seagreen1 seagreen1_dark seagreen2 seagreen2_dark seagreen3 seagreen3_dark seagreen4_dark seagreen_dark seagreen_light seagreen_medium seashell seashell2 seashell3 seashell4 sienna sienna1 sienna2 sienna3 sienna4 skyblue skyblue1 skyblue1_light skyblue2 skyblue2_deep skyblue2_light skyblue3 skyblue3_deep skyblue3_light skyblue4 skyblue4_deep skyblue4_light skyblue_deep skyblue_light slateblue slateblue1 slateblue2 slateblue3 slateblue4 slateblue_dark slateblue_light slateblue_medium slategray slategray1 slategray1_dark slategray2 slategray2_dark slategray3 slategray3_dark slategray4 slategray4_dark slategray_dark slategray_light snow snow2 snow3 snow4 springgreen springgreen2 springgreen3 springgreen4 springgreen_medium steelblue steelblue1 steelblue1_light steelblue2 steelblue2_light steelblue3 steelblue3_light steelblue4 steelblue4_light steelblue_light tan tan1 tan2 tan4 thistle thistle1 thistle2 thistle3 thistle4 tomato tomato2 tomato3 tomato4 turquoise turquoise1 turquoise1_pale turquoise2 turquoise2_pale turquoise3 turquoise3_pale turquoise4 turquoise4_pale turquoise_dark turquoise_medium turquoise_pale violet violet_dark violetred violetred1 violetred1_pale violetred2 violetred2_pale violetred3 violetred3_pale violetred4 violetred4_pale violetred_medium violetred_pale wheat wheat1 wheat2 wheat3 wheat4 white whitesmoke yellow yellow2 yellow2_light yellow3 yellow3_light yellow4 yellow4_light yellow_light);
my %colors;
my $line="";
my $layer="";
my $calcolor="";
my $color="";
my $fill="";
my $name="";
my $visible="";
my $width="";

print OUTPUT_FILE "\<\?xml version\=\"1.0\"\?>\n";
print OUTPUT_FILE "\<layer-properties\>\n";
while ($line=<INPUT_FILE>) 
{
 if ($line =~ m/^([\d\.]+)\s+(\w+)\s+(\w+)\s+(\w+)\s+(\d+)\s+(\d+)$/) { 
  $layer=$1;
  $color=$2;
  $fill=$3;
  $name=$4;
  $visible=$5;
  $width=$6;
 
  printverb("-> layer: $layer color: $color fill: $fill name: $name visible: $visible width: $width\n");
  $layer =~ s/\./\//;
  $name = $layer . " " . $name;
  for ($i=0; $i < $#colorcodes; $i++)
  { 
   $colors{$colorstrings[$i]} = $colorcodes[$i];
  } 
  $calcolor=$color;
  $color=$colors{$color}; 
  $color=~ tr/A-Z/a-z/;
  if ($calcolor eq "") 
  {
   printverb("-> WARNING: Color $calcolor is not known, please contact nick.van.beurden\@nxp.com\n");
  }
 
  switch ($fill) {
   # Solid
   case "solid"         { $fill="I0" }
   # No fill
   case "clear"         { $fill="I1" }
   # Dots dense
   case "speckle"       { $fill="I2" }
   # Dots
   case "light_speckle" { $fill="I3" }
   # Diagonal /
   case "diagonal_1"    { $fill="I4" }
   # Diagonal \
   case "diagonal_2"    { $fill="I8" }
   # square waves
   case "brick"         { $fill="I28" }
   # Crosses
   case "wave"          { $fill="I14" }
   # Circles
   case "circles"       { $fill="I31" }
   # OTHERS
   else                 { printverb("Fill type $fill is unknown, please contact nick.van.beurden\@nxp.com\n"); $fill="I0" }
  }

  if ($visible == "1")
  { 
   $visible = "true"
  } 
  else
  { 
   $visible = "false"
  } 
 
  print OUTPUT_FILE "\<properties\>\n";
  print OUTPUT_FILE " \<frame\-color\>\#$color\<\/frame\-color\>\n";
  print OUTPUT_FILE " \<fill\-color\>\#$color\<\/fill\-color\>\n";
  print OUTPUT_FILE " \<frame\-brightness\>0<\/frame\-brightness\>\n";
  print OUTPUT_FILE " \<fill\-brightness\>0<\/fill\-brightness\>\n";
  print OUTPUT_FILE " \<dither\-pattern\>$fill<\/dither\-pattern\>\n";
  print OUTPUT_FILE " \<visible>$visible\<\/visible\>\n";
  print OUTPUT_FILE " \<transparent\>false<\/transparent\>\n";
  print OUTPUT_FILE " \<width>$width\<\/width\>\n";
  print OUTPUT_FILE " \<marked\>false<\/marked\>\n";
  print OUTPUT_FILE " \<animation\>0<\/animation\>\n";
  print OUTPUT_FILE " \<name\>$name\<\/name\>\n";
  print OUTPUT_FILE " \<source\>$layer\@1\<\/source\>\n";
  print OUTPUT_FILE "\<\/properties\>\n";
 }
}
print OUTPUT_FILE "\<\/layer-properties\>\n";

# Close the input file
close(OUTPUT_FILE);
close(INPUT_FILE);

# Done
printverb("-> All done ...\n");
