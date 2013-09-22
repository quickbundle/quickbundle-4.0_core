quickbundle核心组件
====================================================

功能介绍
----------------------------------------------------
### 包含基础jar包5个:
		java-lib/quickbundle-tools  基础工具jar包，是一些其它quickbundle-xxx.jar的基础
		java-lib/quickbundle-core  核心jar包，依赖于Spring
		java-lib/quickbundle-mybatis  mybatis扩展
		java-lib/quickbundle-springweb  spring mvc扩展
		java-lib/quickbundle-struts  struts1 扩展
	
### Eclipse插件
		eclipse-plugin/org.quickbundle.mda.libs  osgi下的jar包接入点
		eclipse-plugin/quickbundle-gp  项目生成器
		eclipse-plugin/quickbundle-mvm  模型虚拟机
		eclipse-plugin/quickbundle-gc  代码生成器
		
		eclipse-plugin/org.quickbundle.mda.feature  Eclipse插件组合的feature工程
		eclipse-plugin/org.quickbundle.mda.updatesite  Eclipse插件的在线/离线安装包的组合工程

编译打包
----------------------------------------------------
### 一键编译quickbundle-4.0.0插件的方式一（推荐）？
eclipse/plugins目录格式，直接复制到Eclipse下，安装快

		1，确保qb-core/eclipse-plugin/quickbundle-gp/t/j1下删掉了软链接目录quickbundle-rmwebdemo
		2，先安装qb-core到$M2_REPO。
			cd qb-core/
			mvn install -o 【-o表示离线模式，不用每次都检查tycho库】
		3，打包。
			cd qb-archetype/build/build-rmwebdemo
			mvn clean package
		4，安装插件包。
			复制qb-archetype/build/build-rmwebdemo/target/eclipse目录到$ECLIPSE_HOME/links/org.quickbundle目录
		5，重启Eclipse即可
		
### 一键编译quickbundle-4.0.0插件的方式二？
updatesite格式的安装版，安装到Eclipse时较慢

		1，使用Linux下的ln -s(或windows下的junction)，把qb-archetype/quickbundle-rmwebdemo目录软链接到qb-core/eclipse-plugin/quickbundle-gp/t/j1目录。
		2，安装maven-3.0.5，在qb-core目录下，执行mvn install，即可安装到$M2_REPO/org/quickbundle/org.quickbundle.mda.updatesite/4.0.0/org.quickbundle.mda.updatesite-4.0.0.zip。


		
视频教程
----------------------------------------------------
1.[到quickbundle主页看视频教程(即将发布)](http://www.quickbundle.org)<br/>
