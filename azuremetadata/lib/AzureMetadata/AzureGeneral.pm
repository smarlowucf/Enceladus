#Copyright (C) 2015 SUSE LLC
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
# or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
package AzureGeneral;

use strict;
use warnings;

use XML::LibXML;

our @ISA    = qw (Exporter);
our @EXPORT_OK = qw (
    get_instance_name
    get_instance_incarnation_tag
    get_instance_id
);

sub get_instance_name {
    my $xml = shift;
    my @instances = $xml->getElementsByTagName('Instance');
    my $name = $instances[0]->getAttribute('id');
    return $name;
}

sub get_incarnation_instance_id {
    my $xml = shift;
    my @incarnation = $xml->getElementsByTagName('Incarnation');
    my $id = $incarnation[0]->getAttribute('instance');
    return $id;
}

sub get_instance_id {
    my $smbios = qx(dmidecode | grep UUID | cut -c8-);
    my $id = _fixup_guid_endianness($smbios);
    return $id;
}

sub _fixup_guid_endianness {
    # /.../
    # Convert a string in the expected format, into 16 bytes,
    # emulating .Net's Guid constructor
    # ----
    my $id   = shift;
    chomp($id);
    my $hx   = '[0-9a-f]';
    if ($id !~ /^($hx{8})-($hx{4})-($hx{4})-($hx{4})-($hx{12})$/i) {
        return;
    }
    my @parts = split (/-/,$id);
    #==========================================
    # pack into signed long 4 byte
    #------------------------------------------
    my $p1 = $parts[0];
    $p1 = pack   'H*', $p1;
    $p1 = unpack 'l>', $p1;
    $p1 = pack   'l' , $p1;
    $p1 = unpack 'H*', $p1;
    #==========================================
    # pack into unsigned short 2 byte
    #------------------------------------------
    my $p2 = $parts[1];
    $p2 = pack   'H*', $p2;
    $p2 = unpack 'S>', $p2;
    $p2 = pack   'S' , $p2;
    $p2 = unpack 'H*', $p2;
    #==========================================
    # pack into unsigned short 2 byte
    #------------------------------------------
    my $p3 = $parts[2];
    $p3 = pack   'H*', $p3;
    $p3 = unpack 'S>', $p3;
    $p3 = pack   'S' , $p3;
    $p3 = unpack 'H*', $p3;
    #==========================================
    # pack into hex string (high nybble first)
    #------------------------------------------
    my $p4 = $parts[3];
    my $p5 = $parts[4];
    #==========================================
    # concat result and return
    #------------------------------------------
    my $guid = "$p1-$p2-$p3-$p4-$p5";
    return $guid;
}

1;
