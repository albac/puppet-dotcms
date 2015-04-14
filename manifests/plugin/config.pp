# == Class dotcms::plugin::config
#
# This class is called from dotcms for service config.
#
class dotcms::plugin::config(
  $root_plugin        = $::dotcms::root_plugin,
  $root_user          = $::dotcms::root_user,
  $root_group         = $::dotcms::root_group,
  $java_mem_max_size  = $::dotcms::params::java_mem_max_size,
  $java_mem_perm_size = $::dotcms::params::java_mem_perm_size,
  $postgres_host      = $::dotcms::postgres_host,
  $postgres_port      = $::dotcms::postgres_port,
  $postgres_username  = $::dotcms::postgres_username,
  $postgres_password  = $::dotcms::postgres_password,
) {

  File {
    owner  => $root_user,
    group  => $root_group,
    ensure => directory,
  }

  file { $root_plugin : }

  file { [ "$root_plugin/tomcat" , "$root_plugin/bin" ]:
    require => File[$root_plugin]
  }

  file { "$root_plugin/bin/startup.sh" :
    ensure  => present,
    content => template('dotcms/startup.sh.erb'),
    require => File["$root_plugin/bin"]
  }

  file { "$root_plugin/tomcat/conf" :
    require => File["$root_plugin/tomcat"]
  }

  file { "$root_plugin/tomcat/conf/Catalina" :
    require => File["$root_plugin/tomcat/conf"]
  }

  file { "$root_plugin/tomcat/conf/Catalina/localhost" :
    require => File["$root_plugin/tomcat/conf/Catalina"]
  }

  file { "$root_plugin/tomcat/conf/Catalina/server.xml" :
    ensure  => present,
    content => template('dotcms/server.xml.erb'),
    require => File["$root_plugin/tomcat/conf/Catalina"]
  }

  file { "$root_plugin/tomcat/conf/Catalina/localhost/ROOT.xml":
    ensure  => present,
    content => template('dotcms/ROOT.xml.erb'),
    require => File["$root_plugin/tomcat/conf/Catalina/localhost"]
  }

}
