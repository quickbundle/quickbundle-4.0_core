<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://www.quickbundle.org" xmlns:fn="http://www.w3.org/2005/04/xpath-functions" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xdt="http://www.w3.org/2005/02/xpath-datatypes" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<!--导入全局定义-->
	<xsl:import href="../global.xsl"/>
	<!--忽略xml声明-->
	<xsl:output method="text" omit-xml-declaration="yes" encoding="UTF-8"/>
	<!--处理table-->
	<xsl:template match="myTables">

#<xsl:value-of select="$dbProductName"/>
jdbc.minPoolSize=1
jdbc.maxPoolSize=50
jdbc.validateTestSql=select 0 from dual
hibernate.dialect=org.hibernate.dialect.<xsl:choose>
<xsl:when test="$dbProductName='MySQL'">MySQLDialect</xsl:when>
<xsl:when test="$dbProductName='Oracle'">Oracle10gDialect</xsl:when>
<xsl:when test="$dbProductName='DB2'">DB2Dialect</xsl:when>
<xsl:when test="$dbProductName='Microsoft SQL Server'">SQLServerDialect</xsl:when>
<xsl:when test="$dbProductName='H2'">H2Dialect</xsl:when>
<xsl:when test="$dbProductName='HSQL Database Engine'">HSQLDialect</xsl:when>
<xsl:otherwise>ToManualConfigDialect</xsl:otherwise>
</xsl:choose>
jdbc.driverClassName=<xsl:value-of select="$driver"/>
jdbc.url=<xsl:value-of select="$url"/>
jdbc.username=<xsl:value-of select="$userName"/>
jdbc.password=<xsl:value-of select="$password"/>

	</xsl:template>
</xsl:stylesheet>
