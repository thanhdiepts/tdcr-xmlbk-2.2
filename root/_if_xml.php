#!/usr/local/bin/php -f
<?php
require_once("/etc/inc/shaper.inc");
$hostname            = $config['system']['hostname'];
$pconfig['hostname'] = $config['system']['hostname'];

echo ".";
$ifacesXML  = new SimpleXMLElement("<ifaces></ifaces>");
$ifcaceDate = $ifacesXML->addChild('datetime', date('H:i:s d/m/Y'));
$i          = 0;
$ifdescrs   = get_configured_interface_with_descr(false, true);
foreach ($ifdescrs as $ifdescr => $ifname) {
    $ifaceXML = $ifacesXML->addChild('iface');
    
    $ifinfo      = get_interface_info($ifdescr);
    $ifnameXML   = $ifaceXML->addChild('Name', htmlspecialchars($ifname));
    $ifDescXML   = $ifaceXML->addChild('Desc', htmlspecialchars($ifdescr));
    $ifHwXML     = $ifaceXML->addChild('HWIF', htmlspecialchars($ifinfo['hwif']));
    $ifStatusXML = $ifaceXML->addChild('Status', htmlspecialchars($ifinfo['status']));
    if ($ifinfo['dhcplink'])
        $ifDHCPXML = $ifaceXML->addChild('DHCP', htmlspecialchars($ifinfo['dhcplink']));
    
    if ($ifinfo['dhcp6link'])
        $ifDHCP6XML = $ifaceXML->addChild('DHCP6', htmlspecialchars($ifinfo['dhcp6link']));
    
    if ($ifinfo['pppoelink'])
        $ifPPPoEXML = $ifaceXML->addChild('PPPoE', htmlspecialchars($ifinfo['pppoelink']));
    
    if ($ifinfo['status'] == "up" && $ifinfo['ppp_uptime'] || $ifinfo['ppp_uptime_accumulated'])
    //                                      $uptime="Uptime".($ifinfo['ppp_uptime_accumulated']?(historical):"");
        $uptime = "Uptime";
    //                                      $uptime2=htmlspecialchars($ifinfo['ppp_uptime']).htmlspecialchars($ifinfo['ppp_uptime_accumulated']);
    $uptime2 = htmlspecialchars($ifinfo['ppp_uptime']);
    
    $ifPPPUptimeXML = $ifaceXML->addChild("Uptime", $uptime2);
    if ($ifinfo['macaddr'] && !($ifinfo['pppoelink'])) {
        $mac      = $ifinfo['macaddr'];
        $ifMACXML = $ifaceXML->addChild("MAC_Address", htmlspecialchars($mac));
    }
    if ($ifinfo['status'] != "down" && $ifinfo['dhcplink'] != "down" && $ifinfo['pppoelink'] != "down" && $ifinfo['pptplink'] != "down")
        if ($ifinfo['ipaddr'])
            $ifIPXML = $ifaceXML->addChild("IPv4_address", htmlspecialchars($ifinfo['ipaddr']));
    
    if ($ifinfo['subnet'])
        $ifSubmaskXML = $ifaceXML->addChild("Subnet_Mask_IPv4", htmlspecialchars($ifinfo['subnet']));
    
    if ($ifinfo['gateway'])
        $ifGWXML = $ifaceXML->addChild("Gateway_IPv4", htmlspecialchars($config['interfaces'][$ifdescr]['gateway']) . htmlspecialchars($ifinfo['gateway']));
    
    if ($ifdescr == "wan" && file_exists("{$g['varetc_path']}/resolv.conf") && $ifinfo['status'] == "up") {
        $dns_servers = get_dns_servers();
        $dns_list    = "";
        foreach ($dns_servers as $dns)
            $dns_list .= $dns . "<br />";
        
        $ifDNSXML = $ifaceXML->addChild("ISP_DNS_servers", htmlspecialchars($dns_list));
    }
    if ($ifinfo['mtu'] && $ifinfo['status'] == "up")
        $ifMTUXML = $ifaceXML->addChild("MTU", htmlspecialchars($ifinfo['mtu']));
    
    if ($ifinfo['media'])
        $ifMediaXML = $ifaceXML->addChild("Media", htmlspecialchars($ifinfo['media']));
    if ($ifinfo['status'] == "up") {
        $ifIOPacketXML = $ifaceXML->addChild("InOut_Packets", htmlspecialchars($ifinfo['inpkts'] . "/" . $ifinfo['outpkts'] . " (" . format_bytes($ifinfo['inbytes']) . "/" . format_bytes($ifinfo['outbytes']) . ")"));
        $ifIOPassXML   = $ifaceXML->addChild("InOut_Packets_Pass", htmlspecialchars($ifinfo['inpktspass'] . "/" . $ifinfo['outpktspass'] . " (" . format_bytes($ifinfo['inbytespass']) . "/" . format_bytes($ifinfo['outbytespass']) . ")"));
        $ifIOBlockXML  = $ifaceXML->addChild("InOut_Packets_Block", htmlspecialchars($ifinfo['inpktsblock'] . "/" . $ifinfo['outpktsblock'] . " (" . format_bytes($ifinfo['inbytesblock']) . "/" . format_bytes($ifinfo['outbytesblock']) . ")"));
    }
    
    if (isset($ifinfo['inerrs']) && $ifinfo['status'] == "up")
        $ifIOErrorXML = $ifaceXML->addChild("InOut_Errors", htmlspecialchars($ifinfo['inerrs'] . "/" . $ifinfo['outerrs']));
    if (isset($ifinfo['collisions']) && $ifinfo['status'] == "up")
        $ifCollisionsXML = $ifaceXML->addChild("Collisions", htmlspecialchars($ifinfo['collisions']));
    
    
    $i++;
}
$ifacesXML->asXml($hostname . '.xml');
?>
