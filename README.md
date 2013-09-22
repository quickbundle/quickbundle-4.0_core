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
		eclipse-plugin/quickbundle-gp 项目生成器
		eclipse-plugin/quickbundle-mvm 模型虚拟机
		eclipse-plugin/quickbundle-gc 代码生成器

编译打包
----------------------------------------------------
### 一键编译qb-core的方式一？
updatesite格式的安装版，安装到Eclipse时较慢
		1，使用Linux下的ln -s(或windows下的junction)，把qb-archetype/quickbundle-rmwebdemo目录软链接到qb-core/eclipse-plugin/quickbundle-gp/t/j1目录。
		2，安装maven-3.0.5，在qb-core目录下，执行mvn install，即可安装到$M2_REPO/org/quickbundle/org.quickbundle.mda.updatesite/4.0.0/org.quickbundle.mda.updatesite-4.0.0.zip。


### 一键编译qb-core的方式二？
eclipse/plugins目录格式，直接复制到Eclipse下，安装快

		cd qb-archetype/build/build-rmwebdemo; 
		mvn clean package; 
		插件包是qb-archetype/build/build-rmwebdemo/target/eclipse，复制到$ECLIPSE_HOME/links/org.quickbundle目录即可完成安装
		
视频教程
----------------------------------------------------
1.[点此看视频教程](http://www.quickbundle.org)<br/>
