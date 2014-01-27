name "jetty9"
maintainer "Usman Ismail"
maintainer_email "usman@techtraits.com"
license "Apache 2.0"
description "Installs/Configures jetty"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version "0.0.1"

depends "java"

recipe "jetty9::install", "Installs and configures Jetty"