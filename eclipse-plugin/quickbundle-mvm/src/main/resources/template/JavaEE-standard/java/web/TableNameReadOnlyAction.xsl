<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org" xmlns:fn="http://www.w3.org/2005/04/xpath-functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!--导入全局定义-->
	<xsl:import href="../../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="table">
		<xsl:param name="thisFilePathName">
			<xsl:value-of select="$TableNameActionPackage"/> --> <xsl:value-of select="$TableNameReadOnlyAction"/>.java</xsl:param>
		<xsl:value-of select="str:getJavaFileComment($thisFilePathName, $projectName, $authorName)"/>
package <xsl:value-of select="$TableNameActionPackage"/>;

import <xsl:value-of select="$ITableNameConstantsFullPath"/>;

<xsl:value-of select="str:getClassComment($authorName)"/>
public class <xsl:value-of select="$TableNameReadOnlyAction"/> extends <xsl:value-of select="$TableNameAction"/> implements <xsl:value-of select="$ITableNameConstants"/> {
	//通过<xsl:value-of select="$TableNameReadOnlyAction"/>的struts配置改变跳转
}
</xsl:template>
</xsl:stylesheet>
