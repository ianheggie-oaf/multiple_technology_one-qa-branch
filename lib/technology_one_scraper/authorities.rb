# frozen_string_literal: true

module TechnologyOneScraper
  AUTHORITIES = {
    blacktown: {
      url: "https://blacktown-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28",
      webguest: "BCC.P1.WEBGUEST"
    },
    campaspe: {
      url: "https://campaspe-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28",
      webguest: "SOC.WEBGUEST"
    },
    casey: {
      url: "https://casey-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28"
    },
    cassowary_coast: {
      url: "https://ccrc-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28"
    },
    cockburn: {
      url: "https://ecouncil.cockburn.wa.gov.au/eProperty",
      period: "TM"
    },
    corangamite: {
      url: "https://eservices.corangamite.vic.gov.au/T1PRprod/WebApps/eProperty",
      period: "L28",
      webguest: "CSC.WEBGUEST"
    },
    eurobodalla: {
      url: "https://esc-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28",
      webguest: "ESC.P1.WEBGUEST"
    },
    fremantle: {
      url: "https://fremantle-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28"
    },
    goulburn: {
      url: "https://gmc-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28"
    },
    hume: {
      url: "https://ehume.hume.vic.gov.au/T1PRProd/WebApps/eProperty",
      period: "L28",
      webguest: "P1.HCC.WEBGUEST",
      # Site has an incomplete certificate chain. See https://www.ssllabs.com/ssltest/analyze.html?d=ehume.hume.vic.gov.au&latest
      disable_ssl_certificate_check: true
    },
    kuringgai: {
      url: "https://eservices.kmc.nsw.gov.au/T1ePropertyProd",
      period: "TM",
      webguest: "KC_WEBGUEST",
      # Looks like it's blocking requests outside Australia
      australian_proxy: true
    },
    lithgow: {
      url: "https://lithgowcc-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L14"
    },
    lockyer_valley: {
      url: "https://lvrc-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28",
      webguest: "LV.WEBGUEST"
    },
    manningham: {
      url: "https://eproclaim.manningham.vic.gov.au/eProperty",
      period: "L28",
      australian_proxy: true
    },
    mid_coast: {
      url: "https://midcoast-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28"
    },
    mid_western: {
      url: "https://midwestern-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28"
    },
    mornington_peninsula: {
      url: "https://epeninsula.mornpen.vic.gov.au/P1PRPROD",
      period: "L28",
      # It looks like part of their certificate has expired (but I can't check
      # using ssllabs because they're blocking US traffic. Sigh.)
      disable_ssl_certificate_check: true,
      # Mornington peninsula is blocking requests from outside Australia
      australian_proxy: true
    },
    newcastle: {
      url: "https://cn-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      webguest: "TCON.LG.WEBGUEST",
      period: "L28"
    },
    noosa: {
      url: "https://noo-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "TM"
    },
    parkes: {
      url: "https://parkes-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28",
      webguest: "PSC.P1.WEBGUEST"
    },
    qprc: {
      url: "https://qprc-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28"
    },
    ryde: {
      url: "https://eservices.ryde.nsw.gov.au/T1PRProd/WebApps/eProperty",
      period: "TM",
      webguest: "COR.P1.WEBGUEST"
    },
    shellharbour: {
      url: "https://shbr-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28",
      webguest: "SCC.WEBGUEST"
    },
    southern_downs: {
      url: "https://sdrc-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28"
    },
    stirling: {
      url: "https://onlineservices.stirling.wa.gov.au/eProperty",
      period: "L28"
    },
    sutherland: {
      url: "https://propertydevelopment.ssc.nsw.gov.au/T1PRPROD/WebApps/eproperty",
      period: "TM",
      webguest: "SSC.P1.WEBGUEST",
      # ssslabs shows an incomplete certificate. Ugh.
      disable_ssl_certificate_check: true
    },
    tamworth: {
      url: "https://eproperty.tamworth.nsw.gov.au/T1PRProd/WebApps/eProperty",
      period: "L28",
      # Tamworth is blocking requests from outside Australia. You can verify this
      # yourself by scraping via a VPN and switch between different countries.
      # morph.io is hosted in the US. So, to get around this we send our
      # traffic to an australian proxy
      australian_proxy: true
    },
    wagga: {
      url: "https://eservices.wagga.nsw.gov.au/T1PRWeb/eProperty",
      period: "L14",
      webguest: "WW.P1.WEBGUEST"
    },
    wangaratta: {
      url: "https://rcow-web.t1cloud.com/T1PRDefault/WebApps/eProperty",
      period: "L28"
    },
    wyndham: {
      url: "https://eproperty.wyndham.vic.gov.au/ePropertyPROD",
      period: "L28"
    }
  }.freeze
end
