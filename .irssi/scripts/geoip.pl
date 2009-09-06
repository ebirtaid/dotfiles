<html>
<head>
<title>~/.irssi/scripts/geoip.pl.html</title>
<meta name="Generator" content="Vim/6.2">
<meta http-equiv="content-type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="#808080" text="#ffffff">
<pre>
<font color="#00ffff"><b># Print the country name in /WHOIS replies</b></font>
<font color="#00ffff"><b># /GEOIP &lt;ip/host&gt; prints the country name for the host/ip</b></font>
<font color="#00ffff"><b># /SET geoip_dat /full/path/to/GeoIP.dat</b></font>
<font color="#00ffff"><b>#</b></font>
<font color="#00ffff"><b># <A HREF="http://www.maxmind.com/download/geoip/database/GeoIP.dat.gz">http://www.maxmind.com/download/geoip/database/GeoIP.dat.gz</A></b></font>

<font color="#ffff00"><b>use strict</b></font>;
<font color="#ffff00"><b>use </b></font>Geo::IP;
<font color="#ffff00"><b>use </b></font>Irssi;
<font color="#ffff00"><b>use </b></font>Socket;

<font color="#ffff00"><b>use vars</b></font> <font color="#ff40ff"><b>qw(</b></font><font color="#ff40ff"><b>$VERSION %IRSSI</b></font><font color="#ff40ff"><b>)</b></font>;
<font color="#00ffff"><b>$VERSION</b></font> = <font color="#ff40ff"><b>&quot;</b></font><font color="#ff40ff"><b>0.0.3</b></font><font color="#ff40ff"><b>&quot;</b></font>;
<font color="#00ffff"><b>%IRSSI</b></font> = (
    <font color="#ff40ff"><b>authors         </b></font>=&gt; <font color="#ff40ff"><b>&quot;</b></font><font color="#ff40ff"><b>Toni Viemerö</b></font><font color="#ff40ff"><b>&quot;</b></font>,
    <font color="#ff40ff"><b>contact         </b></font>=&gt; <font color="#ff40ff"><b>&quot;</b></font><font color="#ff40ff"><b>toni.viemero</b></font><font color="#ff6060"><b>\@</b></font><font color="#ff40ff"><b>iki.fi</b></font><font color="#ff40ff"><b>&quot;</b></font>,
    <font color="#ff40ff"><b>name            </b></font>=&gt; <font color="#ff40ff"><b>&quot;</b></font><font color="#ff40ff"><b>geoip</b></font><font color="#ff40ff"><b>&quot;</b></font>,
    <font color="#ff40ff"><b>description     </b></font>=&gt; <font color="#ff40ff"><b>&quot;</b></font><font color="#ff40ff"><b>Print the users country name in /WHOIS replies</b></font><font color="#ff40ff"><b>&quot;</b></font>,
    <font color="#ff40ff"><b>license         </b></font>=&gt; <font color="#ff40ff"><b>&quot;</b></font><font color="#ff40ff"><b>Public Domain</b></font><font color="#ff40ff"><b>&quot;</b></font>,
    <font color="#ff40ff"><b>changed         </b></font>=&gt; <font color="#ff40ff"><b>&quot;</b></font><font color="#ff40ff"><b>Wed Nov 19 14:34:12 EET 2003</b></font><font color="#ff40ff"><b>&quot;</b></font>
);

<font color="#ffff00"><b>sub</b></font><font color="#00ffff"><b> </b></font><font color="#00ffff"><b>event_whois</b></font><font color="#00ffff"><b> </b></font>{
    <font color="#ffff00"><b>my</b></font> <font color="#00ffff"><b>$country</b></font> = <font color="#ff40ff"><b>&quot;&quot;</b></font>;
    <font color="#ffff00"><b>my</b></font> <font color="#00ffff"><b>$database</b></font> = Irssi::settings_get_str(<font color="#ff40ff"><b>&quot;</b></font><font color="#ff40ff"><b>geoip_dat</b></font><font color="#ff40ff"><b>&quot;</b></font>);
    <font color="#ffff00"><b>my</b></font> (<font color="#00ffff"><b>$server</b></font>, <font color="#00ffff"><b>$data</b></font>, <font color="#00ffff"><b>$nick</b></font>, <font color="#00ffff"><b>$host</b></font>) = <font color="#00ffff"><b>@_</b></font>;
    <font color="#ffff00"><b>my</b></font> (<font color="#00ffff"><b>$me</b></font>, <font color="#00ffff"><b>$nick</b></font>, <font color="#00ffff"><b>$user</b></font>, <font color="#00ffff"><b>$host</b></font>) = <font color="#ffff00"><b>split</b></font>(<font color="#ff40ff"><b>&quot;</b></font><font color="#ff40ff"><b> </b></font><font color="#ff40ff"><b>&quot;</b></font>, <font color="#00ffff"><b>$data</b></font>);
    <font color="#ffff00"><b>my</b></font> <font color="#00ffff"><b>$gi</b></font> = Geo::IP-&gt;<font color="#ffff00"><b>open</b></font>(<font color="#00ffff"><b>$database</b></font>, GEOIP_STANDARD);
    <font color="#ffff00"><b>if</b></font> (<font color="#00ffff"><b>$host</b></font> =~<font color="#ffff00"><b> /</b></font><font color="#ff40ff"><b>^[0-9</b></font><font color="#ff6060"><b>\.</b></font><font color="#ff40ff"><b>]</b></font><font color="#ff6060"><b>*</b></font><font color="#ff40ff"><b>$</b></font><font color="#ffff00"><b>/</b></font>) {
        <font color="#00ffff"><b>$country</b></font> = <font color="#00ffff"><b>$gi</b></font>-&gt;country_name_by_addr(<font color="#00ffff"><b>$host</b></font>);
    } <font color="#ffff00"><b>else</b></font> {
        <font color="#00ffff"><b>$country</b></font> = <font color="#00ffff"><b>$gi</b></font>-&gt;country_name_by_name(<font color="#00ffff"><b>$host</b></font>);
    }
    <font color="#00ffff"><b>$server</b></font>-&gt;printformat(<font color="#00ffff"><b>$nick</b></font>, MSGLEVEL_CRAP, <font color="#ff40ff"><b>'</b></font><font color="#ff40ff"><b>whois_geoip</b></font><font color="#ff40ff"><b>'</b></font>, <font color="#00ffff"><b>$host</b></font>, <font color="#00ffff"><b>$country</b></font>);
}

<font color="#ffff00"><b>sub</b></font><font color="#00ffff"><b> </b></font><font color="#00ffff"><b>cmd_geoip</b></font><font color="#00ffff"><b> </b></font>{
    <font color="#ffff00"><b>my</b></font> <font color="#00ffff"><b>$country</b></font> = <font color="#ff40ff"><b>&quot;&quot;</b></font>;
    <font color="#ffff00"><b>my</b></font> <font color="#00ffff"><b>$database</b></font> = Irssi::settings_get_str(<font color="#ff40ff"><b>&quot;</b></font><font color="#ff40ff"><b>geoip_dat</b></font><font color="#ff40ff"><b>&quot;</b></font>);
    <font color="#ffff00"><b>my</b></font> <font color="#00ffff"><b>$host</b></font> = <font color="#ffff00"><b>lc</b></font> <font color="#ffff00"><b>shift</b></font>;
    <font color="#ffff00"><b>if</b></font> (<font color="#00ffff"><b>$host</b></font> <font color="#ffff00"><b>eq</b></font> <font color="#ff40ff"><b>&quot;&quot;</b></font>) {
        Irssi::<font color="#ffff00"><b>print</b></font>(<font color="#ff40ff"><b>&quot;</b></font><font color="#ff40ff"><b>USAGE: /GEOIP &lt;host/ip&gt;</b></font><font color="#ff40ff"><b>&quot;</b></font>);
        <font color="#ffff00"><b>return</b></font>;
    }
    <font color="#ffff00"><b>my</b></font> <font color="#00ffff"><b>$gi</b></font> = Geo::IP-&gt;<font color="#ffff00"><b>open</b></font>(<font color="#00ffff"><b>$database</b></font>, GEOIP_STANDARD);
    <font color="#ffff00"><b>if</b></font> (<font color="#00ffff"><b>$host</b></font> =~<font color="#ffff00"><b> /</b></font><font color="#ff40ff"><b>^[0-9</b></font><font color="#ff6060"><b>\.</b></font><font color="#ff40ff"><b>]</b></font><font color="#ff6060"><b>*</b></font><font color="#ff40ff"><b>$</b></font><font color="#ffff00"><b>/</b></font>) {
        <font color="#00ffff"><b>$country</b></font> = <font color="#00ffff"><b>$gi</b></font>-&gt;country_name_by_addr(<font color="#00ffff"><b>$host</b></font>);
    } <font color="#ffff00"><b>else</b></font> {
        <font color="#00ffff"><b>$country</b></font> = <font color="#00ffff"><b>$gi</b></font>-&gt;country_name_by_name(<font color="#00ffff"><b>$host</b></font>);
    }
    Irssi::<font color="#ffff00"><b>print</b></font>(<font color="#ff40ff"><b>&quot;</b></font><font color="#00ffff"><b>$host</b></font><font color="#ff40ff"><b> is in </b></font><font color="#00ffff"><b>$country</b></font><font color="#ff40ff"><b>&quot;</b></font>);
}

Irssi::theme_register([
    <font color="#ff40ff"><b>'</b></font><font color="#ff40ff"><b>whois_geoip</b></font><font color="#ff40ff"><b>'</b></font> =&gt; <font color="#ff40ff"><b>'</b></font><font color="#ff40ff"><b>{whois geoip %|$1}</b></font><font color="#ff40ff"><b>'</b></font>
]);

Irssi::command_bind(<font color="#ff40ff"><b>'</b></font><font color="#ff40ff"><b>geoip</b></font><font color="#ff40ff"><b>'</b></font>, <font color="#00ffff"><b>\&amp;cmd_geoip</b></font>);
Irssi::signal_add_last(<font color="#ff40ff"><b>'</b></font><font color="#ff40ff"><b>event 311</b></font><font color="#ff40ff"><b>'</b></font>, <font color="#ff40ff"><b>'</b></font><font color="#ff40ff"><b>event_whois</b></font><font color="#ff40ff"><b>'</b></font>);
Irssi::settings_add_str(<font color="#ff40ff"><b>&quot;</b></font><font color="#ff40ff"><b>misc</b></font><font color="#ff40ff"><b>&quot;</b></font>, <font color="#ff40ff"><b>&quot;</b></font><font color="#ff40ff"><b>geoip_dat</b></font><font color="#ff40ff"><b>&quot;</b></font>,
                                Irssi::get_irssi_dir() . <font color="#ff40ff"><b>&quot;</b></font><font color="#ff40ff"><b>/GeoIP.dat</b></font><font color="#ff40ff"><b>&quot;</b></font>);
</pre>
</body>
</html>
