quickbundle核心组件
====================================================

功能介绍
----------------------------------------------------
### 包含基础jar包5个:
		java-lib/quickbundle-tools  
		java-lib/quickbundle-core  
		java-lib/quickbundle-mybatis  
		java-lib/quickbundle-springweb  
		java-lib/quickbundle-struts  
	
### Eclipse插件
		eclipse-plugin/org.quickbundle.mda.libs
		eclipse-plugin/quickbundle-gp
		eclipse-plugin/quickbundle-mvm
		eclipse-plugin/quickbundle-gc

编译打包
----------------------------------------------------
### 一键编译qb-core的方式一？
		（updatesite格式的安装版，安装到Eclipse时较慢）
		1，使用Linux下的ln -s(或windows下的junction)，把qb-archetype/quickbundle-rmwebdemo目录软链接到qb-core/eclipse-plugin/quickbundle-gp/t/j1目录。
		2，安装maven-3.0.5，在qb-core目录下，执行mvn install，即可安装到$M2_REPO/org/quickbundle/org.quickbundle.mda.updatesite/4.0.0/org.quickbundle.mda.updatesite-4.0.0.zip。


### 一键编译qb-core的方式二？
		（eclipse/plugins目录格式，直接复制到Eclipse下，安装快）
		cd qb-archetype/build/build-rmwebdemo; 
		mvn clean package; 
		插件包是qb-archetype/build/build-rmwebdemo/target/eclipse，复制到$ECLIPSE_HOME/links/org.quickbundle目录即可完成安装